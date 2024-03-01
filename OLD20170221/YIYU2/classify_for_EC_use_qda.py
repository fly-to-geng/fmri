# -*- coding: utf-8 -*-
"""
Created on Fri Dec 30 15:27:40 2016

@author: FF120
"""
import numpy as np

X_root = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_FC_dmn.npy'
y_root = r'D:\FMRI_ROOT\YIYU\MVPA\features_vs_labels_dmn.npy'
X = np.load(X_root)
y = np.load(y_root)
#for i in range(yy.shape[0]):
#    if yy[i]== 1:
#        yy[i] = -1
#    if yy[i] == 2:
#        yy[i] = 1
#y = yy 
n_folds = 5
from sklearn.cross_validation import StratifiedShuffleSplit
cv = StratifiedShuffleSplit(y, n_folds, test_size=0.5, random_state=0)

# 准确率达到90%，目前是最高的。
from sklearn.qda import QDA
qda = QDA()
#qda.fit(X, y, store_covariances=True)
#predicted_y = qda.predict(X_test)


from sklearn import metrics
from sklearn.cross_validation import cross_val_predict
predicted = cross_val_predict(qda, X,y, cv=n_folds)
print("cross_val_predict_Accuracy: %0.2f" % metrics.accuracy_score(y, predicted) )
# 计算正确率
#count = 0
#for i in range(y_test.shape[0]):
#    if predicted_y[i]>0 and y_test[i] > 0:
#        count = count + 1
#    if predicted_y[i]<0 and y_test[i] < 0:
#        count = count + 1
#        
#acc = float(count) / y_test.shape[0]
#print acc