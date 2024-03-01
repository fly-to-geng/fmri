# -*- coding: utf-8 -*-
"""
Created on Thu Feb 23 10:53:15 2017

@author: FF120

生成双样本T检验显著的特征的名称和显著值
"""
import numpy as np
import scipy.io as sio
import os
"""
设置路径，并加载需要的变量
"""
# 需要的数据和生成的结果保存在这里或者其子文件夹下
root = r'D:\FMRI_ROOT\YIYU\CONN\conn_project04\meresult'#####################
save_root = os.path.join(root,'class_result')
# 特征对应的标签
brain_region_names = r'features_from_fc_aal_first_level_vs_names.mat'###########################
# 特征矩阵，第一列是标签
X_path = r'features_from_fc_aal_first_level.mat'############################################################
y_path = r'y.npy'

# 加载数据转成python格式
data_root = os.path.join(root,'data')
features_name = sio.loadmat(os.path.join(data_root,brain_region_names))['brain_map_names']
features_name = [i for i in features_name[0]]
features_name = np.asarray(features_name)
features=sio.loadmat(os.path.join(data_root,X_path))['subjects_features_mat']
y = np.load(os.path.join(data_root,y_path))
#####################################################################
from scipy import stats
p = 0.05
hc = features[0:26,:]
mdd = features[26:,:]
indepedent_t = stats.ttest_ind(hc,mdd,axis=0)
p3 = indepedent_t[1]
remain_mask3 = p3<p
new_X = features[:,remain_mask3]
new_name = features_name[remain_mask3]
new_p = p3[remain_mask3]
result_dict = {}
for i in range(len(new_p)):
    result_dict[new_name[i][0]] = new_p[i]
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=False)

import xlwt
os.chdir('d:/')
workbook = xlwt.Workbook(encoding = 'ascii')   
worksheet = workbook.add_sheet('connection_weight_aal')#################################
for i in range(len(feature_sorted)):
    worksheet.write(i, 0, label = feature_sorted[i][0].split('->')[0])
    worksheet.write(i, 1, label = feature_sorted[i][0].split('->')[1])  
    worksheet.write(i, 2, label = feature_sorted[i][1])   
workbook.save(r't_test_aal.xls')