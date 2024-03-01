# -*- coding: utf-8 -*-
"""
Created on Thu Dec 29 23:08:18 2016

@author: FF120

参数搜索技巧
"""
import scipy.io as sio

data_path = r'D:\FMRI_ROOT\YIYU\MVPA\YIYU_data_from_DCM_DMN_1.mat'
data = sio.loadmat(data_path)
data = data['data']
X = data[:,1:]
y = data[:,0].astype(int)

from sklearn.svm import SVC
clf = SVC(kernel='linear', C=1)

"""
train_test_split : 简单的划分成两个数据集
"""
from sklearn import cross_validation
test_size = 0.3
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y,test_size=test_size, random_state=0)
print X_train.shape, y_train.shape
print X_test.shape, y_test.shape
"""
cross_val_score:
使用交叉验证解决搜索参数时参数会偷窥到测试数据的问题，
交叉验证最简单的实现方法
进行cv次随机的分割，用训练集训练，用测试集测试，然后得到平均的结果
scores.std() * 2 是方差
scoring: 可以用来指定评分的算法
cv 传入整数的时候分折的时候使用的KFold 或者StratifiedKFold 亦可以传入其他分割方法的实例，例如：
cvsf = cross_validation.ShuffleSplit(n_samples, n_iter=3,test_size=0.3, random_state=0)
传入cv = cvsf就可以使用自定义的ShuffleSplit作为每次划分训练集和测试集的方法
"""
scores = cross_validation.cross_val_score(clf, X,y, cv=5,scoring='f1_weighted')
print("Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))

## 稍微不同的准确率报告策略
from sklearn import metrics
predicted = cross_validation.cross_val_predict(clf, X,y, cv=5)
metrics.accuracy_score(y, predicted)

"""
KFold : 生成分割数据集的所以的技巧
"""
from sklearn.cross_validation import KFold
kf = KFold(8, n_folds=2)
for train, test in kf:
    print("%s %s" % (train, test))

# 划分时保证类别均衡   
from sklearn.cross_validation import StratifiedKFold
labels = [0, 0, 0, 0, 1, 1, 1, 1, 1, 1]
skf = StratifiedKFold(labels, 3)
for train, test in skf:
    print("%s %s" % (train, test))
    
"""
不同的交叉验证类
"""
# 留一交叉验证，通常5到10折交叉验证是更好的选择
from sklearn.cross_validation import LeaveOneOut
loo = LeaveOneOut(4)
for train, test in loo:
    print("%s %s" % (train, test))
# 留P交叉验证
from sklearn.cross_validation import LeavePOut   
lpo = LeavePOut(7, p=2)
for train, test in lpo:
    print("%s %s" % (train, test))
    
# 按照额外提供的标签留一交叉验证,常用的情况是按照时间序列
from sklearn.cross_validation import LeaveOneLabelOut
labels = [1, 1,1, 2, 2]
lolo = LeaveOneLabelOut(labels)
for train, test in lolo:
    print("%s %s" % (train, test))
    
# 按照额外提供的标签留P交叉验证
from sklearn.cross_validation import LeavePLabelOut
labels = [1, 1, 2, 2, 3, 3,3]
lplo = LeavePLabelOut(labels, p=2)
for train, test in lplo:
    print("%s %s" % (train, test))
    
# 可控的随机分组，不考虑y的均衡情况，类似KFold
from sklearn.cross_validation import ShuffleSplit
ss = ShuffleSplit(16, n_iter=3, test_size=0.25,random_state=0)
for train_index, test_index in ss:
    print("%s %s" % (train_index, test_index))

# 考虑y的均衡情况的一种实现  
from sklearn.cross_validation import StratifiedShuffleSplit
import numpy as np
X = np.array([[1, 2], [3, 4], [1, 2], [3, 4]])
y = np.array([0, 0, 1, 1])
sss = StratifiedShuffleSplit(y, 3, test_size=0.5, random_state=0)
for train, test in sss:
    print("%s %s" % (train, test))
    
    
"""
==============================================================================
搜索参数的技巧
获得参数： estimator.get_params()

"""
from sklearn.metrics import classification_report
from sklearn.grid_search import GridSearchCV
tuned_parameters = [{'kernel': ['rbf'], 'gamma': [1e-3, 1e-4],'C': [1, 10, 100, 1000]},{'kernel': ['linear'], 'C': [1, 10, 100, 1000]}]
scores = ['precision', 'recall']

for score in scores:
    print("# Tuning hyper-parameters for %s" % score)
    print()
    clf = GridSearchCV(SVC(C=1), tuned_parameters, cv=5,scoring='%s_weighted' % score)
    clf.fit(X_train, y_train)
    print("Best parameters set found on development set:")
    print()
    print(clf.best_params_)
    print()
    print("Grid scores on development set:")
    print()
    for params, mean_score, scores in clf.grid_scores_:
        print("%0.3f (+/-%0.03f) for %r" % (mean_score, scores.std() * 2, params))
        
    print()
    print("Detailed classification report:")
    print()
    print("The model is trained on the full development set.")
    print("The scores are computed on the full evaluation set.")
    print()
    y_true, y_pred = y_test, clf.predict(X_test)
    print(classification_report(y_true, y_pred))
    print()
    
    
"""
分类准确率的度量
"""
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
cm = confusion_matrix(y_test, y_pred)
def plot_confusion_matrix(cm, title='Confusion matrix', cmap=plt.cm.Blues):
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(iris.target_names))
    plt.xticks(tick_marks, iris.target_names, rotation=45)
    plt.yticks(tick_marks, iris.target_names)
    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    
# ROC 曲线 11.18.4
from sklearn.metrics import roc_curve, auc

# 矩阵
from sklearn.metrics import classification_report
classification_report(y_true, y_pred)