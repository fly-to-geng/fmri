# -*- coding: utf-8 -*-
"""
Created on Sat Jul 23 20:25:14 2016

@author: FF120
"""
import scipy.io as sio 
import numpy as np
from sklearn.svm import SVC
from sklearn.svm import LinearSVC
from sklearn.cross_validation import KFold

import Utils.fmriUtils as fm  #自定义函数

#data_path = r"D:\ss\data_MNI_Superior Temporal Gyrus.img.mat"
#data_path = r'D:\ss\data_NiftiPairs_Resliced_STG.mn.img.mat'
#data_path = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\20160911002\data_NiftiPairs_Resliced_STG.mn.img.mat'
data_path = r'D:\FMRI_ROOT\YIYU\MVPA\YIYU_data.mat'
n_folds = 10
data = sio.loadmat(data_path)
data = data['data']
X = data[:,1:]
y = data[:,0].astype(int)
#y = fm.defineClass(y)
cv = KFold(y.shape[0], n_folds,shuffle=False)
cv_scores = []
for train, test in cv:
    svc = SVC(C=1,kernel="linear",decision_function_shape='ovo')
    svc.fit(X[train], y[train])
    cv_scores.append(svc.score(X[test],y[test]))
print "=====SVM分类准确率======="
print svc
print cv_scores
print np.mean(cv_scores)