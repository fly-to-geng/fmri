# -*- coding: utf-8 -*-
"""
Created on Wed Dec 28 16:57:40 2016

@author: FF120
"""

import numpy as np

X_root = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_FC_dmn.npy'
y_root = r'D:\FMRI_ROOT\YIYU\MVPA\features_vs_labels_dmn.npy'
X = np.load(X_root)
yy = np.load(y_root)
for i in range(yy.shape[0]):
    if yy[i]== 1:
        yy[i] = -1
    if yy[i] == 2:
        yy[i] = 1
y = yy        
from sklearn import cross_validation
test_size = 0.5 # 测试数据集占总数据集的百分比
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y, test_size=test_size, random_state=20)

"""
==============================================================================
linear_model
==============================================================================
"""
from sklearn import linear_model
lmlr = linear_model.LinearRegression()
lmlr.fit(X_train,y_train)
lmlr.coef_
predicted_y = lmlr.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

"""
==============================================================================
Ridge : linear model with ℓ1-norm
==============================================================================
"""
lmr = linear_model.Ridge (alpha = .5)
lmr.fit(X,y)
lmr.coef_
lmr.intercept_
predicted_y = lmr.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc


# ==========有交叉验证的版本
lmrcv = linear_model.RidgeCV(alphas=[0.1, 0.5,1.0, 10.0])
lmrcv.fit(X,y)
lmrcv.alpha_
predicted_y = lmrcv.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

"""
==============================================================================
Lasso : linear model with ℓ2-norm
==============================================================================
"""
lmla = linear_model.Lasso(alpha = 0.001)
lmla.fit(X,y)
lmla.predict(X)

predicted_y = lmla.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

"""
==============================================================================
ElasticNet : linear model with L1 and L2 prior
==============================================================================
"""
lmela = linear_model.ElasticNet(alpha=0.01,l1_ratio=0.9)
lmela.fit(X,y)
predicted_y = lmela.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

"""
Least Angle Regression : 适用于高维数据，缺点是对噪声比较敏感
"""
lmlar = linear_model.Lars(n_nonzero_coefs=10)
lmlar.fit(X,y)
predicted_y = lmlar.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc
"""
BayesianRidge : Bayesian Ridge Regression
小特征数目表现不佳
"""
lmbr = linear_model.BayesianRidge()
lmbr.fit(X,y)
lmbr.coef_
predicted_y = lmbr.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc
"""
ARDRegression : similar to BayesianRidge, but tend to sparse
"""
lmardr = linear_model.ARDRegression(compute_score=True)
lmardr.fit(X, y)
predicted_y = lmardr.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc
"""
Logistic regression
"""
lmlr1 = linear_model.LogisticRegression(C=1, penalty='l1', tol=0.01)
lmlr1.fit(X,y)
predicted_y = lmlr1.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

########################################################
# 目前准确率最高的，逻辑回归加L2正则
lmlr2 = linear_model.LogisticRegression(C=1, penalty='l2', tol=0.01)
lmlr2.fit(X,y)
predicted_y = lmlr2.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

"""
SGDClassifier
"""
lmsdg = linear_model.SGDClassifier()
lmsdg.fit(X,y)
predicted_y = lmsdg.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

"""
Perceptron : 感知机算法
"""
lmper = linear_model.Perceptron()
lmper.fit(X,y)
predicted_y = lmper.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc
"""
PassiveAggressiveClassifier : similar to Perceptron but have peny
"""
lmpac = linear_model.PassiveAggressiveClassifier()
lmpac.fit(X,y)
predicted_y = lmpac.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

"""
Linear discriminant analysis  && quadratic discriminant analysis
"""
from sklearn.lda import LDA
lda = LDA(solver="svd", store_covariance=True)
lda.fit(X, y)
predicted_y = lda.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc

#############################################################
# 准确率达到90%，目前是最高的。
from sklearn.qda import QDA
qda = QDA()
qda.fit(X, y, store_covariances=True)
predicted_y = qda.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc
"""
Kernel ridge regression:
combines Ridge Regression (linear least squares with l2-norm regularization)
with the kernel trick
"""
from sklearn.kernel_ridge import KernelRidge
kr = KernelRidge(alpha=0.1)
kr.fit(X,y)
predicted_y = kr.predict(X_test)

# 计算正确率
count = 0
for i in range(y_test.shape[0]):
    if predicted_y[i]>0 and y_test[i] > 0:
        count = count + 1
    if predicted_y[i]<0 and y_test[i] < 0:
        count = count + 1
        
acc = float(count) / y_test.shape[0]
print acc
"""
Support Vector Machines : 支持向量机分类
"""
from sklearn import svm
svmsvc = svm.SVC(C=0.1,kernel='rbf')
svmsvc.fit(X_train,y_train)
svmsvc.score(X_test,y_test)

#######################################
svmlsvc = svm.LinearSVC(C=0.1,penalty='l2')
svmlsvc.fit(X_train,y_train)
svmsvc.score(X_test,y_test)
"""
Support Vector Regression.
"""
svmsvr = svm.SVR()
svmsvr.fit(X_train,y_train)
svmsvr.score(X_test,y_test)
"""
SGDClassifier 随机梯度下降
"""
from sklearn.linear_model import SGDClassifier
sdg = SGDClassifier(loss="hinge", penalty="l2")
sdg.fit(X_train, y_train)
sdg.score(X_test,y_test)

"""
Nearest Neighbors : 最近邻
"""
from sklearn.neighbors import NearestNeighbors
nbrs = NearestNeighbors(n_neighbors=2, algorithm='ball_tree').fit(X)
distances, indices = nbrs.kneighbors(X)

from sklearn import neighbors
nkc = neighbors.KNeighborsClassifier(15, weights='uniform')
nkc.fit(X_train,y_train)
nkc.score(X_test,y_test)
#################################################################
from sklearn.neighbors import NearestCentroid
clf = NearestCentroid(shrink_threshold=0.1)
clf.fit(X_train, y_train)
clf.score(X_test,y_test)
