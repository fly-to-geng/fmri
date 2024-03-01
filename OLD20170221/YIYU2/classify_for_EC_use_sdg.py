# -*- coding: utf-8 -*-
"""
Created on Sat Jul 23 20:25:14 2016

@author: FF120
"""
import numpy as np
import scipy.io as sio
from sklearn.svm import SVC
from sklearn import preprocessing
from sklearn.feature_selection import SelectKBest, f_classif
from sklearn.feature_selection import VarianceThreshold

data_path = r'D:\FMRI_ROOT\YIYU\MVPA\YIYU_data_from_DCM_DMN_1.mat'
n_folds = 5
data = sio.loadmat(data_path)
data = data['data']
X = data[:,1:]
X = preprocessing.scale(X) # 标准化
y = data[:,0].astype(int)

from sklearn.cross_validation import StratifiedShuffleSplit
cv = StratifiedShuffleSplit(y, n_folds, test_size=0.5, random_state=0)
#===================================================
#cv = KFold(y.shape[0], n_folds,shuffle=False)
#====================================================
#cv_scores = []
# ----------------------------------------------------------------------------
# 1. 第一步特征选择，去掉方差为0的特征
#varThresh = VarianceThreshold(threshold = 0)
#X1 = varThresh.fit_transform(X)
#print("==== 新特征数量：%d" % X1.shape[1])
#print( "==== 方差为0的特征数量：%d" % np.sum(varThresh.variances_ == 0) ) 
#-----------------------------------------------------------------------------
# 2. 支持向量机分类

#for train, test in cv:
#    svc = SVC(C=50,kernel="linear",gamma=1e-4)
#    svc.fit(X[train], y[train])
#    cv_scores.append(svc.score(X[test],y[test]))
#print "=====SVM分类准确率======="
#print svc
#print cv_scores
#print np.mean(cv_scores)
# 定义分类模型
from sklearn.linear_model import SGDClassifier
svc = SGDClassifier(loss="squared_epsilon_insensitive", penalty="l2")

# ----------------------------------------------------------------------------
from sklearn import cross_validation
scores = cross_validation.cross_val_score(svc, X,y, cv=n_folds,scoring='f1_weighted')
print("cross_val_score_Accuracy: %0.2f (+/- %0.2f)" % (scores.mean(), scores.std() * 2))


from sklearn import metrics
predicted = cross_validation.cross_val_predict(svc, X,y, cv=n_folds)
print("cross_val_predict_Accuracy: %0.2f" % metrics.accuracy_score(y, predicted) )

from sklearn.metrics import classification_report
print("--------------------------------------------------")
print classification_report(y, predicted)
print("--------------------------------------------------")

# 以混淆矩阵的形式显示分类结果
import matplotlib.pyplot as plt
def plot_confusion_matrix(cm, title='Confusion matrix', cmap=plt.cm.Reds):
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(2)
    plt.xticks(tick_marks, ['NC','MDD'], rotation=45)
    plt.yticks(tick_marks, ['NC','MDD'])
    plt.tight_layout()
    plt.ylabel('True label')
    plt.xlabel('Predicted label')
    
from sklearn.metrics import confusion_matrix
predicted = cross_validation.cross_val_predict(svc, X,y, cv=5)
cm = confusion_matrix(y, predicted)
print("--------------------------------------------------")
print cm
print("--------------------------------------------------")
#plot_confusion_matrix(cm)

# 以ROC曲线的形式显示分类结果
#from sklearn.metrics import roc_curve, auc
#from scipy import interp
#import matplotlib.pyplot as plt
#mean_tpr = 0.0
#mean_fpr = np.linspace(0, 1, 100)
#all_tpr = []
#for i, (train, test) in enumerate(cv):
#    probas_ = svc.fit(X[train], y[train]).predict_proba(X[test])
#    # Compute ROC curve and area the curve
#    fpr, tpr, thresholds = roc_curve(y[test], probas_[:, 1],pos_label=1)
#    mean_tpr += interp(mean_fpr, fpr, tpr)
#    mean_tpr[0] = 0.0
#    roc_auc = auc(fpr, tpr)
#    plt.plot(fpr, tpr, lw=1, label='ROC fold %d (area = %0.2f)' % (i, roc_auc))
#
#plt.plot([0, 1], [0, 1], '--', color=(0.6, 0.6, 0.6), label='Luck')
#mean_tpr /= len(cv)
#mean_tpr[-1] = 1.0
#mean_auc = auc(mean_fpr, mean_tpr)
#plt.plot(mean_fpr, mean_tpr, 'k--',
#label='Mean ROC (area = %0.2f)' % mean_auc, lw=2)
#plt.xlim([-0.05, 1.05])
#plt.ylim([-0.05, 1.05])
#plt.xlabel('False Positive Rate')
#plt.ylabel('True Positive Rate')
#plt.title('Receiver operating characteristic example')
#plt.legend(loc="lower right")
#plt.show()