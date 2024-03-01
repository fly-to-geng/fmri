# -*- coding: utf-8 -*-
"""
使用预处理之后的数据加上全脑mask直接分类

@author: FF120
"""
import os
import numpy as np
import Utils.fmriUtils as fm
import sys
import matplotlib.pyplot as plt
import scipy.io as sio
from time import time
from nilearn.input_data import NiftiMasker
from sklearn.linear_model import LogisticRegression
from sklearn.datasets import fetch_20newsgroups
from sklearn.datasets import load_iris
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.feature_extraction.text import HashingVectorizer
from sklearn.feature_selection import SelectKBest, chi2
from sklearn.feature_selection import SelectFromModel
from sklearn.linear_model import RidgeClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.linear_model import Perceptron
from sklearn.linear_model import PassiveAggressiveClassifier
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC
from sklearn.naive_bayes import BernoulliNB, MultinomialNB
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neighbors import NearestCentroid
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import StratifiedKFold
from sklearn.utils.extmath import density
from sklearn import metrics
from nilearn import image
#============================================================================
#读取图像文件转换成特征
root = r"D:\FMRI_ROOT\YANTAI"
save_path = r"D:\FMRI_ROOT\YANTAI\CLASSIFY\RESULT\20160911002"

n_folds = 5

os.chdir(root)
label_path = root+'\DESIGN\label.npy'
empty_tr_path = root+'\DESIGN\empty_tr.npy'
mask_path = root + '\DESIGN\MASK\mask.img'
func_path = r"D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\funcImg\20160911002\4Dwraf20160911002-182750-00006-00006-1.nii"
#func_img = image.load_img(func_path)
label = np.load(label_path)
empty_tr = np.load(empty_tr_path)

nifti_masker = NiftiMasker(mask_img=mask_path, 
                           standardize=True,
                           memory="nilearn_cache", memory_level=1)               
X = nifti_masker.fit_transform(func_path)
X = np.delete(X,empty_tr-1,axis=0)
y = label
os.chdir(save_path)
np.save('X.npy',X)
np.save('y.npy',y)



"""


"""
results = []
for clf, name in (
        (RidgeClassifier(tol=1e-2, solver="sag"), "Ridge Classifier"),
        (Perceptron(n_iter=50), "Perceptron"),
        (PassiveAggressiveClassifier(n_iter=50), "Passive-Aggressive"),
        (KNeighborsClassifier(n_neighbors=10), "kNN"),
        (LinearSVC(loss='l2', penalty='l2',dual=False, tol=1e-3), "Liblinear model with l2"),
        (LinearSVC(loss='l2', penalty='l1',dual=False, tol=1e-3), "Liblinear model with l1"),
        (SGDClassifier(alpha=.0001, n_iter=50,penalty='l2'), "SGD model with l2"),
        (SGDClassifier(alpha=.0001, n_iter=50,penalty='l1'), "SGD model with l1"),        
        (SGDClassifier(alpha=.0001, n_iter=50,penalty="elasticnet"),"SGD model with Elastic-Net penalty" ),       
        (NearestCentroid(), "NearestCentroid without threshold"),
        #(MultinomialNB(alpha=.01),"MultinomialNB"),
        #(BernoulliNB(alpha=.01),"BernoulliNB"),
        (RandomForestClassifier(n_estimators=100), "Random forest"),
        (Pipeline([('feature_selection', SelectFromModel(LinearSVC(penalty="l1", dual=False, tol=1e-3))),('classification', LinearSVC())]),"LinearSVC with L1-based feature selection"),
        ):
    print('=' * 80)
    print(name)
    results.append(fm.benchmarkWithCV(clf,X,y,n_folds))

# make some plots

indices = np.arange(len(results))

results = [[x[i] for x in results] for i in range(4)]

clf_names, score, training_time, test_time = results
training_time = np.array(training_time) / np.max(training_time)
test_time = np.array(test_time) / np.max(test_time)

plt.figure(figsize=(12, 8))
plt.title("Score")
plt.barh(indices, score, .2, label="score", color='r')
plt.barh(indices + .3, training_time, .2, label="training time", color='g')
plt.barh(indices + .6, test_time, .2, label="test time", color='b')
plt.yticks(())
plt.legend(loc='best')
plt.subplots_adjust(left=.25)
plt.subplots_adjust(top=.95)
plt.subplots_adjust(bottom=.05)

for i, c in zip(indices, clf_names):
    plt.text(-.3, i, c)

plt.show()


# 保存spyder工作区所有的变量
os.chdir(save_path)
import dill
filename= 'basic_analysis.pkl'
dill.dump_session(filename)


