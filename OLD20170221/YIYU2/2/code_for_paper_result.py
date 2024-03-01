# -*- coding: utf-8 -*-
"""
Created on Fri Jan 13 23:33:11 2017

@author: FF120

为论文的result部分生成结果的代码
"""
import os
import scipy.io as sio
import numpy as np

root = r'D:\FMRI_ROOT\YIYU\MVPA'

###############################################################################
#"""
#计算功能连接相减的结果
#"""
HD = r'HD_mean_functional_connectivity_aal_vector.mat'
MDD =r'MDD_mean_functional_connectivity_aal_vector'
names = r'features_from_fc_aal_first_level_vs_names.mat'

HD_vector = sio.loadmat(os.path.join(root,HD))['HD_vector']
MDD_vector = sio.loadmat(os.path.join(root,MDD))['MDD_vector']
names_vector = sio.loadmat(os.path.join(root,names))['brain_map_names']

MHD_vector = MDD_vector - HD_vector
sorted_feature = {}
for i in range(MHD_vector.shape[1]):
    sorted_feature[names_vector[0][i][0]] = MHD_vector[0][i]
    
feature_sorted = sorted(sorted_feature.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
# 去前20个保存起来
strings = ''
for i in range(20):
    strings = strings + feature_sorted[i][0] +"    "+ str(feature_sorted[i][1]) + "\n"
    
f = open(r'D:\1.txt','w')
f.write(strings)
f.close()
#
## 写入Excel
import xlwt
os.chdir(root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('MDD-subtract-HD-AAL-Functional')
for i in range(20):
    r1 = feature_sorted[i][0].split('->')[0]
    r2 = feature_sorted[i][0].split('->')[1]
#    worksheet.write(i, 0, label = r1.split('(')[0].split('.')[1])
#    worksheet.write(i, 1, label = r1.split('(')[0].split('.')[1])
    worksheet.write(i, 0, label = r1.split('.')[1])
    worksheet.write(i, 1, label = r2.split('.')[1])
    worksheet.write(i, 2, label = (feature_sorted[i][1]) )
workbook.save(r'Paper\result\MDD-subtract-HD-AAL-Functional.xls')
#
###############################################################################
"""
特征选择的结果，不同特征数量的情况下，三种分类器的准确率
"""
from sklearn import preprocessing
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.feature_selection import SelectKBest, f_classif


brain_region_names_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_briannetome_second_level_vs_names.npy'
y_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_brainnetome_second_level_vs_labels.npy'
X_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_brainnetome_second_level.npy'

X = np.load(X_path)
y = np.load(y_path)
brain_region_names = np.load(brain_region_names_path)
#X = preprocessing.scale(X) # 标准化

# 设置分类器
svc_linear =  SVC(C=1,kernel="linear")
#svc_rbf = SVC(C=1,kernel="rbf")
#nkc = KNeighborsClassifier(5, weights='uniform')
#lr = LogisticRegression(C=100, penalty='l2', tol=0.0001)
#使用PCA做特征选择
#from sklearn import decomposition
#pca = decomposition.PCA(n_components=0.9)
#pca.fit(X)
#X_reduced = pca.fit_transform(X)
#X = X_reduced

#from sklearn.feature_selection import SelectKBest
#from sklearn.feature_selection import f_classif
#sk_f = SelectKBest(f_classif,k=50)
#X = sk_f.fit_transform(X,y)
# 划分训练集和测试集
#from sklearn.cross_validation import KFold
#cv = KFold(X.shape[0], n_folds=10,shuffle=True)
#score = []
#for train,test in cv:
#    XX_train = sk_f.fit_transform(X[train],y[train])
#    svc_linear.fit(XX_train,y[train])
#    XX_test = sk_f.transform(X[test])
#    score.append( svc_linear.score(XX_test,y[test]) )
# 生成随机标签
#yyy  = [int(round(x+1)) for x in np.random.rand(47,1)]
#y = np.array(yyy)
from sklearn import cross_validation
from sklearn.cross_validation import StratifiedKFold
from sklearn.svm import LinearSVC
lsvc = LinearSVC(C=1, penalty="l1", dual=False)
lsvc.fit(X,y)
X = lsvc.transform(X)
test_size = 0.6
X_train, X_test, y_train, y_test = cross_validation.train_test_split(X,y,test_size=test_size, random_state=0)
#print X_train.shape, y_train.shape
#print X_test.shape, y_test.shape
#XX_train = sk_f.fit_transform(X_train,y_train)
#XX_test = sk_f.transform(X_test)
#from sklearn.feature_selection import RFECV
#rfecv = RFECV(estimator=svc_linear, step=500, cv=StratifiedKFold(y_train, n_folds = 2),scoring='accuracy')
#XX_train = rfecv.fit_transform(X_train, y_train)
#XX_test = rfecv.transform(X_test)

svc_linear.fit(X_train,y_train)
y_pred = svc_linear.predict(X_test)
print svc_linear.score( X_test,y_test )
from sklearn.metrics import classification_report
print classification_report(y_test, y_pred)