# -*- coding: utf-8 -*-
"""
Created on Sat Jul 23 20:25:14 2016

@author: FF120
"""
import numpy as np
import matplotlib.pyplot as plt
from sklearn.svm import SVC
from sklearn import preprocessing
from sklearn.feature_selection import SelectKBest, f_classif
from sklearn import metrics
from sklearn.feature_selection import VarianceThreshold
from sklearn.cross_validation import StratifiedShuffleSplit
from sklearn.cross_validation import cross_val_predict
from sklearn.neighbors import KNeighborsClassifier
brain_region_names_path = r'D:\FMRI_ROOT\YIYU\MVPA\feature_vs_names_brainnetome.npy'
y_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_vs_labels_brainnetome.npy'
X_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_FC_brainnetome.npy'
n_folds = 10

X = np.load(X_path)
y = np.load(y_path)
brain_region_names = np.load(brain_region_names_path)
X = preprocessing.scale(X) # 标准化
# 设置分类器  
svc_linear =  SVC(C=1,kernel="linear")
svc_rbf = SVC(C=1,kernel="rbf")
nkc = KNeighborsClassifier(5, weights='uniform')
#1. 第一步特征选择，去掉方差为0的特征

varThresh = VarianceThreshold(threshold = 0)
X1 = varThresh.fit_transform(X)
print("==== 新特征数量：%d" % X1.shape[1])
print( "==== 方差为0的特征数量：%d" % np.sum(varThresh.variances_ == 0) )
#2. Select K best 选择前K个特征
cv = StratifiedShuffleSplit(y, n_folds, test_size=0.5, random_state=0)
#cv = KFold(y.shape[0], n_folds,shuffle=True)
cv_scores = []
n_step = 50
# 特征选择
Ks = np.linspace(10,500,n_step).astype(int)
scores_linear_svc = []
scores_rbf_svc = []
scores_nkc = []
for i in xrange(Ks.shape[0]):
    feature_selection = SelectKBest(f_classif, k=Ks[i]) 
    X_transformed = feature_selection.fit_transform(X,y)
    
    predicted_linear = cross_val_predict(svc_linear, X_transformed,y, cv=n_folds)
    scores_linear_svc.append( metrics.accuracy_score(y, predicted_linear) )
        
    predicted_rbf = cross_val_predict(svc_rbf, X_transformed,y, cv=n_folds)
    scores_rbf_svc.append( metrics.accuracy_score(y, predicted_rbf) )  
    
    predicted_nkc = cross_val_predict(nkc, X_transformed,y, cv=n_folds)
    scores_nkc.append( metrics.accuracy_score(y, predicted_nkc) )
    
# 绘制结果
plt.plot(Ks, scores_linear_svc, 'b--',label='Linear_SVM' , lw=2)
plt.plot(Ks, scores_rbf_svc, 'r-',label='NonLinear_SVM' , lw=2)
plt.plot(Ks, scores_nkc, 'g*',label='KNN' , lw=2)
#plt.xlim([-0.05, 1.05])
plt.ylim([0.8, 1.05])
plt.xlabel('Feature Num')
plt.ylabel('Accuracy')
plt.title('Feature Num vs Accuracy')
plt.legend(loc="lower right")
plt.show()












#result_dict = {}
#feature_score = feature_selection.scores_
#for i in xrange(feature_score.shape[0]):
#    result_dict[brain_region_names[i]] =  feature_score[i]
#feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)


#for train, test in cv:
#    svc = SVC(C=1,kernel="linear",decision_function_shape='ovo')
#    svc.fit(X[train], y[train])
#    cv_scores.append(svc.score(X[test],y[test]))
#print "=====SVM分类准确率======="
#print svc
#print cv_scores
#print np.mean(cv_scores)




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