# -*- coding: utf-8 -*-
"""
分类方法，输入是矩阵，第一列是标签，后面是特征，
输出各种分类方法的结果

@author: FF120
"""

import scipy.io as sio
import numpy as np
import matplotlib.pyplot as plt

from time import time
from sklearn.feature_selection import SelectFromModel
from sklearn.linear_model import RidgeClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.linear_model import Perceptron
from sklearn.linear_model import PassiveAggressiveClassifier
from sklearn.pipeline import Pipeline
from sklearn.svm import LinearSVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.neighbors import NearestCentroid
from sklearn.ensemble import RandomForestClassifier
from sklearn.cross_validation import StratifiedKFold
from sklearn.cross_validation import KFold

from sklearn.utils.extmath import density
from sklearn import metrics

'''
n_folds : 交叉验证的折数
mat_file_path : 存放矩阵的完整路径，默认矩阵第一列为标签，剩下的列为特征。
'''
n_folds = 5

# 准备特征和标签
mat_file_path = r'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_w_whole\X_first_level_dcm_w_whole.mat';
data = sio.loadmat(mat_file_path)
data = data['X']
X = data[:,1:]
y = data[:,0].astype(int)

#----------------------------
def benchmarkWithCV(clf,X,y,n_folds):
    print('-' * 80)
    print("Training: ")
    print(clf)
    cv = StratifiedKFold(y,n_folds)
    cv_scores = []
    t0 = time()
    for train, test in cv:   
        clf.fit(X[train], y[train])
        train_time = time() - t0
        print("train time: %0.3fs" % train_time)

        t0 = time()
        pred = clf.predict(X[test])
        test_time = time() - t0
        print("test time:  %0.3fs" % test_time)
        #score = np.sum(pred == y_test) / float(np.size(y_test))
        score = metrics.accuracy_score(y[test], pred)
        cv_scores.append(score)
        print("accuracy:   %0.3f" % score)

        if hasattr(clf, 'coef_'):
            print("dimensionality: %d" % clf.coef_.shape[1])
            print("density: %f" % density(clf.coef_))
        
    clf_descr = str(clf).split('(')[0]
    mean_score = np.mean(cv_scores)
    return clf_descr, mean_score, train_time, test_time  
    
#------------------------------------------------

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
    results.append(benchmarkWithCV(clf,X,y,n_folds))
    
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
