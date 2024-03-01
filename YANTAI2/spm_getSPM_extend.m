function [SPM,xSPM] = spm_getSPM_extend(varargin)
% Compute a specified and thresholded SPM/PPM following estimation
% FORMAT [SPM,xSPM] = spm_getSPM;
% Query SPM in interactive mode.
%
% FORMAT [SPM,xSPM] = spm_getSPM(xSPM);
% Query SPM in batch mode. See below for a description of fields that may
% be present in xSPM input. Values for missing fields will be queried
% interactively.

%FORMAT [SPM,xSPM] = spm_getSPM(spm_mat_path,InputIC,InputMask，InputthresDesc，Input_u);
% spm_mat_path : SPM.mat path
% InputIC : 选择设置的第几个Contrast,整数�?
% InputMask;  %  0 none  1 contrast  2 image ============
% InputthresDesc ;  %===p value adjustment to control: 'FWE' or 'none'==
% Input_u; %threshold  默认0.001====

%-GUI setup
%--------------------------------------------------------------------------
spm_help('!ContextHelp',mfilename)
spm('Pointer','Arrow')

%-Select SPM.mat & note SPM results directory
%--------------------------------------------------------------------------
if nargin == 1
    xSPM = varargin{1};
end
if nargin > 1
    spm_mat_path = varargin{1};
	InputIC = varargin{2};
    InputMask = varargin{3};
    InputthresDesc = varargin{4};
    Input_u = varargin{5};
    Input_k = varargin{6};
end
try
    swd = xSPM.swd;
    sts = 1;
catch
    sts = 1;
    spmmatfile = spm_mat_path;
    swd = spm_str_manip(spmmatfile,'H');
end
if ~sts, SPM = []; xSPM = []; return; end

%-Preliminaries...
%==========================================================================

%-Load SPM.mat
%--------------------------------------------------------------------------
try
    load(fullfile(swd,'SPM.mat'));
catch
    error(['Cannot read ' fullfile(swd,'SPM.mat')]);
end
SPM.swd = swd;


%-Change directory so that relative filenames are valid
%--------------------------------------------------------------------------
cd(SPM.swd);

%-Check the model has been estimated
%--------------------------------------------------------------------------
try
    SPM.xVol.S;
catch
    
    %-Check the model has been estimated
    %----------------------------------------------------------------------
    str = { 'This model has not been estimated.';...
            'Would you like to estimate it now?'};
    if spm_input(str,1,'bd','yes|no',[1,0],1)
        SPM = spm_spm(SPM);
    else
        SPM = []; xSPM = [];
        return
    end
end

xX   = SPM.xX;                      %-Design definition structure
XYZ  = SPM.xVol.XYZ;                %-XYZ coordinates
S    = SPM.xVol.S;                  %-search Volume {voxels}
R    = SPM.xVol.R;                  %-search Volume {resels}
M    = SPM.xVol.M(1:3,1:3);         %-voxels to mm matrix
VOX  = sqrt(diag(M'*M))';           %-voxel dimensions

%==========================================================================
% - C O N T R A S T S ,   S P M    C O M P U T A T I O N ,    M A S K I N G
%==========================================================================

%-Get contrasts
%--------------------------------------------------------------------------
try, xCon = SPM.xCon; catch, xCon = {}; end

try
    Ic        = xSPM.Ic;
catch
    Ic = InputIC;
end
if isempty(xCon)
    % figure out whether new contrasts were defined, but not selected
    % do this by comparing length of SPM.xCon to xCon, remember added
    % indices to run spm_contrasts on them as well
    try
        noxCon = numel(SPM.xCon);
    catch
        noxCon = 0;
    end
    IcAdd = (noxCon+1):numel(xCon);
else
    IcAdd = [];
end

nc        = length(Ic);  % Number of contrasts

%-Allow user to extend the null hypothesis for conjunctions
%
% n: conjunction number
% u: Null hyp is k<=u effects real; Alt hyp is k>u effects real
%    (NB Here u is from Friston et al 2004 paper, not statistic thresh).
%                  u         n
% Conjunction Null nc-1      1     |    u = nc-n
% Intermediate     1..nc-2   nc-u  |    #effects under null <= u
% Global Null      0         nc    |    #effects under alt  > u,  >= u+1
%----------------------------------+---------------------------------------
if nc > 1
    try
        n = xSPM.n;
    catch
        if nc==2
            But = 'Conjunction|Global';      Val=[1 nc];
        else
            But = 'Conj''n|Intermed|Global'; Val=[1 NaN nc];
        end
        n = spm_input('Null hyp. to assess?','+1','b',But,Val,1);
        if isnan(n)
            if nc == 3,
                n = nc - 1;
            else
                n = nc - spm_input('Effects under null ','0','n1','1',nc-1);
            end
        end
    end
else
    n = 1;
end

%-Enforce orthogonality of multiple contrasts for conjunction
% (Orthogonality within subspace spanned by contrasts)
%--------------------------------------------------------------------------
if nc > 1 && n > 1 && ~spm_FcUtil('|_?',xCon(Ic), xX.xKXs)
    
    OrthWarn = 0;
    
    %-Successively orthogonalise
    %-NB: This loop is peculiarly controlled to account for the
    %     possibility that Ic may shrink if some contrasts disappear
    %     on orthogonalisation (i.e. if there are colinearities)
    %----------------------------------------------------------------------
    i = 1;
    while(i < nc), i = i + 1;
        
        %-Orthogonalise (subspace spanned by) contrast i w.r.t. previous
        %------------------------------------------------------------------
        oxCon = spm_FcUtil('|_',xCon(Ic(i)), xX.xKXs, xCon(Ic(1:i-1)));
        
        %-See if this orthogonalised contrast has already been entered
        % or is colinear with a previous one. Define a new contrast if
        % neither is the case.
        %------------------------------------------------------------------
        d     = spm_FcUtil('In',oxCon,xX.xKXs,xCon);
        
        if spm_FcUtil('0|[]',oxCon,xX.xKXs)
            
            %-Contrast was colinear with a previous one - drop it
            %--------------------------------------------------------------
            Ic(i) = [];
            i     = i - 1;
            
        elseif any(d)
            
            %-Contrast unchanged or already defined - note index
            %--------------------------------------------------------------
            Ic(i) = min(d);
            
        else
            
            %-Define orthogonalised contrast as new contrast
            %--------------------------------------------------------------
            OrthWarn   = OrthWarn + 1;
            conlst     = sprintf('%d,',Ic(1:i-1));
            oxCon.name = sprintf('%s (orth. w.r.t {%s})', xCon(Ic(i)).name,...
                                  conlst(1:end-1));
            xCon       = [xCon, oxCon];
            Ic(i)      = length(xCon);
        end
        
    end % while...
    
    if OrthWarn
        warning('SPM:ConChange','%d contrasts orthogonalized',OrthWarn)
    end
    
    SPM.xCon = xCon;
end % if nc>1...
SPM.xCon = xCon;

%-Apply masking
%--------------------------------------------------------------------------
try
    Mask = ~isempty(xSPM.Im) * (isnumeric(xSPM.Im) + 2*iscellstr(xSPM.Im));
catch
    % Mask = spm_input('mask with other contrast(s)','+1','y/n',[1,0],2);
    Mask = InputMask;  %  0 none  1 contrast  2 image =================================================
end
if Mask == 1
    
    %-Get contrasts for masking
    %----------------------------------------------------------------------
    try
        Im = xSPM.Im;
    catch
        [Im,xCon] = spm_conman(SPM,'T&F',-Inf,...
            'Select contrasts for masking...',' for masking',1);
    end
    
    %-Threshold for mask (uncorrected p-value)
    %----------------------------------------------------------------------
    try
        pm = xSPM.pm;
    catch
        pm = spm_input('uncorrected mask p-value','+1','r',0.05,1,[0,1]);
    end
    
    %-Inclusive or exclusive masking
    %----------------------------------------------------------------------
    try
        Ex = xSPM.Ex;
    catch
        Ex = spm_input('nature of mask','+1','b','inclusive|exclusive',[0,1],1);
    end
    
elseif Mask == 2
    
    %-Get mask images
    %----------------------------------------------------------------------
    try
        Im = xSPM.Im;
    catch
        Im = cellstr(spm_select([1 Inf],'image','Select mask image(s)'));
    end
    
    %-Inclusive or exclusive masking
    %----------------------------------------------------------------------
    try
        Ex = xSPM.Ex;
    catch
        Ex = spm_input('nature of mask','+1','b','inclusive|exclusive',[0,1],1);
    end
    
    pm = [];
    
else
    Im = [];
    pm = [];
    Ex = [];
end


%-Create/Get title string for comparison
%--------------------------------------------------------------------------
if nc == 1
    str  = xCon(Ic).name;
else
    str  = [sprintf('contrasts {%d',Ic(1)),sprintf(',%d',Ic(2:end)),'}'];
    if n == nc
        str = [str ' (global null)'];
    elseif n == 1
        str = [str ' (conj. null)'];
    else
        str = [str sprintf(' (Ha: k>=%d)',(nc-n)+1)];
    end
end
if Ex
    mstr = 'masked [excl.] by';
else
    mstr = 'masked [incl.] by';
end
if isnumeric(Im)
    if length(Im) == 1
        str = sprintf('%s (%s %s at p=%g)',str,mstr,xCon(Im).name,pm);
    elseif ~isempty(Im)
        str = [sprintf('%s (%s {%d',str,mstr,Im(1)),...
            sprintf(',%d',Im(2:end)),...
            sprintf('} at p=%g)',pm)];
    end
elseif iscellstr(Im) && numel(Im) > 0
    [pf,nf,ef] = spm_fileparts(Im{1});
    str  = sprintf('%s (%s %s',str,mstr,[nf ef]);
    for i=2:numel(Im)
        [pf,nf,ef] = spm_fileparts(Im{i});
        str =[str sprintf(', %s',[nf ef])];
    end
    str = [str ')'];
end
try
    titlestr = xSPM.title;
    if isempty(titlestr)
        titlestr = str;
    end
catch
    titlestr = str;% 名称，可以自定义========================================================================
end


%-Bayesian or classical Inference?
%==========================================================================
if isfield(SPM,'PPM')
    
    % Make sure SPM.PPM.xCon field exists
    %----------------------------------------------------------------------
    if ~isfield(SPM.PPM,'xCon')
        SPM.PPM.xCon = [];
    end
    
    % Set Bayesian con type
    %----------------------------------------------------------------------
    SPM.PPM.xCon(Ic).PSTAT = xCon(Ic).STAT;
    
    % Make all new contrasts Bayesian contrasts 
    %----------------------------------------------------------------------
    [xCon(Ic).STAT] = deal('P');
    
    if all(strcmp([SPM.PPM.xCon(Ic).PSTAT],'T'))
        
        % Simple contrast
        %------------------------------------------------------------------
        str = 'Effect size threshold for PPM';
        
        if isfield(SPM.PPM,'VB') % 1st level Bayes
            
            % For VB - set default effect size to zero
            %--------------------------------------------------------------
            Gamma = 0;
            xCon(Ic).eidf = spm_input(str,'+1','e',sprintf('%0.2f',Gamma));
            
        elseif nc == 1 && isempty(xCon(Ic).Vcon) % 2nd level Bayes
            % con image not yet written
            %--------------------------------------------------------------
            if spm_input('Inference',1,'b',{'Bayesian','classical'},[1 0]);
                
                %-Get Bayesian threshold (Gamma) stored in xCon(Ic).eidf
                % The default is one conditional s.d. of the contrast
                %----------------------------------------------------------
                Gamma         = sqrt(xCon(Ic).c'*SPM.PPM.Cb*xCon(Ic).c);
                xCon(Ic).eidf = spm_input(str,'+1','e',sprintf('%0.2f',Gamma));
                xCon(Ic).STAT = 'P';
            end
        end
    else
        % Compound contrast using Chi^2 statistic
        %------------------------------------------------------------------
        if ~isfield(xCon(Ic),'eidf') || isempty(xCon(Ic).eidf)
            xCon(Ic).eidf = 0; % temporarily
        end
    end
end


%-Compute & store contrast parameters, contrast/ESS images, & SPM images
%==========================================================================
SPM.xCon = xCon;
if isnumeric(Im)
    SPM  = spm_contrasts(SPM, unique([Ic, Im, IcAdd]));
else
    SPM  = spm_contrasts(SPM, unique([Ic, IcAdd]));
end
xCon     = SPM.xCon;
STAT     = xCon(Ic(1)).STAT;
VspmSv   = cat(1,xCon(Ic).Vspm);

%-Check conjunctions - Must be same STAT w/ same df
%--------------------------------------------------------------------------
if (nc > 1) && (any(diff(double(cat(1,xCon(Ic).STAT)))) || ...
                any(abs(diff(cat(1,xCon(Ic).eidf))) > 1))
    error('illegal conjunction: can only conjoin SPMs of same STAT & df');
end


%-Degrees of Freedom and STAT string describing marginal distribution
%--------------------------------------------------------------------------
df     = [xCon(Ic(1)).eidf xX.erdf];
if nc > 1
    if n > 1
        str = sprintf('^{%d \\{Ha:k\\geq%d\\}}',nc,(nc-n)+1);
    else
        str = sprintf('^{%d \\{Ha:k=%d\\}}',nc,(nc-n)+1);
    end
else
    str = '';
end

switch STAT
    case 'T'
        STATstr = sprintf('%c%s_{%.0f}','T',str,df(2));
    case 'F'
        STATstr = sprintf('%c%s_{%.0f,%.0f}','F',str,df(1),df(2));
    case 'P'
        STATstr = sprintf('%s^{%0.2f}','PPM',df(1));
end


%-Compute (unfiltered) SPM pointlist for masked conjunction requested
%==========================================================================
fprintf('\t%-32s: %30s','SPM computation','...initialising')            %-#


%-Compute conjunction as minimum of SPMs
%--------------------------------------------------------------------------
Z     = Inf;
for i = Ic
    Z = min(Z,spm_get_data(xCon(i).Vspm,XYZ));
end


%-Copy of Z and XYZ before masking, for later use with FDR
%--------------------------------------------------------------------------
XYZum = XYZ;
Zum   = Z;

%-Compute mask and eliminate masked voxels
%--------------------------------------------------------------------------
for i = 1:numel(Im)
    
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...masking')           %-#
    if isnumeric(Im)
        Mask = spm_get_data(xCon(Im(i)).Vspm,XYZ);
        um   = spm_u(pm,[xCon(Im(i)).eidf,xX.erdf],xCon(Im(i)).STAT);
        if Ex
            Q = Mask <= um;
        else
            Q = Mask >  um;
        end
    else
        v = spm_vol(Im{i});
        Mask = spm_get_data(v,v.mat\SPM.xVol.M*[XYZ; ones(1,size(XYZ,2))]);
        Q = Mask ~= 0 & ~isnan(Mask);
        if Ex, Q = ~Q; end
    end
    XYZ   = XYZ(:,Q);
    Z     = Z(Q);
    if isempty(Q)
        fprintf('\n')                                                   %-#
        warning('SPM:NoVoxels','No voxels survive masking at p=%4.2f',pm);
        break
    end
end


%==========================================================================
% - H E I G H T   &   E X T E N T   T H R E S H O L D S
%==========================================================================

u   = -Inf;        % height threshold
k   = 0;           % extent threshold {voxels}

%-Get FDR mode
%--------------------------------------------------------------------------
try
    topoFDR = spm_get_defaults('stats.topoFDR');
catch
    topoFDR = true;
end

%-Height threshold - classical inference
%--------------------------------------------------------------------------
if STAT ~= 'P'
    
    %-Get height threshold
    %----------------------------------------------------------------------
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...height threshold')  %-#
    try
        thresDesc = xSPM.thresDesc;
    catch
        if topoFDR
            str = 'FWE|none';
        else
            str = 'FWE|FDR|none';
        end
        thresDesc = InputthresDesc;%===p value adjustment to control: 'FWE' or 'none'====================================================================
    end
    
    switch thresDesc
        
        case 'FWE' % Family-wise false positive rate
            %--------------------------------------------------------------
            try
                u = xSPM.u;
            catch
                u = spm_input('p value (FWE)','+0','r',0.05,1,[0,1]);
            end
            thresDescDes = ['p<' num2str(u) ' (' thresDesc ')'];
            u = spm_uc(u,df,STAT,R,n,S);
            
            
        case 'FDR' % False discovery rate
            %--------------------------------------------------------------
            if topoFDR,
                fprintf('\n');                                          %-#
                error('Change defaults.stats.topoFDR to use voxel FDR');
            end
            try
                u = xSPM.u;
            catch
                u = spm_input('p value (FDR)','+0','r',0.05,1,[0,1]);
            end
            thresDescDes = ['p<' num2str(u) ' (' thresDesc ')'];
            u = spm_uc_FDR(u,df,STAT,n,VspmSv,0);
            
        case 'none'  % No adjustment: p for conjunctions is p of the conjunction SPM
            %--------------------------------------------------------------
            try
                u = xSPM.u;
            catch
                u = Input_u; %threshold  默认0.001========================================================================
            end
            if u <= 1
                thresDescDes = ['p<' num2str(u) ' (unc.)'];
                u = spm_u(u^(1/n),df,STAT);
            else
                thresDescDes = [STAT '=' num2str(u) ];
            end
            
            
        otherwise
            %--------------------------------------------------------------
            fprintf('\n');                                              %-#
            error('Unknown control method "%s".',thresDesc);
            
    end % switch thresDesc
    
    %-Compute p-values for topological and voxel-wise FDR (all search voxels)
    %----------------------------------------------------------------------
    if ~topoFDR
        fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...for voxelFDR')  %-#
        switch STAT
            case 'Z'
                Ps = (1-spm_Ncdf(Zum)).^n;
            case 'T'
                Ps = (1 - spm_Tcdf(Zum,df(2))).^n;
            case 'X'
                Ps = (1-spm_Xcdf(Zum,df(2))).^n;
            case 'F'
                Ps = (1 - spm_Fcdf(Zum,df)).^n;
        end
        Ps = sort(Ps);
    end
    
    %-Peak FDR
    %----------------------------------------------------------------------
    [up,Pp] = spm_uc_peakFDR(0.05,df,STAT,R,n,Zum,XYZum,u);
    
    %-Cluster FDR
    %----------------------------------------------------------------------
    if STAT == 'T' && n == 1
        V2R        = 1/prod(SPM.xVol.FWHM(SPM.xVol.DIM > 1));
        [uc,Pc,ue] = spm_uc_clusterFDR(0.05,df,STAT,R,n,Zum,XYZum,V2R,u);
    else
        uc  = NaN;
        ue  = NaN;
        Pc  = [];
    end
    
    %-Peak FWE
    %----------------------------------------------------------------------
    uu      = spm_uc(0.05,df,STAT,R,n,S);
    
    
%-Height threshold - Bayesian inference
%--------------------------------------------------------------------------
elseif STAT == 'P'
    
    u_default = 1 - 1/SPM.xVol.S;
    str       = 'Posterior probability threshold for PPM';
    u         = spm_input(str,'+0','r',u_default,1);
    thresDescDes = ['P>'  num2str(u) ' (PPM)'];
    
end % (if STAT)

%-Calculate height threshold filtering
%--------------------------------------------------------------------------
Q      = find(Z > u);

%-Apply height threshold
%--------------------------------------------------------------------------
Z      = Z(:,Q);
XYZ    = XYZ(:,Q);
if isempty(Q)
    fprintf('\n');                                                      %-#
    warning('SPM:NoVoxels','No voxels survive height threshold at u=%0.2g',u);
end


%-Extent threshold
%--------------------------------------------------------------------------
if ~isempty(XYZ)
    
    fprintf('%s%30s',repmat(sprintf('\b'),1,30),'...extent threshold'); %-#
    
    %-Get extent threshold [default = 0]
    %----------------------------------------------------------------------
    try
        k = xSPM.k;
    catch
        k = Input_k;
    end
    
    %-Calculate extent threshold filtering
    %----------------------------------------------------------------------
    A     = spm_clusters(XYZ);
    Q     = [];
    for i = 1:max(A)
        j = find(A == i);
        if length(j) >= k, Q = [Q j]; end
    end
    
    % ...eliminate voxels
    %----------------------------------------------------------------------
    Z     = Z(:,Q);
    XYZ   = XYZ(:,Q);
    if isempty(Q)
        fprintf('\n');                                                  %-#
        warning('SPM:NoVoxels','No voxels survive extent threshold at k=%0.2g',k);
    end
    
else
    
    k = 0;
    
end % (if ~isempty(XYZ))

%-For Bayesian inference provide (default) option to display contrast values
%--------------------------------------------------------------------------
if STAT == 'P'
    if spm_input('Plot effect-size/statistic',1,'b',{'Yes','No'},[1 0])
        Z = spm_get_data(xCon(Ic).Vcon,XYZ);
    end
end

%==========================================================================
% - E N D
%==========================================================================
fprintf('%s%30s\n',repmat(sprintf('\b'),1,30),'...done')                %-#
spm('Pointer','Arrow')

%-Assemble output structures of unfiltered data
%==========================================================================
xSPM   = struct( ...
            'swd',      swd,...
            'title',    titlestr,...
            'Z',        Z,...
            'n',        n,...
            'STAT',     STAT,...
            'df',       df,...
            'STATstr',  STATstr,...
            'Ic',       Ic,...
            'Im',       {Im},...
            'pm',       pm,...
            'Ex',       Ex,...
            'u',        u,...
            'k',        k,...
            'XYZ',      XYZ,...
            'XYZmm',    SPM.xVol.M(1:3,:)*[XYZ; ones(1,size(XYZ,2))],...
            'S',        SPM.xVol.S,...
            'R',        SPM.xVol.R,...
            'FWHM',     SPM.xVol.FWHM,...
            'M',        SPM.xVol.M,...
            'iM',       SPM.xVol.iM,...
            'DIM',      SPM.xVol.DIM,...
            'VOX',      VOX,...
            'Vspm',     VspmSv,...
            'thresDesc',thresDesc);

%-RESELS per voxel (density) if it exists
%--------------------------------------------------------------------------
try, xSPM.VRpv = SPM.xVol.VRpv; end
try
    xSPM.units = SPM.xVol.units;
catch
    try, xSPM.units = varargin{1}.units; end
end

%-p-values for topological and voxel-wise FDR
%--------------------------------------------------------------------------
try, xSPM.Ps    = Ps;             end  % voxel   FDR
try, xSPM.Pp    = Pp;             end  % peak    FDR
try, xSPM.Pc    = Pc;             end  % cluster FDR

%-0.05 critical thresholds for FWEp, FDRp, FWEc, FDRc
%--------------------------------------------------------------------------
try, xSPM.uc    = [uu up ue uc];  end
