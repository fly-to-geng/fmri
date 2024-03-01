# -*- coding: utf-8 -*-
"""
Created on Sat Dec 03 11:19:43 2016

@author: FF120

使用Matlab生成的MVPA之后的结果分类，多被试共同处理
"""
import os
import operator
import scipy.io as sio 
import Utils.fmriUtils as fm 
import numpy as np
from sklearn.svm import SVC

from sklearn.cross_validation import KFold


mvpa_root_path = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA'
multiple_mat_file = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\multiple_mat.mat'
multiple_mat = sio.loadmat(multiple_mat_file)
multiple_mat = multiple_mat['multiple_mat']

X = multiple_mat[:,2:] #特征
y = multiple_mat[:,1] # 标签
y = fm.defineClass(y) # 四分类
subject_num = multiple_mat[:,0] #被试编号
#按照被试做留一交叉验证
cv = KFold(y.shape[0], np.unique(subject_num).shape[0])
cv_scores = []
for train_index, test_index in cv:
    svc = SVC(C=1,kernel="linear",decision_function_shape='ovo')
    svc.fit(X[train_index], y[train_index])
    cv_scores.append(svc.score(X[test_index],y[test_index]))
    
# 保存spyder工作区所有的变量
import dill
os.chdir(mvpa_root_path)
filename= 'classify_subjects.pkl'
dill.dump_session(filename)

lineString = '';
for i in xrange(len(cv_scores)):
    lineString = lineString + str(cv_scores[i]) + '\n'
os.chdir(mvpa_root_path)
output = open('cv_scores.txt', 'w')
output.write(lineString)
output.close()


# 加载spyder工作区所有的变量
#import dill
#filename= 'globalsave.pkl'
#dill.load_session(filename) 