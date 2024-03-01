# -*- coding: utf-8 -*-
"""
Created on Sun Jan 08 14:52:42 2017

@author: FF120
专门用来将mat文件转换成npy文件

或者反方向转换
"""
import scipy.io as sio
import numpy as np
#features = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_brainnetome_second_level.mat';
#features = r'D:\FMRI_ROOT\YIYU\MVPA\features_vs_labels_from_DCM_DMN_DAN_SN.mat'
features = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_DMN_DAN_SN_second_level.mat'
#names = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_briannetome_second_level_vs_names.mat'
#names = r'D:\FMRI_ROOT\YIYU\MVPA\features_vs_labels_from_DCM_DMN_DAN_SN_vs_names.mat'
names = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_DMN_DAN_SN_second_level_vs_names.mat'
features = sio.loadmat(features)
features = features['subjects_features_mat']
names=sio.loadmat(names)
names = names['brain_map_names']
names = names[0]
np.save(r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_DMN_DAN_SN_second_level.npy',features)
np.save(r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_DMN_DAN_SN_second_level_vs_names.npy',names)

# 创建 y_labels
y = []
for i in range(26):
    y.append(1)
for i in range(21):
    y.append(2)
    
np.save(r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_brainnetome_second_level_vs_labels.npy',y)
