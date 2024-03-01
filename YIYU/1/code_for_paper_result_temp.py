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
"""
特征选择的结果，不同特征数量的情况下，三种分类器的准确率
"""
from sklearn.metrics import classification_report,accuracy_score
import matplotlib.pyplot as plt
from sklearn import preprocessing
from sklearn.svm import SVC
from sklearn.neighbors import KNeighborsClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.feature_selection import SelectKBest, f_classif
import scipy.io as sio
from sklearn import cross_validation
from sklearn.cross_validation import StratifiedKFold
from sklearn.svm import LinearSVC
from sklearn.feature_selection import SelectKBest
from sklearn.feature_selection import f_classif

# 基于网络的功能连接和有效连接分类

# 功能连接
brain_region_names_path = r'D:\FMRI_ROOT\YIYU\MVPA\feature_vs_names_brainnetome.mat'
y_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_brainnetome_second_level_vs_labels.npy'
X_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_brainnetome_second_level.mat'

X = sio.loadmat(X_path)
y = np.load(y_path)
brain_region_names = sio.loadmat(brain_region_names_path)
brain_region_names = brain_region_names['brain_map_names']
X = X['subjects_features_mat']
X = preprocessing.scale(X) # 标准化
# 设置分类器
svc_linear =  SVC(C=1,kernel="linear")
svc_rbf = SVC(C=1,kernel="rbf")
knn = KNeighborsClassifier(4, weights='uniform')
lr = LogisticRegression(C=1, penalty='l2', tol=0.0001)

from sklearn.cross_validation import LeavePOut   
cv = LeavePOut(y.shape[0], p=1)
#Ks = np.linspace(1,1000,20).astype(int)
Ks = np.array( [144,145,146,147,148,149,150,151,152,153,154,155,156] )
#Ks = np.array( [1,2,3,4,5,6,7,8,9,10,15] )

linear_ks=[]
rbf_ks = []
knn_ks = []
lr_ks = []
for i in xrange(Ks.shape[0]):
    score_linear_svc = []
    score_rbf_svc = []
    score_knn_svc = []
    score_lr_svc = []
    sk_f = SelectKBest(f_classif,k=Ks[i])
    for train,test in cv:
        XX_train = sk_f.fit_transform(X[train],y[train])
        XX_test = sk_f.transform(X[test])
        # ----------------------------------------------------------
        svc_linear.fit(XX_train,y[train])
        score_linear_svc.append( svc_linear.score(XX_test,y[test]) )
        # ----------------------------------------------------------
        svc_rbf.fit(XX_train,y[train])
        score_rbf_svc.append( svc_rbf.score(XX_test,y[test]) )
        # ----------------------------------------------------------
        knn.fit(XX_train,y[train])
        score_knn_svc.append( knn.score(XX_test,y[test]) )
        # ----------------------------------------------------------
        lr.fit(XX_train,y[train])
        score_lr_svc.append( lr.score(XX_test,y[test]) )
    final_score_linear = np.mean(score_linear_svc)
    final_score_rbf = np.mean(score_rbf_svc)
    final_score_knn = np.mean(score_knn_svc)
    final_score_lr = np.mean(score_lr_svc)
    # -------------------------------------
    linear_ks.append(final_score_linear)
    rbf_ks.append(final_score_rbf)
    knn_ks.append(final_score_knn)
    lr_ks.append(final_score_lr)

# 绘制结果
# 弹出窗口显示
#%matplotlib qt
plt.plot(Ks, linear_ks, 'ro-',label='Linear_SVM' , lw=2)
plt.plot(Ks, rbf_ks, 'gs-',label='NonLinear_SVM' , lw=2)
plt.plot(Ks, knn_ks, 'kv--',label='KNN' , lw=2)
plt.plot(Ks, lr_ks, 'cD-',label='LR' , lw=2)
#plt.xlim([-0.05, 1.05])
#plt.ylim([0.8, 1.05])
plt.xlabel('Feature Num')
plt.ylabel('Accuracy')
plt.title('Feature Num vs Accuracy')
#plt.legend(loc=4)
plt.show()

# 选出来特征选择 149 个， 分类器选择线性SVC， 计算特征排序
# ==========================================================================
svc_linear =  SVC(C=1,kernel="linear")
cv = LeavePOut(y.shape[0], p=1)
sk_f = SelectKBest(f_classif,k=68)
score_linear_svc = []
feaure_indexs = []
for train,test in cv:  
    XX_train = sk_f.fit_transform(X[train],y[train])
    XX_test = sk_f.transform(X[test])
    feaure_indexs.append( sk_f.get_support() )
    svc_linear.fit(XX_train,y[train])
    score_linear_svc.append( svc_linear.score(XX_test,y[test]) )   
    
a = np.logical_and(feaure_indexs[0],feaure_indexs[1])
for i in range(2,len(feaure_indexs)):
    a = np.logical_and(a,feaure_indexs[i])
    print np.where(a)[0].shape
# 最后选择出来的在每折交叉验证中都选择的特征   
feature_selected = np.where(a)[0]

# ===================================================================
# 用最后选择的特征做一个分类，看准确率比选择之前是否有所提高
# 结果是所有的准确率都变成了1
X_new = X[:,feature_selected]
svc_linear =  SVC(C=1,kernel="linear")
cv = LeavePOut(y.shape[0], p=1)
score_linear_svc = []
score_feature_weight = [] # 记录每次交叉验证的权重
for train,test in cv:  
    svc_linear.fit(X_new[train],y[train])
    score_linear_svc.append( svc_linear.score(X_new[test],y[test]) ) 
    score_feature_weight.append(svc_linear.coef_.reshape(-1,))
print np.mean(score_linear_svc)
#
## 得到与选择出来的特征对应的名称
names_selected = brain_region_names[:,feature_selected]
names_selected_list = []
for i in range(names_selected[0].shape[0]):
    names_selected_list.append( names_selected[0][i] )
#    
## 得到各个特征在分类的时候所得到的权重，使用线性SVM
score_feature_weight_matrix =  np.array(score_feature_weight)  
mean_score_feature_weight = np.mean(score_feature_weight_matrix,axis=0)
#
## 根据权重排序
result_dict = {}
for i in range(mean_score_feature_weight.shape[0]):
    result_dict[names_selected_list[i][0]] = mean_score_feature_weight[i]
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
#
## 按照各个脑区分得连接 二分之一权重的方式 得到各个脑区的权重，没有的脑区权重为0
def split_aal_name(strs):
    s1 = strs.split('->')[0].split('.')[1]
    s2 = strs.split('->')[1].split('.')[1]
    return s1,s2

regions_weight = {}    
for i in range(len(feature_sorted)):
    key = feature_sorted[i][0]
    vaule = feature_sorted[i][1]
    s1,s2 = split_aal_name(key)
    if regions_weight.has_key(s1):
        print s1
        regions_weight[s1] = regions_weight[s1] + 0.5*feature_sorted[i][1]
    else:
        regions_weight[s1] = 0.5*feature_sorted[i][1]
        
    if regions_weight.has_key(s2):
        print s2
        regions_weight[s2] = regions_weight[s2] + 0.5*feature_sorted[i][1]
    else:
        regions_weight[s2] = 0.5*feature_sorted[i][1]
regions_sorted = sorted(regions_weight.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
# 写入excel, 保存结果
import xlwt
os.chdir(root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('region_weight_whole_func')
for i in range(len(regions_sorted)):
    worksheet.write(i, 0, label = regions_sorted[i][0])
    worksheet.write(i, 1, label = regions_sorted[i][1])
    
worksheet = workbook.add_sheet('connection_weight_whole_func')
for i in range(len(feature_sorted)):
    worksheet.write(i, 0, label = feature_sorted[i][0].split('->')[0])
    worksheet.write(i, 1, label = feature_sorted[i][0].split('->')[1])  
    worksheet.write(i, 2, label = feature_sorted[i][1])   
workbook.save(r'Paper\result\MDD-HD-Brainnetome-Functional.xls')    



 