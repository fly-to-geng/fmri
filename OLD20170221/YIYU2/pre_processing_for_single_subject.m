function pre_processing_yy(filter)
% -------------------------------------------------------------------------
% ���ܣ� ����֢����Ԥ���������� 
% 1.slice timing; 2. realign�� 3.��׼��4.�ָ5.��׼����6.ƽ��
%--------------------------------------------------------------------------
clc;
warning('off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��Ҫ�޸ĵı������޸Ĵ˴����Դ���������Ե�����
%filter = '20161024002*';
% ���룺 ������ʽת��֮���img,hdrͼ��
% ����� Ԥ����֮���ͼ���Ԥ�����Ľ���ļ�

% ���ò�����
% filter : ���ƴ����ı�������
% img_hdr_path ��img,hdr�ļ���ŵľ���·��
% pre_processing_path �� wraf*��ͷ��ͼ���ļ��ľ���·��
% delete_filenameID ��Ԥ������ʼ֮ǰ��Ҫɾ����TR��
% run_num �� ÿ��RUN���ļ�����(ɾ��TR֮�������)
% innerMatlab_path �� SPM8�������л��ʣ����ʣ��Լ�Һ�ļ���·��������ڷָ��ʱ����õ����ڲ�ͬ���Լ���ֲ��ʱ����Ҫ�޸ġ�
% runExpID : RUN�ļ������ƣ�������'ep2d*'
% filenames = dir('wraf*.img'); ����ͼ����wraf��ͷ
% matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4]; ����ƽ���˴�С
% matlabbatch{1}.spm.spatial.smooth.prefix = 's4';����ļ���ǰ׺
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ת�����ʽ���ļ���ŵ��ļ���
funImg = {'D:\FMRI_ROOT\YIYU\FunImg\'};
T1Img = {'D:\FMRI_ROOT\YIYU\T1Img\'};
%filter = 'sub101*';
%Ԥ�����ļ��У�����Ԥ�������̱���������
pre_processing_path = {'D:\FMRI_ROOT\YIYU\pre_processing\'};
%Ҫɾ������TR
delete_filenameID = {'*-00001-00001-*','*-00002-00002-*','*-00003-00003-*','*-00004-00004-*','*-00005-00005-*','*-00006-00006-*','*-00007-00007-*','*-00008-00008-*','*-00009-00009-*','*-00010-00010-*'};
%ɾ����TR��ÿ��run�ļ�������
run_num = 230;
%�ڲ�·��������SPM8��װ·���޸�
innerMatlab_path = {
                   'C:\mazcx\matlabtoolbox\spm8\tpm\csf.nii,1'
                   'C:\mazcx\matlabtoolbox\spm8\tpm\grey.nii,1'
                   'C:\mazcx\matlabtoolbox\spm8\tpm\white.nii,1'
                    };
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ԥ�������֣���Ҫ���ݣ�
%1. ����ʽת������ļ�����һ�ݵ�Ԥ�����ļ���
%2. ɾ���������TR��ֻʣ����Ҫ��TR
%3. �ڽṹ���ļ����½�4��run���ѽṹ���Ƶ�ÿ��run��,��׼��ʱ��ÿ��run�������Լ���Ӧrun�Ľṹ��
%4. ��ÿ��runΪ��λ������Ԥ������batch�ļ�
%5. ���ƴ������ļ�����Ҫ��Ҫ�޸ĵı�����
%  �Ѵ����д�=============ע�͵ĸĳɱ����ļ�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%�����ݿ�����Ԥ�����ļ���
cd(funImg{1});
copyfile(filter,pre_processing_path{1}); %====================

%ɾ�������TR
cd(pre_processing_path{1});
subExpID=dir (filter);     %�����ļ���==================

for i=1:size(subExpID,1)
     cd ([pre_processing_path{1},subExpID(i).name]);
     for k = 1:size(delete_filenameID,2)
         delete(cell2mat(delete_filenameID(k)));
     end
     if exist('DicomT2Result.mat','file')
        delete('DicomT2Result.mat'); 
     end
end


%��ʼԤ����    
cd(pre_processing_path{1});
subExpID = dir(filter); %====================================
for i=1:size(subExpID,1)
    cd([pre_processing_path{1},subExpID(i).name]);
    
	diary pre_processing_output.txt; % �ض������̨������ļ�
	tic;  %��ʼ��ʱ   
    %1. ��ýṹ���ļ�
    
    cd([T1Img{1},subExpID(i).name]);
    data3D_filenames=cell(1,1);%�ṹ���ļ�
    filenames = dir('s*.img');
    data3D_filenames{1} = [T1Img{1},subExpID(i).name,'\',filenames(1).name,',1'];
    
    %2.���run�Ĺ������ļ�
    cd([pre_processing_path{1},subExpID(i).name]);
    filenames = dir('f*.img');
    funcFilenames = cell(run_num,1);%ÿ��run���ļ�����
    for k=1:size(filenames,1)
        funcFilenames{k} = [pre_processing_path{1},subExpID(i).name,'\',filenames(k).name,',1'];
    end

    funcFilenames = {funcFilenames};
    data3D_filename = data3D_filenames;
        
    %%================================batch-begin===================================================%%
    spm_jobman('initcfg')
    matlabbatch{1}.spm.temporal.st.scans = funcFilenames;
    matlabbatch{1}.spm.temporal.st.nslices = 36;
    matlabbatch{1}.spm.temporal.st.tr = 2;
    matlabbatch{1}.spm.temporal.st.ta = 1.94444444444444;
    matlabbatch{1}.spm.temporal.st.so = [1 3 5 7 9 11 13 15 17 19 21 23 25 27 29 31 33 35 2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36];
    matlabbatch{1}.spm.temporal.st.refslice = 35;
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
    matlabbatch{6}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{6}.spm.spatial.smooth.dtype = 0;
    matlabbatch{6}.spm.spatial.smooth.im = 0;
    matlabbatch{6}.spm.spatial.smooth.prefix = 's';
    %%================================batch-end===================================================%%
    pre_pros = spm_jobman('run',matlabbatch);
    cd([pre_processing_path{1},subExpID(i).name]);
    save pre_pros;
    disp('pre_processing successful !');
    clear matlabbatch
	toc
	diary off ;
end

