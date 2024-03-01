function smooth(filter,pres,pre_processing_path)
% -------------------------------------------------------------------------
% 功能： 平滑图像
% 调用：smooth(filter,pres)
% 参数：
%   filter : 控制处理的被试数量，例如'20161001*';
%   pres : 生成的平滑之后的图像的前缀，例如's';
% 示例：
%   filter = '20161003*';
%   pres = 's';
%   smooth(filter,pres);
% 说明：平滑之后的图像与输入图像在同一文件夹，前缀不同
% -------------------------------------------------------------------------
clc;
warning('off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要修改的变量，修改此处可以处理多个被试的数据
%filter = '2016*';
% 输入： wraf*开头的图像文件
% 输出： 平滑之后的文件(与输入文件在同一文件夹中，前缀不一样)
%-------------------------------
% 配置参数：
% filter : 控制处理的被试数量
% pres : 输出图像的前缀
% pre_processing_path ： wraf*开头的图像文件的绝对路径
% run_num ： 每个RUN的文件数量(删除TR之后的数量)
% runExpID : RUN文件夹名称，这里是'ep2d*'
% filenames = dir('wraf*.img'); 输入图像以wraf开头
% matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4]; 控制平滑核大小
% matlabbatch{1}.spm.spatial.smooth.prefix = 's4';输出文件的前缀
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%预处理文件夹，整个预处理过程保存在这里
%pre_processing_path = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\pre_processing\HC\'};
%删除空TR后每个run文件的数量
run_num = 272;
%开始处理    
cd(pre_processing_path{1});
subExpID = dir(filter); %====================================
for i=1:size(subExpID,1)
    cd([pre_processing_path{1},subExpID(i).name]);
    
	diary smooth_output.txt; % 重定向控制台输出到文件
	tic;  %开始计时   
    %2.获得run的功能像文件
    cd([pre_processing_path{1},subExpID(i).name]);
    runExpID=dir('ep2d*');
    for j=1:size(runExpID,1)
        cd ([pre_processing_path{1},subExpID(i).name,'\',runExpID(j).name]);
        filenames = dir('wraf*.img');
        funcFilenames = cell(run_num,1);%每个run的文件集合
        for k=1:size(filenames,1)
            funcFilenames{k} = [pre_processing_path{1},subExpID(i).name,'\',runExpID(j).name,'\',filenames(k).name,',1'];
        end
         
        funcFilenames = {funcFilenames};
        
        %%================================batch-begin===================================================%%
        spm_jobman('initcfg')
        
        matlabbatch{1}.spm.spatial.smooth.data = funcFilenames{1};
        matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
        matlabbatch{1}.spm.spatial.smooth.dtype = 0;
        matlabbatch{1}.spm.spatial.smooth.im = 0;
        matlabbatch{1}.spm.spatial.smooth.prefix = pres;
        %%================================batch-end===================================================%%
        spm_jobman('run',matlabbatch);
        disp('smooth successful !');
        clear matlabbatch
    end
	toc
	diary off ;
end


