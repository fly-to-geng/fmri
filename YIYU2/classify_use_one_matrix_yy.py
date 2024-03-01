# -*- coding: utf-8 -*-
"""
Created on Sat Jul 23 20:25:14 2016

@author: FF120
"""
import numpy as np
import scipy.io as sio 
from sklearn.svm import SVC
from sklearn.cross_validation import KFold
from sklearn import preprocessing
from sklearn.feature_selection import SelectKBest, f_classif

data_path = r'D:\FMRI_ROOT\YIYU\MVPA\YIYU_data_from_DCM_DMN_1.mat'
n_folds = 48
data = sio.loadmat(data_path)
data = data['data']
X = data[:,1:]
#X = preprocessing.scale(X) # 标准化
y = data[:,0].astype(int)
cv = KFold(y.shape[0], n_folds,shuffle=True)
cv_scores = []

#feature_selection = SelectKBest(f_classif, k=16) # 选择前200维特征
#X = feature_selection.fit_transform(X,y)

for train, test in cv:
    svc = SVC(C=1,kernel="linear",decision_function_shape='ovo')
    svc.fit(X[train], y[train])
    cv_scores.append(svc.score(X[test],y[test]))
print "=====SVM分类准确率======="
print svc
print cv_scores
print np.mean(cv_scores)