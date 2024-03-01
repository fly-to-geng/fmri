function create_masks_use_whole()

first_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\';
output_mask_dir_name = 'masks_whole';
SubExp_filter = '2016*';
f = 'i1 > 3.0987';
cd(first_level_path);
SubRunID = dir(SubExp_filter);
if ~exist(output_mask_dir_name,'dir')
    mkdir(output_mask_dir_name);
end
for i = 1:size(SubRunID,1)
    cd([first_level_path,SubRunID(i).name]);
    JX_path = dir('spmT_0017.img*');
    DW_path = dir('spmT_0018.img*');
    RL_path = dir('spmT_0019.img*');
    ZR_path = dir('spmT_0020.img*');
    cd([first_level_path,output_mask_dir_name]);
    if ~exist(SubRunID(i).name,'dir')
        mkdir(SubRunID(i).name);
    end
    create_mask_use_T({[first_level_path,SubRunID(i).name,'\',JX_path(1).name]},[first_level_path,output_mask_dir_name,'\',SubRunID(i).name,'\JX_STG.img'],f);
    create_mask_use_T({[first_level_path,SubRunID(i).name,'\',DW_path(1).name]},[first_level_path,output_mask_dir_name,'\',SubRunID(i).name,'\DW_STG.img'],f);
    create_mask_use_T({[first_level_path,SubRunID(i).name,'\',RL_path(1).name]},[first_level_path,output_mask_dir_name,'\',SubRunID(i).name,'\RL_STG.img'],f);
    create_mask_use_T({[first_level_path,SubRunID(i).name,'\',ZR_path(1).name]},[first_level_path,output_mask_dir_name,'\',SubRunID(i).name,'\ZR_STG.img'],f);
end