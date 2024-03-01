# -*- coding: utf-8 -*-
"""
Created on Wed Dec 28 11:05:26 2016

@author: FF120

使用一个大规模的特征，利用多种降维方法降维，再用同一个分类方法测试降维的效果
1. 方差
2. F值
3. 递归特征消除
4. L1
5. 基于树模型的特征选择
6. 使用线性判别分析（LDA）进行特征选择
"""

import numpy as np
import math
import os
import scipy.io as sio 
from sklearn.cross_validation import KFold
from sklearn import preprocessing

# 设置路径
X_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_FC_aal.npy'
y_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_vs_labels_aal.npy'
names_path = r'D:\FMRI_ROOT\YIYU\MVPA\feature_vs_names_aal.npy'
# 分折交叉验证参数
n_folds = 30
# 加载数据
X = np.load(X_path)
y = np.load(y_path)
names = np.load(names_path)

"""
划分训练用数据和测试用数据
在训练数据集上通过训练和交叉验证选择合适的参数和特征选择方法
在测试集上测试效果
"""
from sklearn import cross_validation
test_size = 0.3 # 测试数据集占总数据集的百分比
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y, test_size=test_size, random_state=0)

"""
定义用于测试效果的分类器
"""
from sklearn.svm import SVC
svc = SVC(C=1,kernel="linear") # 用来为特征赋权值的分类器

"""
===============================================================================
===============================================================================
===============================================================================
===============================================================================
基本方法，去除方差较小的特征
===============================================================================
"""
from sklearn.feature_selection import VarianceThreshold
vt_step = 50 # 将方差最大值和最小值分成vt_step份，从小到大做vt_step次，找出分类准确率最大的合适的值。
vt = VarianceThreshold()
X_vt = vt.fit_transform(X_train)
threshold_min = np.min(vt.variances_)
threshold_max = np.max(vt.variances_)
thresholds = []
# 生成参数列表
for i in range(vt_step):
    kuan = (threshold_max-threshold_min)/vt_step
    thresholds.append(threshold_min+(kuan*i))
 
# 搜索最优的参数 
svc_score_vt = []  
svc_feature_num_vt = []
for i in range(len(thresholds)):
    vt_mean = VarianceThreshold(threshold = thresholds[i])
    vt_mean.fit(X_train)
    X_vt_train = vt_mean.transform(X_train)
    svc.fit(X_vt_train,y_train)
    X_vt_test = vt_mean.transform(X_test)
    svc_score_vt.append( svc.score(X_vt_test,y_test) )
    svc_feature_num_vt.append( X_vt_train.shape[1] )

# 绘制结果
import matplotlib.pyplot as plt
print("Optimal number of features : %d" % svc_feature_num_vt[svc_score_vt.index(max(svc_score_vt))])
# Plot number of features VS. cross-validation scores
plt.figure()
plt.title("VarianceThreshold For Feature Selection")
plt.xlabel("Number of features selected")
plt.ylabel("Cross validation score (nb of correct classifications)")
plt.plot(svc_feature_num_vt, svc_score_vt)
plt.show()


"""
===============================================================================
单变量特征选择，用到标签y,检验每个特征和y之间的统计关系，根据统计关系确定排名，选择排名靠前的特征。
===============================================================================
"""
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_classif
sk_f_step = 100 #从最小值到最大值的分割步数
feature_num = X_train.shape[1]
svc_score_sf_k = []
sk_f_scores_lists = []
sk_f_pvalue_lists = []
svc_feature_num_sf_k = []
for i in range(10,feature_num,sk_f_step):
        sk_f = SelectKBest(f_classif,k=i)
        sk_f.fit(X_train,y_train)
        X_sk_f_train = sk_f.transform(X_train)
        svc.fit(X_sk_f_train,y_train)
        X_sk_f_test = sk_f.transform(X_test)
        svc_score_sf_k.append( svc.score(X_sk_f_test,y_test) )
        sk_f_scores_lists.append(sk_f.scores_)
        sk_f_pvalue_lists.append(sk_f.pvalues_)
        svc_feature_num_sf_k.append(i)


# 绘制结果
import matplotlib.pyplot as plt
print("Optimal number of features : %d" % svc_feature_num_sf_k[svc_score_sf_k.index(max(svc_score_sf_k))])
# Plot number of features VS. cross-validation scores
plt.figure()
plt.title("VarianceThreshold For Feature Selection")
plt.xlabel("Number of features selected")
plt.ylabel("Cross validation score (nb of correct classifications)")
plt.plot(svc_feature_num_sf_k, svc_score_sf_k)
plt.show()

"""
===============================================================================
递归特征消除
===============================================================================
"""
from sklearn.feature_selection import RFECV
from sklearn.cross_validation import StratifiedKFold
import matplotlib.pyplot as plt
# =====参数设置=========
step = 1000 # 递归特征消除每次消除的特征数量
n_folds = 2 # 交叉验证的折数

rfecv = RFECV(estimator=svc, step=step, cv=StratifiedKFold(y, n_folds = n_folds),scoring='accuracy')
X_rfecv = rfecv.fit_transform(X, y)

print("Optimal number of features : %d" % rfecv.n_features_)
# Plot number of features VS. cross-validation scores
plt.figure()
plt.xlabel("Number of features selected")
plt.ylabel("Cross validation score (nb of correct classifications)")
plt.plot([i*step for i in range(1, len(rfecv.grid_scores_) + 1)], rfecv.grid_scores_)
plt.show()

"""
===============================================================================
L1-based feature selection 还有其他的稀疏模型
===============================================================================
"""
from sklearn.svm import LinearSVC
Cs = [0.1,1,10,100] # 要搜索的参数
lsvc_score = []
lsvc_scores_lists = []
lsvc_pvalue_lists = []
lsvc_feature_num = []
lsvc_c = []
for i in Cs:  
    lsvc = LinearSVC(C=1, penalty="l1", dual=False)
    lsvc.fit(X_train,y_train)
    X_lsvc_train = lsvc.transform(X_train)
    svc.fit(X_lsvc_train,y_train)
    X_lsvc_test = lsvc.transform(X_test)
    lsvc_score.append( svc.score(X_lsvc_test,y_test) )
    lsvc_feature_num.append(X_lsvc_train.shape[1])
    lsvc_c.append(i)

# 绘制结果
import matplotlib.pyplot as plt
print("Optimal number of features : %d" % lsvc_feature_num[lsvc_score.index(max(lsvc_score))])
# Plot number of features VS. cross-validation scores
plt.figure()
plt.title("VarianceThreshold For Feature Selection")
plt.xlabel("Number of features selected")
plt.ylabel("Cross validation score (nb of correct classifications)")
plt.plot(lsvc_feature_num, lsvc_score)
plt.show()

"""
===============================================================================
Tree-based feature selection
===============================================================================
"""
from sklearn.ensemble import ExtraTreesClassifier
etc = ExtraTreesClassifier()
etc.fit(X_train, y_train)
X_etc_train = etc.transform(X_train)
svc.fit(X_etc_train,y_train)
X_etc_test = etc.transform(X_test)
svc.score(X_etc_test,y_test)

"""
multi-task Lasso feature selection
"""
from sklearn.linear_model import MultiTaskLasso, Lasso
X = X_train
Y = X_train
coef_lasso_ = np.array([Lasso(alpha=0.5).fit(X, y).coef_ for y in Y.T])
coef_multi_task_lasso_ = MultiTaskLasso(alpha=1.).fit(X, Y).coef_

"""
==============================================================================
使用线性判别分析进行特征选择
==============================================================================
"""
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
lda = LinearDiscriminantAnalysis(solver='lsqr',shrinkage='auto')
lda.fit(X_train, y_train)
X_lda_train = lda.transform(X_train)
svc.fit(X_lda_train,y_train)
X_lda_test = lda.transform(X_test)
svc.score(X_lda_test,y_test)
# scikit-learn 模型持久化
from sklearn.externals import joblib
from sklearn.linear_model import LogisticRegression
clf_l1_LR = LogisticRegression(C=0.1, penalty='l1', tol=0.01)
joblib.dump(lda, 'LinearDiscriminantAnalysis.model')