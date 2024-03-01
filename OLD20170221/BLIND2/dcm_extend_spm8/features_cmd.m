file =  'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\';
X = extract_features_many_subjects(file);
save('X.mat',X);