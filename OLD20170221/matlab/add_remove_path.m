% 添加或者删除Matlab的工具包
function add_remove_path(command,tool_name)
matlab_toolbox_root = 'C:\mazcx\matlabtoolbox';
if ~nargin, tool_name = 'spm12'; end
switch lower(tool_name)
    case 'spm12'
        if  strcmpi(command,'start') 
        addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
        savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            savepath;
        end
    case 'xjview900'
         if  strcmpi(command,'start') 
            addpath (genpath(fullfile(matlab_toolbox_root,'xjview900')));
            savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'xjview900')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'xjview900')));
            savepath;
        end
    case 'rest'
         if  strcmpi(command,'start') 
            addpath (genpath(fullfile(matlab_toolbox_root,'REST_V1.8_130615')));
            savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'REST_V1.8_130615')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'REST_V1.8_130615')));
            savepath;
        end
    case 'mvpa'
         if  strcmpi(command,'start') 
        addpath (genpath(fullfile(matlab_toolbox_root,'mvpa','trunk')));
        savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'mvpa','trunk')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'mvpa','trunk')));
            savepath;
        end
     case 'conn'
         if  strcmpi(command,'start') 
        addpath (genpath(fullfile(matlab_toolbox_root,'conn16b')));
        savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'conn16b')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'conn16b')));
            savepath;
        end
       case 'brainnetome'
         if  strcmpi(command,'start') 
        addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
        savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            savepath;
        end
         case 'brainnetome'
         if  strcmpi(command,'start') 
        addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
        savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            savepath;
        end
         case 'brainnetome'
         if  strcmpi(command,'start') 
        addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
        savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            savepath;
        end
         case 'dpabi'
         if  strcmpi(command,'start') 
        addpath (genpath(fullfile(matlab_toolbox_root,'DPABI_V2.2_161201')));
        savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'DPABI_V2.2_161201')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'DPABI_V2.2_161201')));
            savepath;
        end
    otherwise
         if  strcmpi(command,'start') 
        addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
        savepath;
        end
        if strcmpi(command,'stop') 
            addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            rmpath(genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
            savepath;
        end
end












