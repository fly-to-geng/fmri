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



#######################################################
"""
实验另外一个论文中的特征选择方法
"Identifying major depression using wholebrain
functional connectivity: a multivariate
pattern analysis"
"""
def signx(n):
    if n>0:
        return 1
    if n<0:
        return -1
    if n==0:
        return 0
        
def my_se(X,y):      
    X = features
    y = y
    y_unique = np.unique(y)
    hc_mask = y==y_unique[0]
    mdd_mask = y==y_unique[1]
    y[hc_mask] = 1
    y[mdd_mask] = -1
    hc_num = np.sum(hc_mask)
    mdd_num = np.sum(mdd_mask)
    features_weight = np.zeros((1,X.shape[1]))
    for k in range(X.shape[1]): #循环计算每个特征
        nc = 0
        nd = 0
        # 1. 计算nc nd
        for i in range(hc_num):
            for j in range(hc_num,hc_num+mdd_num):
                a = signx( X[i,k]-X[j,k] )
                b = signx(y[i]-y[j])
                if a == b:
                    nc = nc + 1
                elif a == -b:
                    nd = nd + 1
                else:
                    print "==============="
                    print X[i,k],X[j,k]
                    print (i,j)
        # 计算特征权重 
        features_weight[0,k] = float(nc-nd)/ ( hc_num * mdd_num  ) 
        f= np.asarray(features_weight).ravel() 
        return f,f
        
"""
使用scikit-learn提供的selectKBest
"""
X = features
y = y
k_num = 1000


sk_f = SelectKBest(f_classif,k=k_num)
sk_f.fit_transform(X,y)
coef = sk_f.scores_
mask1 = sk_f._get_support_mask()
print np.sum(mask1)

sk_me = SelectKBest(my_f_class,k=k_num)
sk_me.fit_transform(X,y)
coef_me = sk_me.scores_
mask2 = sk_me._get_support_mask()
print np.sum(mask2)

sk_c = SelectKBest(my_se,k=k_num)
sk_c.fit_transform(X,y)
coef_c = sk_c.scores_
mask3 = sk_c._get_support_mask()
print np.sum(mask3)

a = np.logical_and(mask1,mask3)
print np.sum(a)
b = np.logical_or(mask1,mask3)
print np.sum(b)
# 两个特征选择方法实际上得到的结果是一样的