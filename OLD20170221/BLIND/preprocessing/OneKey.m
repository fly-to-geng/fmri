%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
%% 第一部分：格式转换
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%控制处理多个被试数据，下面还有一处需要同步修改
filter = '20161017001*'; %%===========================================================================================================================

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%原始文件总数
t2_file_num = 1108;  %一个被试的总文件
%原始文件存放根目录
raw_data_root = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\raw_data\';
%转完格式之后数据存放的路径
img_hdr_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\img_hdr\'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%格式转换部分，转换完成的文件放在另外的单独文件夹，运行结果保存在raw_data_root
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(raw_data_root);
subExpID=dir(filter);%===========================

t2_raw_filenames = cell(t2_file_num,1); %保证大于所有t2文件的总数
index = 0;
for i=1:size(subExpID,1)
     cd ([raw_data_root,subExpID(i).name]);%切换到被试文件夹
     runExpID = dir('0*_ep2d*'); %run 文件夹
     for j=1:size(runExpID,1)
        cd ([raw_data_root,subExpID(i).name,'\',runExpID(j).name]);%切换到run文件夹
        filenames = dir('00*');
        for k=1:size(filenames,1)
            index = index + 1;
            t2_raw_filenames{index} = [raw_data_root,subExpID(i).name,'\',runExpID(j).name,'\',filenames(k).name];
        end
     end
end

spm_jobman('initcfg')
%%================================batch-begin===================================================%%
matlabbatch{1}.spm.util.dicom.data = t2_raw_filenames;
matlabbatch{1}.spm.util.dicom.root = 'patid';
matlabbatch{1}.spm.util.dicom.outdir = img_hdr_path;
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;
%%================================batch-end===================================================%%
DicomT2Result = spm_jobman('run',matlabbatch);
cd(img_hdr_path{1});
save DicomT2Result;
disp('t2 dicom to img_hdr sucessful!')
clear matlabbatch



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%修改这两个变量，就可以处理多个被试的数据。
filter = '20161115002*';  %%========================================================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%原始文件总数
t1_file_num = 176;
%原始文件存放根目录
raw_data_root = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\raw_data\';
%转完格式之后数据存放的路径
img_hdr_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\img_hdr\'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(raw_data_root);
subExpID=dir(filter);%===========================

t1_raw_filenames = cell(t1_file_num,1); %保证大于所有t2文件的总数
index = 0;
for i=1:size(subExpID,1)
     cd ([raw_data_root,subExpID(i).name]);%切换到被试文件夹
     runExpID = dir('0*_t1*'); %run 文件夹
     for j=1:size(runExpID,1)
        cd ([raw_data_root,subExpID(i).name,'\',runExpID(j).name]);%切换到run文件夹
        filenames = dir('00*');
        for k=1:size(filenames,1)
            index = index + 1;
            t1_raw_filenames{index} = [raw_data_root,subExpID(i).name,'\',runExpID(j).name,'\',filenames(k).name];
        end
     end
end

spm_jobman('initcfg');
%%================================batch-begin===================================================%%
matlabbatch{1}.spm.util.dicom.data = t1_raw_filenames;
matlabbatch{1}.spm.util.dicom.root = 'patid';
matlabbatch{1}.spm.util.dicom.outdir = img_hdr_path;
matlabbatch{1}.spm.util.dicom.convopts.format = 'img';
matlabbatch{1}.spm.util.dicom.convopts.icedims = 0;
%%================================batch-end===================================================%%
cd(img_hdr_path{1});
DicomT1Result = spm_jobman('run',matlabbatch);
save DicomT1Result;
disp('t1 dicom to img_hdr sucessful!');
clear matlabbatch;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%第二部分： 预处理

clc;
clear;
warning('off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要修改的变量，修改此处可以处理多个被试的数据
filter = '20161115002*';  %%=========================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%转换完格式的文件存放的文件夹
img_hdr_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\img_hdr\'};
%预处理文件夹，整个预处理过程保存在这里
pre_processing_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\'};
%要删除掉的TR
delete_filenameID = {'*-00001-00001-*','*-00002-00002-*','*-00003-00003-*','*-00004-00004-*','*-00005-00005-*'};
%删除空TR后每个run文件的数量
run_num = 272;
%内部路径，根据SPM8安装路径修改
%%%=========================================================================================================================================
innerMatlab_path = {
                   'C:\mazcx\matlabtoolbox\spm8\tpm\csf.nii,1'
                   'C:\mazcx\matlabtoolbox\spm8\tpm\grey.nii,1'
                   'C:\mazcx\matlabtoolbox\spm8\tpm\white.nii,1'
                    };
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%预处理部分，主要内容：
%1. 将格式转换后的文件复制一份到预处理文件夹
%2. 删除掉多余的TR，只剩下需要的TR
%3. 在结构像文件中新建4个run，把结构像复制到每个run下,配准的时候每个run都是用自己对应run的结构像
%4. 以每个run为单位，运行预处理的batch文件
%5. 控制处理的文件夹主要需要修改的变量：
%  把代码中带=============注释的改成被试文件夹名称
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%将数据拷贝到预处理文件夹
cd(img_hdr_path{1});
copyfile(filter,pre_processing_path{1}); %====================

%删除多余的TR
cd(pre_processing_path{1});
subExpID=dir (filter);     %被试文件夹==================

for i=1:size(subExpID,1)
     cd ([pre_processing_path{1},subExpID(i).name]);
     runExpID = dir('ep2d*'); %run 文件夹++++++++++++++++++++++++
     for j=1:size(runExpID,1)
         cd ([pre_processing_path{1},subExpID(i).name,'\',runExpID(j).name]);
         for k = 1:size(delete_filenameID,2)
             delete(cell2mat(delete_filenameID(k)));
         end
     end
end

%复制4个run的结构像
cd(pre_processing_path{1});
subExpID = dir(filter);   %=========================
for i=1:size(subExpID,1)
    cd([pre_processing_path{1},subExpID(i).name]);
    t1ExpID = dir('t1*');
    cd(t1ExpID.name);
    mkdir('run1');
    copyfile('s*',[pre_processing_path{1},subExpID(i).name,'\',t1ExpID.name,'\run1\']);
    mkdir('run2');
    copyfile('s*',[pre_processing_path{1},subExpID(i).name,'\',t1ExpID.name,'\run2\']);
    mkdir('run3');
    copyfile('s*',[pre_processing_path{1},subExpID(i).name,'\',t1ExpID.name,'\run3\']);
    mkdir('run4');
    copyfile('s*',[pre_processing_path{1},subExpID(i).name,'\',t1ExpID.name,'\run4\']);
end

%开始预处理    
cd(pre_processing_path{1});
subExpID = dir(filter); %====================================
for i=1:size(subExpID,1)
    cd([pre_processing_path{1},subExpID(i).name]);
    
	diary pre_processing_output.txt; % 重定向控制台输出到文件
	tic;  %开始计时   
    %1. 获得4个结构像文件
    t1ExpID = dir('t1*');
    cd([pre_processing_path{1},subExpID(i).name,'\',t1ExpID(1).name]);%切换到t1像
    runID = dir('run*');
    data3D_filenames=cell(4,1);%4个run的结构像文件
    for j=1:size(runID,1)
        cd([pre_processing_path{1},subExpID(i).name,'\',t1ExpID(1).name,'\',runID(j).name])
        filenames = dir('s*.img');
        data3D_filenames{j} = [pre_processing_path{1},subExpID(i).name,'\',t1ExpID(1).name,'\',runID(j).name,'\',filenames(1).name,',1'];
    end
    
    %2.获得run的功能像文件
    cd([pre_processing_path{1},subExpID(i).name]);
    runExpID=dir('ep2d*');
    for j=1:size(runExpID,1)
        cd ([pre_processing_path{1},subExpID(i).name,'\',runExpID(j).name]);
        filenames = dir('f*.img');
        funcFilenames = cell(run_num,1);%每个run的文件集合
        for k=1:size(filenames,1)
            funcFilenames{k} = [pre_processing_path{1},subExpID(i).name,'\',runExpID(j).name,'\',filenames(k).name,',1'];
        end
         
        funcFilenames = {funcFilenames};
        data3D_filename = { data3D_filenames{j} };
        
        %%================================batch-begin===================================================%%
        spm_jobman('initcfg')
        matlabbatch{1}.spm.temporal.st.scans = funcFilenames;
        matlabbatch{1}.spm.temporal.st.nslices = 33;
        matlabbatch{1}.spm.temporal.st.tr = 2;
        matlabbatch{1}.spm.temporal.st.ta = 1.93939393939394;
        matlabbatch{1}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32];
        matlabbatch{1}.spm.temporal.st.refslice = 33;
        matlabbatch{1}.spm.temporal.st.prefix = 'a';
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1) = cfg_dep;
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tname = 'Session';
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(1).name = 'filter';
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(1).value = 'image';
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(2).name = 'strtype';
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).tgt_spec{1}(2).value = 'e';
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).sname = 'Slice Timing: Slice Timing Corr. Images (Sess 1)';
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch{2}.spm.spatial.realign.estwrite.data{1}(1).src_output = substruct('()',{1}, '.','files');
        matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.interp = 2;
        matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{2}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{2}.spm.spatial.realign.estwrite.roptions.which = [2 1];
        matlabbatch{2}.spm.spatial.realign.estwrite.roptions.interp = 4;
        matlabbatch{2}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{2}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{2}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1) = cfg_dep;
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tname = 'Reference Image';
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(1).name = 'filter';
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(1).value = 'image';
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(2).name = 'strtype';
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).tgt_spec{1}(2).value = 'e';
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).sname = 'Realign: Estimate & Reslice: Mean Image';
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch{3}.spm.spatial.coreg.estimate.ref(1).src_output = substruct('.','rmean');
        matlabbatch{3}.spm.spatial.coreg.estimate.source = data3D_filename; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        matlabbatch{3}.spm.spatial.coreg.estimate.other = {''};
        matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{3}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        matlabbatch{4}.spm.spatial.preproc.data = data3D_filename ; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        matlabbatch{4}.spm.spatial.preproc.output.GM = [0 0 1];
        matlabbatch{4}.spm.spatial.preproc.output.WM = [0 0 1];
        matlabbatch{4}.spm.spatial.preproc.output.CSF = [0 0 1];
        matlabbatch{4}.spm.spatial.preproc.output.biascor = 1;
        matlabbatch{4}.spm.spatial.preproc.output.cleanup = 1;
        matlabbatch{4}.spm.spatial.preproc.opts.tpm = innerMatlab_path; %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        matlabbatch{4}.spm.spatial.preproc.opts.ngaus = [2
                                                         2
                                                         2
                                                         4];
        matlabbatch{4}.spm.spatial.preproc.opts.regtype = 'mni';
        matlabbatch{4}.spm.spatial.preproc.opts.warpreg = 1;
        matlabbatch{4}.spm.spatial.preproc.opts.warpco = 25;
        matlabbatch{4}.spm.spatial.preproc.opts.biasreg = 0.0001;
        matlabbatch{4}.spm.spatial.preproc.opts.biasfwhm = 60;
        matlabbatch{4}.spm.spatial.preproc.opts.samp = 3;
        matlabbatch{4}.spm.spatial.preproc.opts.msk = {''};
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1) = cfg_dep;
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tname = 'Parameter File';
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).name = 'filter';
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(1).value = 'mat';
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).name = 'strtype';
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).tgt_spec{1}(2).value = 'e';
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).sname = 'Segment: Norm Params Subj->MNI';
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).src_exbranch = substruct('.','val', '{}',{4}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch{5}.spm.spatial.normalise.write.subj.matname(1).src_output = substruct('()',{1}, '.','snfile', '()',{':'});
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1) = cfg_dep;
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tname = 'Images to Write';
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(1).name = 'filter';
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(1).value = 'image';
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(2).name = 'strtype';
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).tgt_spec{1}(2).value = 'e';
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).sname = 'Realign: Estimate & Reslice: Resliced Images (Sess 1)';
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch{5}.spm.spatial.normalise.write.subj.resample(1).src_output = substruct('.','sess', '()',{1}, '.','rfiles');
        matlabbatch{5}.spm.spatial.normalise.write.roptions.preserve = 0;
        matlabbatch{5}.spm.spatial.normalise.write.roptions.bb = [-90 -126 -72
                                                                  90 90 108];
        matlabbatch{5}.spm.spatial.normalise.write.roptions.vox = [3 3 3];
        matlabbatch{5}.spm.spatial.normalise.write.roptions.interp = 1;
        matlabbatch{5}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
        matlabbatch{5}.spm.spatial.normalise.write.roptions.prefix = 'w';
        matlabbatch{6}.spm.spatial.smooth.data(1) = cfg_dep;
        matlabbatch{6}.spm.spatial.smooth.data(1).tname = 'Images to Smooth';
        matlabbatch{6}.spm.spatial.smooth.data(1).tgt_spec{1}(1).name = 'filter';
        matlabbatch{6}.spm.spatial.smooth.data(1).tgt_spec{1}(1).value = 'image';
        matlabbatch{6}.spm.spatial.smooth.data(1).tgt_spec{1}(2).name = 'strtype';
        matlabbatch{6}.spm.spatial.smooth.data(1).tgt_spec{1}(2).value = 'e';
        matlabbatch{6}.spm.spatial.smooth.data(1).sname = 'Normalise: Write: Normalised Images (Subj 1)';
        matlabbatch{6}.spm.spatial.smooth.data(1).src_exbranch = substruct('.','val', '{}',{5}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
        matlabbatch{6}.spm.spatial.smooth.data(1).src_output = substruct('()',{1}, '.','files');
        matlabbatch{6}.spm.spatial.smooth.fwhm = [8 8 8];
        matlabbatch{6}.spm.spatial.smooth.dtype = 0;
        matlabbatch{6}.spm.spatial.smooth.im = 0;
        matlabbatch{6}.spm.spatial.smooth.prefix = 's';
        %%================================batch-end===================================================%%
        spm_jobman('run',matlabbatch);
        disp('pre_processing successful !');
        clear matlabbatch
    end
	toc
	diary off ;
end

%画头动图像并保存
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要修改的变量
%filter = '20161006002*';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pre_processing_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\';
cd(pre_processing_path);
SubExpID = dir(filter);
for i=1:size(SubExpID,1)
    cd([pre_processing_path,SubExpID(i).name]);
    SubRunID = dir('ep2d*');
    for j=1:size(SubRunID,1)
        cd([pre_processing_path,SubExpID(i).name,'\',SubRunID(j).name]);
        head_move_file = dir('rp_*');
        cd([pre_processing_path,SubExpID(i).name]);
        plothm([pre_processing_path,SubExpID(i).name,'\',SubRunID(j).name,'\',head_move_file.name],['Realign_Run',num2str(j)]);
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 第三部分： 单被试统计分析
clear;
clc;
warning('off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%需要设置的变量
filter = '20161104002*';%%=====================================================================================================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fist_level_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\'};
pre_processing_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\'};
conditions_file_path = {'d:\fmri_root\yantai\DESIGN\conditions.mat'};
run_num = 272;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%FisrtLevel分析
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd(pre_processing_path{1});
subExpID=dir(filter);%=======================================

for  i=1:size(subExpID,1)
   
    wFuncImg_filenames = cell(run_num*4,1);
    multi_reg_file = cell(4,1);
    
    fist_level_path_subject = [fist_level_path{1},subExpID(i).name];
    mkdir(fist_level_path_subject); % 创建存放结果的文件夹
    cd(fist_level_path_subject);
    diary first_level_output.txt; % 重定向控制台输出到文件
	tic;  %开始计时   
    
    cd([pre_processing_path{1},subExpID(i).name]);
    subRunID = dir('ep2d*');
    for j=1:size(subRunID,1)
        cd([pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name]);
        filenames = dir('w*.img');
        multi_regs = dir('rp_*');
        multi_reg_file{j} = [pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name,'\',multi_regs.name];
        start = run_num*(j-1);
        for k=1:size(filenames,1)
            wFuncImg_filenames{start + k} = [pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name,'\',filenames(k).name,',1'];
        end
    end
     
    spm_jobman('initcfg')
    %================================batch-begin===================================================%%
    matlabbatch{1}.spm.stats.fmri_spec.dir =  {fist_level_path_subject};%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = wFuncImg_filenames(1:run_num);
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = conditions_file_path; %%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = multi_reg_file(1) ;
    matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).scans = wFuncImg_filenames(run_num+1:run_num*2);
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi =  conditions_file_path;  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).multi_reg = multi_reg_file(2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(2).hpf = 128;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).scans = wFuncImg_filenames(run_num*2+1:run_num*3);
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi =  conditions_file_path;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).multi_reg = multi_reg_file(3);
    matlabbatch{1}.spm.stats.fmri_spec.sess(3).hpf = 128;
    %
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).scans = wFuncImg_filenames(run_num*3+1:run_num*4);
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi = conditions_file_path;
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).multi_reg = multi_reg_file(4);
    matlabbatch{1}.spm.stats.fmri_spec.sess(4).hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
    matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
    matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 's01';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 's02';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 's03';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 's04';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.convec = [0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 's05';
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.convec = [0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.name = 's06';
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.convec = [0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{6}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.name = 's07';
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.convec = [0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{7}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.name = 's08';
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.convec = [0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{8}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.name = 's09';
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.convec = [0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{9}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.name = 's10';
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.convec = [0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{10}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.name = 's11';
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{11}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.name = 's12';
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{12}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.name = 's13';
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{13}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.name = 's14';
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{14}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.name = 's15';
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{15}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.name = 's16';
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.convec = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{16}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.name = 'JX';
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.convec = [1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{17}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{18}.tcon.name = 'DW';
    matlabbatch{3}.spm.stats.con.consess{18}.tcon.convec = [0 0 1 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{18}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{19}.tcon.name = 'RL';
    matlabbatch{3}.spm.stats.con.consess{19}.tcon.convec = [0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 1 0 0 1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{19}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{20}.tcon.name = 'ZR';
    matlabbatch{3}.spm.stats.con.consess{20}.tcon.convec = [0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 1 0 0 1 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{20}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{21}.tcon.name = 'LRL';
    matlabbatch{3}.spm.stats.con.consess{21}.tcon.convec = [1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 0 0 0 0 0 0 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 0 0 0 0 0 0 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 0 0 0 0 0 0 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{21}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{22}.tcon.name = 'LRR';
    matlabbatch{3}.spm.stats.con.consess{22}.tcon.convec = [-1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 0 0 0 0 0 0 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 0 0 0 0 0 0 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 0 0 0 0 0 0 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 -1 -1 1 1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{22}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.consess{23}.tcon.name = 'YWZ';
    matlabbatch{3}.spm.stats.con.consess{23}.tcon.convec = [1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 0 0 0 0 0 0 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 0 0 0 0 0 0 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 0 0 0 0 0 0 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 1 -1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{23}.tcon.sessrep = 'none';
    matlabbatch{3}.spm.stats.con.delete = 1;

    %%================================batch-end=========================================================================%%
    first_level_result = spm_jobman('run',matlabbatch);
    cd(fist_level_path_subject);
    save first_level_result;
    disp('first_level successful !');
    clear matlabbatch;
    toc
    diary off;
end

%%
system('shutdown -s -t 10')





