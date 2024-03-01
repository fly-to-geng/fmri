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

def classify_aal(data_root,mvpa_root_path):
    k_fold = 4
    #data_root = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\20160927003\TDLabels'
    #mvpa_root_path = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\20160927003'
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
        cv = KFold(y.shape[0], k_fold,shuffle=True)
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
    lineString = '';
    for i in xrange(len(sorted_result)):
        line = sorted_result[i]
        lineString = lineString + str(round( line[1],4)) + '    ' + str(line[0]) + '\n'
    os.chdir(mvpa_root_path)
    output = open('sorted_result.txt', 'w')
    output.write(lineString)
    output.close()
    return sorted_result
    



subjects = ['20161215002','20161222002']
for i in xrange(len(subjects)):
    data_root = 'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\\'+subjects[i] + '\\TDLabels'
    mvpa_root_path = 'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\\' + subjects[i]
    result = []
    sorted_result = classify_aal(data_root,mvpa_root_path)
    result.append(sorted_result)
    

# 保存spyder工作区所有的变量
import dill
filename= 'classify_tdlabels_shuffle_true.pkl'
dill.dump_session(filename)

    
    
    
