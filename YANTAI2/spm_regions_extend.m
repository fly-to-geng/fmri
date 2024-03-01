function [Y,xY] = spm_regions_extend(xSPM,SPM,hReg,xY,Input_VOINames,Input_is,input_def,input_xyz,input_radius)
% VOI time-series extraction of adjusted data (& local eigenimage analysis)
% FORMAT [Y xY] = spm_regions(xSPM,SPM,hReg,[xY]);

% FORMAT [Y xY] = spm_regions(xSPM,SPM,hReg,[xY],Input_VOIName,Input_i)
% Input_VOIName : 抽取的VOI的名称
% Input_i : adjust_contrst 这里选择那个F-All的,整数，1 是dont adjust, 2 是F-All.
% Input_VOI_path : 抽取VOI所使用的Mask的路径;
% Input_is : Input_i
% input_def :  ROI类型的定义,sphere
% input_xyz :  MNI 坐标
% input_radius :  半径
if nargin < 4, xY = []; end

if nargin > 5
    Input_VOIName = Input_VOINames;
    Input_i =Input_is;
    xY = [];
    
end
%-Get figure handles
%--------------------------------------------------------------------------
Finter = spm_figure('FindWin','Interactive');
if isempty(Finter), noGraph = 1; else noGraph = 0; end
header = get(Finter,'Name');
set(Finter,'Name','VOI time-series extraction');
if ~noGraph, Fgraph = spm_figure('GetWin','Graphics'); end

%-Find nearest voxel [Euclidean distance] in point list
%--------------------------------------------------------------------------
% if isempty(xSPM.XYZmm)
%     spm('alert!','No suprathreshold voxels!',mfilename,0);
%     Y = []; xY = [];
%     return
% end
% try
%     xyz    = xY.xyz;
% catch
%     xyz    = spm_XYZreg('NearestXYZ',...
%              spm_XYZreg('GetCoords',hReg),xSPM.XYZmm);
%     xY.xyz = xyz;
% end

% and update GUI location
%--------------------------------------------------------------------------
%spm_XYZreg('SetCoords',xyz,hReg);


%-Get adjustment options and VOI name
%--------------------------------------------------------------------------
% if ~noGraph
%     if ~isempty(xY.xyz)
%         posstr = sprintf('at [%3.0f %3.0f %3.0f]',xY.xyz);
%     else
%         posstr = '';
%     end
%     spm_input(posstr,1,'d','VOI time-series extraction');
% end

if ~isfield(xY,'name')
    xY.name    = Input_VOIName; %name of region char字符串类型 ========================================================================
end

if ~isfield(xY,'Ic')
    q     = 0;
    Con   = {'<don''t adjust>'};
    for i = 1:length(SPM.xCon)
        if strcmp(SPM.xCon(i).STAT,'F')
            q(end + 1) = i;
            Con{end + 1} = SPM.xCon(i).name;
        end
    end
    i     = Input_i; % adjust_contrst 这里选择那个F-All的,整数，1 是dont adjust, 2 是F-All. =====================================================================
    xY.Ic = q(i);
end

%-If fMRI data then ask user to select session
%--------------------------------------------------------------------------
if isfield(SPM,'Sess') && ~isfield(xY,'Sess')
    s       = length(SPM.Sess);
    if s > 1
        s   = spm_input('which session','!+1','n1',s,s);
    end
    xY.Sess = s;
end

%-Specify VOI
%--------------------------------------------------------------------------
xY.M = xSPM.M;
[xY, xY.XYZmm, Q] = spm_ROI_extend(xY, xSPM.XYZmm,input_def,input_xyz,input_radius);%--------------------------------------------------------------------
try, xY = rmfield(xY,'M'); end
try, xY = rmfield(xY,'rej'); end

if isempty(xY.XYZmm)
    warning('Empty region.');
    Y = [];
    return;
end


%-Extract required data from results files
%==========================================================================
spm('Pointer','Watch')

%-Get raw data, whiten and filter 
%--------------------------------------------------------------------------
y        = spm_get_data(SPM.xY.VY,xSPM.XYZ(:,Q));
y        = spm_filter(SPM.xX.K,SPM.xX.W*y);


%-Computation
%==========================================================================

%-Remove null space of contrast
%--------------------------------------------------------------------------
if xY.Ic

    %-Parameter estimates: beta = xX.pKX*xX.K*y
    %----------------------------------------------------------------------
    beta  = spm_get_data(SPM.Vbeta,xSPM.XYZ(:,Q));

    %-subtract Y0 = XO*beta,  Y = Yc + Y0 + e
    %----------------------------------------------------------------------
    y     = y - spm_FcUtil('Y0',SPM.xCon(xY.Ic),SPM.xX.xKXs,beta);

end

%-Confounds
%--------------------------------------------------------------------------
xY.X0     = SPM.xX.xKXs.X(:,[SPM.xX.iB SPM.xX.iG]);

%-Extract session-specific rows from data and confounds
%--------------------------------------------------------------------------
try
    i     = SPM.Sess(xY.Sess).row;
    y     = y(i,:);
    xY.X0 = xY.X0(i,:);
end

% and add session-specific filter confounds
%--------------------------------------------------------------------------
try
    xY.X0 = [xY.X0 SPM.xX.K(xY.Sess).X0];
end
try
    xY.X0 = [xY.X0 SPM.xX.K(xY.Sess).KH]; % Compatibility check
end

%-Remove null space of X0
%--------------------------------------------------------------------------
xY.X0     = xY.X0(:,any(xY.X0));


%-Compute regional response in terms of first eigenvariate
%--------------------------------------------------------------------------
[m n]   = size(y);
if m > n
    [v s v] = svd(y'*y);
    s       = diag(s);
    v       = v(:,1);
    u       = y*v/sqrt(s(1));
else
    [u s u] = svd(y*y');
    s       = diag(s);
    u       = u(:,1);
    v       = y'*u/sqrt(s(1));
end
d       = sign(sum(v));
u       = u*d;
v       = v*d;
Y       = u*sqrt(s(1)/n);

%-Set in structure
%--------------------------------------------------------------------------
xY.y    = y;
xY.u    = Y;
xY.v    = v;
xY.s    = s;

%-Display VOI weighting and eigenvariate
%==========================================================================
if ~noGraph
    
    % show position
    %----------------------------------------------------------------------
    spm_results_ui('Clear',Fgraph);
    h1 = figure(Fgraph);
    subplot(2,2,3)
    spm_dcm_display(xY)

    % show dynamics
    %----------------------------------------------------------------------
    subplot(2,2,4)
    try
        plot(SPM.xY.RT*[1:length(xY.u)],Y)
        str = 'time (seconds}';
    catch
        plot(Y)
        str = 'scan';
    end
    title(['1st eigenvariate: ' xY.name],'FontSize',10)
    if strcmpi(xY.def,'mask')
        [p,n,e] = fileparts(xY.spec.fname);
        posstr  = sprintf('from mask %s', [n e]);
    else
        posstr  = sprintf('at [%3.0f %3.0f %3.0f]',xY.xyz);
    end
    str = { str;' ';...
        sprintf('%d voxels in VOI %s',length(Q),posstr);...
        sprintf('Variance: %0.2f%%',s(1)*100/sum(s))};
    xlabel(str)
    axis tight square
end

%-Save
%==========================================================================
str = ['VOI_' xY.name '.mat'];
if isfield(xY,'Sess') && isfield(SPM,'Sess')
    str = sprintf('VOI_%s_%i.mat',xY.name,xY.Sess);
end
if spm_check_version('matlab','7') >= 0
    save(fullfile(SPM.swd,str),'-V6','Y','xY')
else
    save(fullfile(SPM.swd,str),'Y','xY')
end

fprintf('   VOI saved as %s\n',spm_str_manip(fullfile(SPM.swd,str),'k55'));

%-Reset title
%--------------------------------------------------------------------------
set(Finter,'Name',header);
spm('Pointer','Arrow')
print(h1,Input_VOINames,'-dpng');% 打印出PNG图片，还可以输出其他的格式，参考Matlab的print函数。
