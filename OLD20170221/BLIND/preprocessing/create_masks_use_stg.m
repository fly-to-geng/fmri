function create_masks_use_stg()

first_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\';
mask_path = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\NiftiPairs_Resliced_STG.mn.img';
output_mask_dir_name = 'masks_stg';
SubExp_filter = '2016*';
f = 'i1.*(i2>3.0987)';
%---------------------------------------
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
    create_mask_use_T({mask_path;[first_level_path,SubRunID(i).name,'\',JX_path(1).name]},[first_level_path,output_mask_dir_name,'\',SubRunID(i).name,'\JX_STG.img'],f);
    create_mask_use_T({mask_path;[first_level_path,SubRunID(i).name,'\',DW_path(1).name]},[first_level_path,output_mask_dir_name,'\',SubRunID(i).name,'\DW_STG.img'],f);
    create_mask_use_T({mask_path;[first_level_path,SubRunID(i).name,'\',RL_path(1).name]},[first_level_path,output_mask_dir_name,'\',SubRunID(i).name,'\RL_STG.img'],f);
    create_mask_use_T({mask_path;[first_level_path,SubRunID(i).name,'\',ZR_path(1).name]},[first_level_path,output_mask_dir_name,'\',SubRunID(i).name,'\ZR_STG.img'],f);
end
% % 制作的mask乘以激活找到最大值坐标，以改坐标为圆心做mask
% STG_mask_path = 'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\NiftiPairs_Resliced_STG.mn.img';
% spmT_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\20160911002\spmT_0017.img';
% input_img = {STG_mask_path; spmT_path}; % 一个mask , 一个spmT图像
% output_img = 'd:\aaa.img';
% %------------
% P = input_img;
% Q = output_img;
% f = 'i1.*i2';
% dmtx = 0;
% mask = 0;
% type = 4;
% hold = 0;
% flags = {dmtx,mask,type,hold};
% [Q,Vo] = spm_imcalc_extend(P,Q,f,flags);
% my_xjview(Q);
% h = spm_mip_ui('FindMIPax');
% loc = 'glmax';
% xyz = spm_mip_ui('Jump',h,loc)