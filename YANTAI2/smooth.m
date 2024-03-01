function smooth(filter,pres,pre_processing_path)
% -------------------------------------------------------------------------
% ���ܣ� ƽ��ͼ��
% ���ã�smooth(filter,pres)
% ������
%   filter : ���ƴ���ı�������������'20161001*';
%   pres : ���ɵ�ƽ��֮���ͼ���ǰ׺������'s';
% ʾ����
%   filter = '20161003*';
%   pres = 's';
%   smooth(filter,pres);
% ˵����ƽ��֮���ͼ��������ͼ����ͬһ�ļ��У�ǰ׺��ͬ
% -------------------------------------------------------------------------
clc;
warning('off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��Ҫ�޸ĵı������޸Ĵ˴����Դ��������Ե�����
%filter = '2016*';
% ���룺 wraf*��ͷ��ͼ���ļ�
% ����� ƽ��֮����ļ�(�������ļ���ͬһ�ļ����У�ǰ׺��һ��)
%-------------------------------
% ���ò�����
% filter : ���ƴ���ı�������
% pres : ���ͼ���ǰ׺
% pre_processing_path �� wraf*��ͷ��ͼ���ļ��ľ���·��
% run_num �� ÿ��RUN���ļ�����(ɾ��TR֮�������)
% runExpID : RUN�ļ������ƣ�������'ep2d*'
% filenames = dir('wraf*.img'); ����ͼ����wraf��ͷ
% matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4]; ����ƽ���˴�С
% matlabbatch{1}.spm.spatial.smooth.prefix = 's4';����ļ���ǰ׺
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Ԥ�����ļ��У�����Ԥ������̱���������
%pre_processing_path = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\pre_processing\HC\'};
%ɾ����TR��ÿ��run�ļ�������
run_num = 272;
%��ʼ����    
cd(pre_processing_path{1});
subExpID = dir(filter); %====================================
for i=1:size(subExpID,1)
    cd([pre_processing_path{1},subExpID(i).name]);
    
	diary smooth_output.txt; % �ض������̨������ļ�
	tic;  %��ʼ��ʱ   
    %2.���run�Ĺ������ļ�
    cd([pre_processing_path{1},subExpID(i).name]);
    runExpID=dir('ep2d*');
    for j=1:size(runExpID,1)
        cd ([pre_processing_path{1},subExpID(i).name,'\',runExpID(j).name]);
        filenames = dir('wraf*.img');
        funcFilenames = cell(run_num,1);%ÿ��run���ļ�����
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


