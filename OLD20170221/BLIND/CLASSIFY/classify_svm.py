# -*- coding: utf-8 -*-
"""
Created on Sat Nov 05 18:19:59 2016

@author: FF120
"""
import scipy.io as sio
import numpy as np
import matplotlib.pyplot as plt
from sklearn.svm import SVC
from sklearn.svm import LinearSVC
from sklearn.cross_validation import StratifiedKFold
from sklearn.cross_validation import KFold

from sklearn import preprocessing
'''
n_folds : 交叉验证的折数
mat_file_path : 存放矩阵的完整路径，默认矩阵第一列为标签，剩下的列为特征
'''
n_folds = 5;
mat_file_path = r'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\X_first_level_dcm_w_whole.mat';
data = sio.loadmat(mat_file_path)
data = data['X']
X = data[:,1:]
y = data[:,0].astype(int)

X = preprocessing.scale(X)  # 标准化

cv = StratifiedKFold(y,n_folds)
cv_scores = []
for train, test in cv:
    svc = LinearSVC(C=1)
    svc.fit(X[train], y[train])
    cv_scores.append(svc.score(X[test],y[test]))
print "=====SVM分类准确率======="
print svc
print cv_scores
print np.mean(cv_scores)