# -*- coding: utf-8 -*-
"""
Created on Sun Dec 04 12:08:25 2016

@author: FF120

批量特征分类

"""
import os
import scipy.io as sio 
import operator
import Utils.fmriUtils as fm 
import numpy as np
from sklearn.svm import SVC

from sklearn.cross_validation import KFold
k_fold = 4
data_root = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\20160911002\AAL'
mvpa_root_path = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA'
os.chdir(data_root)
aal_datas = os.listdir(data_root)
aal_score = []
# 每个循环做一个mask的分类
for i in xrange(len(aal_datas)):
    aal_mask_data = sio.loadmat(aal_datas[i])
    aal_mask_data = aal_mask_data['data_STG']
    X = aal_mask_data[:,1:]
    y = aal_mask_data[:,0]
    y = fm.defineClass(y)
    cv = KFold(y.shape[0], k_fold)
    cv_scores = []
    for train_index, test_index in cv:
        svc = SVC(C=1,kernel="linear",decision_function_shape='ovo')
        svc.fit(X[train_index], y[train_index])
        cv_scores.append(svc.score(X[test_index],y[test_index]))
        
    score = np.mean(cv_scores)
    print "============="
    print i
    print score
    aal_score.append(score)

# 将Mask的名字和分类结果保存在一起
result=dict(zip(aal_datas[::-1],aal_score))
# 按照准确率降序排列
sorted_result = sorted(result.items(), key=operator.itemgetter(1),reverse = True)
# 保存spyder工作区所有的变量
import dill
os.chdir(mvpa_root_path)
filename= 'classify_aal.pkl'
dill.dump_session(filename)

#import operator
#x = {1: 2, 3: 4, 4: 3, 2: 1, 0: 0}
#sorted_x = sorted(x.items(), key=operator.itemgetter(1))
    
    
    
