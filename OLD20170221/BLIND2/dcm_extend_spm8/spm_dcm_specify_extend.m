function DCM = spm_dcm_specify_extend(spmmatfile,name,VOIs,condition_mask,TE,Input_a,Input_b,Input_c)
% Specify inputs of a DCM
% FORMAT [DCM] = spm_dcm_specify
%
% DCM  - the DCM structure (see spm_dcm_ui)
%__________________________________________________________________________
% Copyright (C) 2008 Wellcome Trust Centre for Neuroimaging

% Karl Friston
% $Id: spm_dcm_specify.m 4185 2011-02-01 18:46:18Z guillaume $


%-Interactive window
%--------------------------------------------------------------------------
Finter = spm_figure('GetWin','Interactive');
bcolor = get(Finter,'color');
WS     = spm('WinScale');
dx     = 20;

spm_input('Specify DCM:...  ',1,'d');

%==========================================================================
% Get design and directory
%==========================================================================
%[spmmatfile, sts] = spm_select(1,'^SPM\.mat$','Select SPM.mat');
%spmmatfile = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\20160716002\SPM.mat';
sts = 1;
if ~sts, DCM = []; return; end
swd = spm_str_manip(spmmatfile,'H');
try
    load(fullfile(swd,'SPM.mat'))
catch
    error(['Cannot read ' fullfile(swd,'SPM.mat')]);
end


%==========================================================================
% Name
%==========================================================================
%name  = spm_input('name for DCM_???.mat','+1','s');
%name = 'HG_DCM';

%==========================================================================
% Outputs
%==========================================================================

%-Get cell array of region structures
%--------------------------------------------------------------------------
% VOI1_path = 'd:\fmri_root\yantai\aNALYSIS\first_level_dcm_w_whole\20160716002\VOI_HG_DW_1.mat';
% VOI2_path = 'd:\fmri_root\yantai\aNALYSIS\first_level_dcm_w_whole\20160716002\VOI_MFG_DW_1.mat';
% VOI3_path = 'd:\fmri_root\yantai\aNALYSIS\first_level_dcm_w_whole\20160716002\VOI_STG_DW_1.mat';
% VOIs = {VOI1_path;VOI2_path;VOI3_path};
%P     = cellstr(spm_select([1 8],'^VOI.*\.mat$',{'select VOIs'},'',swd));
P = VOIs;
m     = numel(P);
for i = 1:m
    p     = load(P{i},'xY');
    xY(i) = p.xY;
end


%==========================================================================
% Inputs
%==========================================================================

%-Get (nc) 'causes' or inputs U
%--------------------------------------------------------------------------
spm_input('Input specification:...  ',1,'d');
Sess   = SPM.Sess(xY(1).Sess);
%condition_mask = [1,0,0,0]; % 配置包含哪个条件，不包含哪个条件�?
if isempty(Sess.U)
    % spontaneous activity, i.e. no stimuli
    nc = 0;
    U = [];
else
    % with stimuli
    U.dt   = Sess.U(1).dt;
    u      = length(Sess.U);
    U.name = {};
    U.u    = [];
    for  i = 1:u  %i 是条件的编号  1�?JX�? 2�?DW   3�?RL 4�?ZR
        for j = 1:length(Sess.U(i).name)
            str = ['include ' Sess.U(i).name{j} '?'];  % include JX
            if condition_mask(i)%spm_input(str,'+1','y/n',[1 0],1)   include JX20 ,yes 1 ; no 0;
                U.u             = [U.u Sess.U(i).u(33:end,j)];
                U.name{end + 1} = Sess.U(i).name{j};
            end
        end
    end
    nc     = size(U.u,2);
end

%==========================================================================
% Timings
%==========================================================================

spm_input('Timing information:...  ',-1,'d');

%-Slice timings
%--------------------------------------------------------------------------
RT     = SPM.xY.RT;
%delays = spm_input('Slice timings [s]','+1','r', repmat(RT,1,m),m,[0 RT]);
delays = repmat(RT,1,m)';
%-Echo time (TE) of data acquisition
%--------------------------------------------------------------------------
%TE    = 0.04;  %==================================================================自己输入TE的�?====================
TE_ok = 0;
while ~TE_ok
    %TE = spm_input('Echo time, TE [s]', '+1', 'r', TE);
    if ~TE || (TE < 0) || (TE > 0.1)
        str = { 'Extreme value for TE or TE undefined.',...
            'Please re-enter TE (in seconds!)'};
        spm_input(str,'+1','bd','OK',[1],1);
    else
        TE_ok = 1;
    end
end


%==========================================================================
% Model options
%==========================================================================
if nc                                                     % there are inputs
    spm_input('Model options:...  ',-1,'d');
    %options.nonlinear  = spm_input('modulatory effects','+1','b',{'bilinear','nonlinear'},[0 1],1);  
    options.nonlinear = 0; %modulatory effects :  0: bilinear  , 1: nonlinear
	%options.two_state  = spm_input('states per region', '+1','b',{'one','two'},[0 1],1);
	options.two_state = 0 ; % states per region ; 0: one  ; 1 : two
    %options.stochastic = spm_input('stochastic effects','+1','b',{'no','yes'},[0 1],1);
	options.stochastic = 0 ; %stochastic effects; 0 : no ; 1 : yes,
    %options.centre     = spm_input('centre input',      '+1','b',{'no','yes'},[0 1],1);
	options.centre = 0 ; % centre input ; 0 : no 1: yes;
    options.endogenous = 0;
else
    options.nonlinear  = 0;
    options.two_state  = 0;
    options.stochastic = 1;
    options.centre     = 1;
    options.endogenous = 1;
end

%==========================================================================
% Graph connections
%==========================================================================
a     = zeros(m,m);
if options.endogenous
    b     = zeros(m,m,1);
    c     = zeros(m,1);
else
    b     = zeros(m,m,nc);
    c     = zeros(m,nc);
end
d     = zeros(m,m,0);

%-Intrinsic connections (A matrix)
%==========================================================================

%-Buttons and labels
%--------------------------------------------------------------------------
spm_input('Specify intrinsic connections from',1,'d')
spm_input('to',3,'d')
for i = 1:m
    str    = sprintf('%s %i',xY(i).name,i);
    h1(i)  = uicontrol(Finter,'String',str,...
        'Style','text',...
        'FontSize',10,...
        'BackgroundColor',bcolor,...
        'HorizontalAlignment','right',...
        'Position',[080 350-dx*i 080 020].*WS);
    h2(i)  = uicontrol(Finter,'String',sprintf('%i',i),...
        'Style','text',...
        'FontSize',10,...
        'BackgroundColor',bcolor,...
        'Position',[180+dx*i 350 010 020].*WS);
end
for i = 1:m
    for j = 1:m
        h3(i,j) = uicontrol(Finter,...
            'Position',[180+dx*j 350-dx*i 020 020].*WS,...
            'BackgroundColor',bcolor,...
            'Style','radiobutton');
        if i == j
            set(h3(i,j),'Value',1,...
                'enable','off');
        else
            set(h3(i,j),'enable','on','TooltipString', ...
                sprintf('from %s to %s',xY(j).name,xY(i).name));
        end
        if nc && i~=j
            set(h3(i,j),'Value',0);
        else
            set(h3(i,j),'Value',1);
        end
    end
end
uicontrol(Finter,'String','done','Position', [300 100 060 020].*WS,...
    'Callback', 'uiresume(gcbf)');

%uiwait(Finter);

%-Get a  a 就是DCM模型的连接矩�?
%--------------------------------------------------------------------------
%for i = 1:m
%    for j = 1:m
%       a(i,j) = get(h3(i,j),'Value');
%   end
%end
%a = [1,1,1;1,1,1;1,1,1];  %=========================================================定义的DCM模型，此处有三个节点，所以是3*3的矩阵；
a = Input_a;
delete(findobj(get(Finter,'Children'),'flat'));

%-Effects of causes (B and C matrices)
%==========================================================================
uicontrol(Finter,'String','done','Position', [300 100 060 020].*WS,...
    'Callback', 'uiresume(gcbf)');
for k = 1:nc

    %-Buttons and labels
    %----------------------------------------------------------------------
    str   = sprintf(...
        'Effects of %-12s on regions... and connections',...
        U.name{k});
    spm_input(str,1,'d');      % Effects of JX           on regions... and connections

    for i = 1:m
        h1(i)  = uicontrol(Finter,'String',xY(i).name,...
            'Style','text',...
            'BackgroundColor',bcolor,...
            'FontSize',10,...
            'Position',[080 350-dx*i 080 020].*WS);
        h2(i)  = uicontrol(Finter,...
            'Position',[160 360-dx*i 020 020].*WS,...
            'BackgroundColor',bcolor,...
            'Style','radiobutton');
    end
    for i = 1:m
        for j = 1:m
            if a(i,j) == 1

                % Allow modulation of intrinsic connections
                %----------------------------------------------------------
                h3(i,j) = uicontrol(Finter,...
                    'Position',[220+dx*j 360-dx*i 020 020].*WS,...
                    'BackgroundColor',bcolor,...
                    'Style','radiobutton');
                set(h3(i,j),'TooltipString', ...
                    sprintf('from %s to %s',xY(j).name,xY(i).name));

            end
        end
    end

    %uiwait(Finter);

    %-Get c   就是左边的第�?��，代表输入加在那个脑区上�? * 1
    %----------------------------------------------------------------------
    %for i = 1:m
        %c(i,k)   = get(h2(i),'Value');
    %end
	%c = [1,0,0];
    c = Input_c;
    %-Get b allowing any 2nd order effects   3*3 的矩阵，代表调节变量在哪条线上�?这里有三个区域，�?���?*3
    %----------------------------------------------------------------------
    % for i = 1:m
        % for j = 1:m
            % if a(i,j)==1
                % b(i,j,k) = get(h3(i,j),'Value');
            % end
        % end
    % end
	%b = [0,0,0;0,0,0;0,0,0];
    b = Input_b;
    delete([h1(:); h2(:); h3(a==1)])

end
delete(findobj(get(Finter,'Children'),'flat'));


%-Effects of nonlinear modulations (D matrices)
%==========================================================================
if options.nonlinear
    uicontrol(Finter,'String','done','Position', [300 100 060 020].*WS,...
        'Callback', 'uiresume(gcbf)');
    for k = 1:m

        %-Buttons and labels
        %------------------------------------------------------------------
        str = sprintf('Effects of %-12s activity on connections',xY(k).name);
        spm_input(str,1,'d');

        for i = 1:m
            for j = 1:m
                if a(i,j)==1

                    % Allow modulation of intrinsic connections
                    %------------------------------------------------------
                    h4(i,j) = uicontrol(Finter,...
                        'Position',[220+dx*j 360-dx*i 020 020].*WS,...
                        'BackgroundColor',bcolor,...
                        'Style','radiobutton');
                end
            end
        end

        uiwait(Finter);

        %-Get d allowing any 2nd order effects
        %------------------------------------------------------------------
        for i = 1:m
            for j = 1:m
                if a(i,j)==1
                    d(i,j,k) = get(h4(i,j),'Value');
                end
            end
        end
        delete(h4(a==1))

    end
end

delete(findobj(get(Finter,'Children'),'flat'));
spm_input('Thank you',1,'d')


%==========================================================================
% Response
%==========================================================================

%-Response variables & confounds (NB: the data have been whitened)
%--------------------------------------------------------------------------
n     = length(xY);                      % number of regions
v     = length(xY(1).u);                 % number of time points
Y.dt  = SPM.xY.RT;
Y.X0  = xY(1).X0;
for i = 1:n
    Y.y(:,i)  = xY(i).u;
    Y.name{i} = xY(i).name;
end

%-Error precision components (one for each region) - i.i.d. (because of W)
%--------------------------------------------------------------------------
Y.Q        = spm_Ce(ones(1,n)*v);


%==========================================================================
% DCM structure
%==========================================================================

% Endogenous input specification
if isempty(U)
    U.u    = zeros(v,1);
    U.name = {'null'};
end

%-Store all variables in DCM structure
%--------------------------------------------------------------------------
DCM.a       = a;
DCM.b       = b;
DCM.c       = c;
DCM.d       = d;
DCM.U       = U;
DCM.Y       = Y;
DCM.xY      = xY;
DCM.v       = v;
DCM.n       = n;
DCM.TE      = TE;
DCM.delays  = delays;
DCM.options = options;

%-Save
%--------------------------------------------------------------------------
if spm_check_version('matlab','7') >= 0
    save(fullfile(swd,['DCM_' name '.mat']),'-V6','DCM');
else
    save(fullfile(swd,['DCM_' name '.mat']),'DCM');
end
