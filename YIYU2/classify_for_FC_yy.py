# -*- coding: utf-8 -*-
"""
Created on Sat Jul 23 20:25:14 2016

@author: FF120
"""
import numpy as np
import math
import scipy.io as sio 
from sklearn.svm import SVC
from sklearn.cross_validation import KFold
from sklearn import preprocessing
from sklearn.feature_selection import SelectKBest, f_classif

data_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_FC_dmn.mat'
brain_names_path = r'D:\FMRI_ROOT\YIYU\MVPA\brain_map_names_dmn.mat'
n_folds = 30
data = sio.loadmat(data_path)
brain_names = sio.loadmat(brain_names_path)
data = data['feature_mat']
brain_names = brain_names['brain_map_names']
brain_map_list = []
for i in xrange(brain_names.shape[1]):
    brain_map_list.append(brain_names[0][i][0])
    
# 取对角作为特征，不包括对角线
data_after = []
for i in xrange(data.shape[0]):
    n = int( math.sqrt(data.shape[1]) )
    v = data[i,:].reshape(n,n)
    list_v = []
    for k in range(1,n):
        for m in range(k):
            list_v.append( v[k][m] )
    
    nd_v = np.array(list_v)
    data_after.append(nd_v)
    
X = np.array(data_after)    

# 制作标签 前28个是正常被试，后25个是YY被试
labels = np.ones((53,1)).astype(int)
labels[28:,0] = 2
labels = labels.reshape(-1,)
X = preprocessing.scale(X) # 标准化
y = labels
cv = KFold(y.shape[0], n_folds,shuffle=True)
cv_scores = []
# 特征选择
result_dict = {}
feature_selection = SelectKBest(f_classif, k=6) # 选择前200维特征
X = feature_selection.fit_transform(X,y)
feature_score = feature_selection.scores_
for i in xrange(feature_score.shape[0]):
    result_dict[brain_map_list[i]] =  feature_score[i]
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)


for train, test in cv:
    svc = SVC(C=1,kernel="linear",decision_function_shape='ovo')
    svc.fit(X[train], y[train])
    cv_scores.append(svc.score(X[test],y[test]))
print "=====SVM分类准确率======="
print svc
print cv_scores
print np.mean(cv_scores)