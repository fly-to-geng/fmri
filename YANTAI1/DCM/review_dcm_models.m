
first_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\';
cd(first_level_path);
dir_path = dir('2016*');
for i=1:size(dir_path,1)
    cd([first_level_path,dir_path(i).name]);
    dcm_models_path = dir('DCM*');
    for j=1:size(dcm_models_path,1)
        dcm_model_path = [first_level_path,dir_path(i).name,'\',dcm_models_path(j).name];
        spm_dcm_review_extend(dcm_model_path,'outputs');
        fg=spm_figure('FindWin','Graphics');
        [path,name,exit] = fileparts(dcm_model_path);
        save_name = ['output_',dir_path(i).name,'_',name];
        cd(first_level_path);
        print(fg,save_name,'-dpng');% 打印出PNG图片，还可以输出其他的格式，参考Matlab的print函数。
    end
end