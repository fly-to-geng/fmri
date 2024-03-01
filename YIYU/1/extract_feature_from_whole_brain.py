# -*- coding: utf-8 -*-
"""
Created on Sat Jul 23 20:25:14 2016

@author: FF120

读取图像的数据，添加标签，保存成矩阵
"""
import numpy as np
import os

pre_processing_path = r'D:\FMRI_ROOT\YIYU\pre_processing'
mvpa_path = r'D:\FMRI_ROOT\YIYU\MVPA'
first_level_path = r'D:\FMRI_ROOT\YIYU\first_level'
NC_subjects = ['sub1001','sub1002','sub1003',
    'sub1004','sub1005','sub1006','sub1007',
    'sub1008','sub1009','sub1011',
    'sub1012','sub1012','sub1014','sub1015',
    'sub1016','sub1017','sub1018','sub1019',
    'sub1020','sub1021','sub1022','sub1023',
    'sub1024','sub1025','sub1026',
    'sub1028'];
MDD_subjects = ['sub1030','sub1031','sub1032',
    'sub1033','sub1034','sub1036',
    'sub1037','sub1038','sub1039','sub1040',
    'sub1041','sub1043','sub1044',
    'sub1045','sub1046','sub1047','sub1048',
    'sub1049','sub1050','sub1051','sub1052',
    'sub1053'];

# 加载单个文件；fmri图像数据
from nilearn import image
NC_features = []
for i in xrange(len(NC_subjects)):
    func_img_path = pre_processing_path + '\\' + NC_subjects[i] + '\wraf*.img';
    func_img = image.load_img(func_img_path);
    img_data = func_img.get_data()
    cow = np.mean(img_data, axis=3)
    feature = cow.reshape(-1,)
    NC_features.append(feature)
NC_array = np.array(NC_features)
NC_labels = np.ones((NC_array.shape[0],1))
NCs = np.concatenate((NC_labels,NC_array),axis=1)

MDD_features = []           
for i in xrange(len(MDD_subjects)):
    func_img_path = pre_processing_path + '\\' + MDD_subjects[i] + '\wraf*.img';
    func_img = image.load_img(func_img_path);
    img_data = func_img.get_data()
    cow = np.mean(img_data, axis=3)
    feature = cow.reshape(-1,)
    MDD_features.append(feature)

MDD_array = np.array(MDD_features)
MDD_labels = np.ones((MDD_array.shape[0],1))
MDD_labels[:,0] = 2
MDDs = np.concatenate((MDD_labels,MDD_array),axis=1)

data = np.concatenate((NCs,MDDs),axis = 0)
os.chdir(r'D:\FMRI_ROOT\YIYU\MVPA')
np.save('data_whole_brain.npy',data)

