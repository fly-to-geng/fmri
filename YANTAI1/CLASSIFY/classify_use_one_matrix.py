# -*- coding: utf-8 -*-
"""
Created on Sat Jul 23 20:25:14 2016

@author: FF120
"""
import scipy.io as sio 
import numpy as np
from sklearn.svm import SVC
from sklearn.cross_validation import KFold
from sklearn.linear_model import LogisticRegression
from sklearn.feature_selection import SelectFromModel
#import Utils.fmriUtils as fm  #自定义函数

#data_path = r"D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\20160911002\data_NiftiPairs_Resliced_STG.mn.img.mat"
data_path = r"D:\FMRI_ROOT\YANTAI\CONN\conn_project_batch\results\data_Conn.mat"
n_folds = 10
data = sio.loadmat(data_path)
data = data['data']
X = data[:,1:]
y = data[:,0].astype(int)
#y = fm.defineClass(y)

# 使用L1选择特征
clf_l1_LR = LogisticRegression(C=1, penalty='l1', tol=0.001)
clf_l1_LR.fit(X, y)
coef = clf_l1_LR.coef_
model = SelectFromModel(clf_l1_LR, prefit=True)

X = model.transform(X)
y = y
print "====新的特征======="
print X.shape

cv = KFold(y.shape[0], n_folds,shuffle=True)
cv_scores = []
for train, test in cv:
    svc = SVC(C=1,kernel="linear",decision_function_shape='ovo')
    svc.fit(X[train], y[train])
    cv_scores.append(svc.score(X[test],y[test]))
print "=====SVM分类准确率======="
print svc
print cv_scores
print np.mean(cv_scores)