subject_path = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\';
VOIs={'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\VOI_LMGN_1.mat';
    'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\VOI_LA1_1.mat';
    'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\CB\20161215002\VOI_LV1_1.mat'};

Input_b = [0,0,0;0,0,0;0,0,0]; % 定义调节参数
Input_c = [1,1,1,1;0,0,0,0;0,0,0,0]; % 定义输入参数

DCMs(1).a = [1,1,1;1,1,1;1,1,1];
DCMs(1).b = Input_b;
DCMs(1).c = Input_c;
DCMs(1).name = 'IN01';

DCMs(2).a = [1,0,1;0,1,1;1,1,1];
DCMs(2).b = Input_b;
DCMs(2).c = Input_c;
DCMs(2).name = 'IN02';

DCMs(3).a = [1,1,0;1,1,1;0,1,1];
DCMs(3).b = Input_b;
DCMs(3).c = Input_c;
DCMs(3).name = 'IN03';

DCMs(4).a = [1,1,1;1,1,0;1,0,1];
DCMs(4).b = Input_b;
DCMs(4).c = Input_c;
DCMs(4).name = 'IN04';

DCMs(5).a = [1,1,1;0,1,0;0,1,1];
DCMs(5).b = Input_b;
DCMs(5).c = Input_c;
DCMs(5).name = 'EX01';

DCMs(6).a = [1,0,1;0,1,0;0,1,1];
DCMs(6).b = Input_b;
DCMs(6).c = Input_c;
DCMs(6).name = 'EX02';

DCMs(7).a = [1,1,0;0,1,1;0,0,1];
DCMs(7).b = Input_b;
DCMs(7).c = Input_c;
DCMs(7).name = 'EX03';

DCMs(8).a = [1,1,1;0,1,0;0,0,1];
DCMs(8).b = Input_b;
DCMs(8).c = Input_c;
DCMs(8).name = 'EX04';
for i=1:size(DCMs,2)
    DCM = create_dcm(subject_path,VOIs,DCMs(i).a,DCMs(i).b,DCMs(i).c,DCMs(i).name);
end
