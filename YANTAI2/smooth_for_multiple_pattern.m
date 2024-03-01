clear;
clc;
pre = 's6';
filter_HC = '2016*';
pre_path_HC = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\pre_processing\HC\'};
smooth(filter_HC,pre,pre_path_HC);

filter_BS = '20*';
pre_path_BS = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\pre_processing\BS\'};
smooth(filter_BS,pre,pre_path_BS);


filter_CB = '2017*';
pre_path_CB = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\pre_processing\CB\'};
smooth(filter_CB,pre,pre_path_CB);
