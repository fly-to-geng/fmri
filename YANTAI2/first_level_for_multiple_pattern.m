
filter_HC = '20*';
fist_level_path_HC = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_6s\HC\'};
pre_processing_path_HC = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\pre_processing\HC\'};
first_level(filter_HC,fist_level_path_HC,pre_processing_path_HC);

fist_level_path_BS = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_6s\BS\'};
pre_processing_path_BS = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\pre_processing\BS\'};
first_level(filter_HC,fist_level_path_BS,pre_processing_path_BS)

fist_level_path_CB = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_6s\CB\'};
pre_processing_path_CB = {'D:\FMRI_ROOT\YANTAI2\ANALYSIS\pre_processing\CB\'};
first_level(filter_HC,fist_level_path_CB,pre_processing_path_CB);