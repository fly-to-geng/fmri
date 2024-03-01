function DCM = create_dcm(subject_path)
%���ܣ� ����DCMģ�ͣ���Ҫ�������ȡVOI����FirstLevel�ļ�������VOI_��ͷ���ļ���
%subject_path : First_Level ����Ŀ¼�� eg.D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\20160716002\
%condition_name : SPM.mat ��ƾ����ж�����������������������ɵ�DCM������
%---------------------------------------------------------------
%-����----------------------------------------------------------
condition_name = {'JX','DW','RL','ZR'};
%Input_a : DCMģ�;�����Ҫ����ģ�͵�ʱ���޸��������
%Input_b : ��������
%Input_c : �������
%-���ý���------------------------------------------------------
cd(subject_path);
spmmatfile = [subject_path,'SPM.mat'];
for i = 1:size(condition_name,2)  %ÿ��ѭ������һ��condition�����µ�DCMģ��
    name = condition_name{i}; % ���ɵ�DCMģ�͵����ƣ�
    condition_mask = [0,0,0,0];
    condition_mask(i) = 1; % ʹ���ĸ�condition��Ϊ
    TE = 0.04; %  TE 
    Input_a = [1,1,1;1,1,1;1,1,1]; % ����DCMģ�͵����Ӿ���
    Input_b = [0,0,0;0,0,0;0,0,0]; % ������ڲ���
    Input_c = [1;0;0]; % �����������
    
    % ���VOI
    %------------------------------------------------
    filter = ['VOI_',condition_name{i},'_*'];
    VOIs_path = dir(filter);
    VOIs = cell(size(VOIs_path,1),1);
    for j = 1: size(VOIs_path,1)
        VOIs{j} = [subject_path,VOIs_path(j).name];
    end
    %-------------------------------------------------
    DCM = spm_dcm_specify_extend(spmmatfile,name,VOIs,condition_mask,TE,Input_a,Input_b,Input_c);
    clear name;
    clear VOIs;
    clear condition_mask;
end


