# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 18:20:38 2017

@author: FF120

F score 特征选择，
算法来源论文：
"Multivariate classification of social anxiety disorder using whole brain functional connectivity"
"""
###############################################################################
"""
导入需要的包
"""
import os
import scipy.io as sio
import numpy as np
from sklearn.metrics import classification_report,accuracy_score
import matplotlib.pyplot as plt
from sklearn import preprocessing
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.feature_selection import SelectKBest, f_classif
import scipy.io as sio
from sklearn import cross_validation
from sklearn.cross_validation import StratifiedKFold
from sklearn.svm import LinearSVC
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_classif
from sklearn.cross_validation import LeavePOut   

###############################################################################
"""
设置路径，并加载需要的变量
"""
# 需要的数据和生成的结果保存在这里或者其子文件夹下
root = r'D:\FMRI_ROOT\YIYU\CONN\conn_project01\classresult'#####################
# 特征对应的标签
brain_region_names = r'features_from_fc_aal_first_level_vs_names.mat'###########################
# 特征矩阵，第一列是标签
X_path = r'features_from_fc_aal_first_level.mat'############################################################
y_path = r'features_from_fc_brainnetome_second_level_vs_labels.npy'
features = sio.loadmat(os.path.join(root,X_path))
brain_region_names = sio.loadmat(os.path.join(root,brain_region_names))


brain_region_names = brain_region_names['brain_map_names']
features = features['subjects_features_mat']

X = features[:,1:]
y = np.load(os.path.join(root,y_path))
####################################################################
"""
F值特征选择
输入X，y
输出： 每个特征的得分
"""
def my_f_class(X,y):
    y_unique = np.unique(y) # 此处应该只有两个数字，只适用于二分类
    X1 = X[y==y_unique[0]]
    X2 = X[y==y_unique[1]]
    X1_num = X1.shape[0]
    X2_num = X2.shape[0]
    feature_num = X.shape[1]
    feature_score=[]
    for i in range(feature_num):
        #计算第i个特征的相关值
        xi_av = np.mean(X[:,i]) #第i个特征的平均值
        xi_1_av = np.mean(X1[:,i])
        xi_2_av = np.mean(X2[:,i])
        #分子
        a = (xi_1_av-xi_av)**2 + (xi_2_av-xi_av)**2
        s1 = 0
        for j in range(X1_num):
            s1=s1+(X1[j,i]-xi_1_av)**2
        s2 = 0
        for k in range(X2_num):
            s2=s2+(X2[k,i]-xi_2_av)**2
        #分母
        b = 1.0/(X1_num-1)*s1 + 1.0/(X2_num-1)*s2
        feature_score.append(a/b)
    f= np.asarray(feature_score).ravel()
    return f,f

###################################################################
"""
使用scikit-learn提供的selectKBest
"""

sk_f = SelectKBest(f_classif,k=100)
sk_f.fit_transform(X,y)
coef = sk_f.scores_
mask1 = sk_f._get_support_mask()

sk_me = SelectKBest(my_f_class,k=100)
sk_me.fit_transform(X,y)
coef_me = sk_me.scores_
mask2 = sk_f._get_support_mask()

# 两个特征选择方法实际上得到的结果是一样的

