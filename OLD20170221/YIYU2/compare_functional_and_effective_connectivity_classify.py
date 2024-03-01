# -*- coding: utf-8 -*-
"""
Created on Tue Jan 10 13:15:14 2017

@author: FF120

使用DMN_DAN_SN网络所包含的脑区做功能连接和有效连接
用功能连接和有效连接的结果分类
按照特征的重要程度从大到小排序，生成连接文件
"""
import numpy as np
import os
import scipy.io as sio
from sklearn.feature_selection import VarianceThreshold
import matplotlib.pyplot as plt
from sklearn.svm import SVC
from sklearn import preprocessing
from sklearn.feature_selection import SelectKBest, f_classif
from sklearn import metrics
from sklearn.cross_validation import StratifiedShuffleSplit
from sklearn.cross_validation import cross_val_predict
from sklearn.neighbors import KNeighborsClassifier
##############################################################################
"""
将排序好的特征保存下来并且生成连接文件
feature_sorted : 排序好的特征，list形式，每个list元素是一个元组(key,value)
key是特征的名称，value是特征的一个排序值
save_full_name ：带完整路径的文件名
"""
def save_feature_sorted(feature_sorted,save_full_name):
    strings = ''
    minnum = 0;
    for key,value in feature_sorted:
        if minnum > value:
            minnum = value
    for i in range(len(feature_sorted)):
        key = feature_sorted[i][0]
        value = feature_sorted[i][1]
        ks = key.split('->')
        strings = strings + ks[0]+' 0 100 '+ks[1]+' 0 100 '+ 'thickness='+str(value+(-minnum)+1)+',color=melcolor'+str(i%60)+',z='+str(60-i)+'\n'
    
    file_object2 = open(save_full_name, 'w')
    file_object2.write(strings)
    file_object2.close()  
##############################################################################        
"""
设置数据的路径
"""
data_root = r'D:\FMRI_ROOT\YIYU\MVPA'
features_functional_file = r'features_from_fc_DMN_DAN_SN_second_level.mat'
features_functional_names_file = r'features_from_fc_DMN_DAN_SN_second_level_vs_names.mat'
features_effective_file = r'features_vs_labels_from_DCM_DMN_DAN_SN.mat'
features_effective_names_file = r'features_vs_labels_from_DCM_DMN_DAN_SN_vs_names.mat'
labels = r'features_from_fc_brainnetome_second_level_vs_labels.npy'
"""
加载需要的数据
"""
features_functional = sio.loadmat(os.path.join(data_root,features_functional_file))
features_functional_names = sio.loadmat(os.path.join(data_root,features_functional_names_file))
features_effective = sio.loadmat(os.path.join(data_root,features_effective_file))
features_effective_names = sio.loadmat(os.path.join(data_root,features_effective_names_file))
labels = np.load(os.path.join(data_root,labels))
##############################################################################
"""
准备好特征X, 类别标签y,和特征名称brain_map_names
"""
X = features_effective['data'][:,1:]
y = labels
brain_map_names = features_effective_names['effective_feature_names'][0]
##############################################################################
"""
初步预处理，去掉方差为0的特征
"""
varThresh = VarianceThreshold(threshold = 0)
X = varThresh.fit_transform(X)
print("==== 新特征数量：%d" % X.shape[1])
print( "==== 方差为0的特征数量：%d" % np.sum(varThresh.variances_ == 0) ) 
##############################################################################
"""
使用SelctKBest进行特征搜索，得到准确率最高的前K维特征，并得到特征排序
"""
##############################################################################
#n_step = 10
#n_folds = 10
#Ks = np.linspace(1,41,41).astype(int)
#scores_linear_svc = []
#scores_rbf_svc = []
#scores_nkc = []
#scores_lr = []
#feature_sorted_Ks = []
#svc_linear =  SVC(C=1,kernel="linear")
#svc_rbf = SVC(C=1,kernel="rbf",gamma=0.001)
#nkc = KNeighborsClassifier(4, weights='uniform')
#from sklearn import linear_model
#lr = linear_model.LogisticRegression(C=100, penalty='l2', tol=0.0001)
#for i in xrange(Ks.shape[0]):
#    feature_selection = SelectKBest(f_classif, k=Ks[i]) 
#    X_transformed = feature_selection.fit_transform(X,y)
#    
#    predicted_linear = cross_val_predict(svc_linear, X_transformed,y, cv=n_folds)
#    scores_linear_svc.append( metrics.accuracy_score(y, predicted_linear) )
#        
#    predicted_rbf = cross_val_predict(svc_rbf, X_transformed,y, cv=n_folds)
#    scores_rbf_svc.append( metrics.accuracy_score(y, predicted_rbf) )  
#    
#    predicted_nkc = cross_val_predict(nkc, X_transformed,y, cv=n_folds)
#    scores_nkc.append( metrics.accuracy_score(y, predicted_nkc) )
#     
#    predicted_lr = cross_val_predict(lr, X_transformed,y, cv=n_folds)
#    scores_lr.append( metrics.accuracy_score(y, predicted_lr) )
#    
#    result_dict = {}
#    feature_score = feature_selection.scores_
#    for i in xrange(feature_score.shape[0]):
#        result_dict[brain_map_names[i][0]] =  feature_score[i]
#    feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
#    feature_sorted_Ks.append(feature_sorted)
#    
##os.chdir(save_path)
##np.save('sorted_feature_selection_by_selectKBest',feature_sorted_Ks[0])   
## 绘制结果
#plt.plot(Ks, scores_linear_svc, 'b--',label='Linear_SVM' , lw=2)
#plt.plot(Ks, scores_rbf_svc, 'r-',label='NonLinear_SVM' , lw=2)
#plt.plot(Ks, scores_nkc, 'y--',label='KNN' , lw=2)
#plt.plot(Ks, scores_lr, 'b-',label='LR' , lw=2)
#
##plt.xlim([-0.05, 1.05])
##plt.ylim()
#plt.xlabel('Feature Num')
#plt.ylabel('Accuracy')
#plt.title('Feature Num vs Accuracy')
#plt.legend(loc="lower right")
#plt.show()
##############################################################################
"""
使用上面搜索得到的K值做特征选择之后，进行分类，按照分类器赋予的特征权值对特征排序，
比较分类器对特征的排序和特征选择步骤对特征的排序的差异
K = 14的时候逻辑回归获得了最大的准确率
"""
##############################################################################
K = 10
feature_selection = SelectKBest(f_classif, k=K) 
X_transformed = feature_selection.fit_transform(X,y)
feature_names = []
for i in brain_map_names:
    feature_names.append(i[0])

# 得到selectKBest的特征排名 
feature_score = feature_selection.scores_
result_dict = {}
for i in xrange(feature_score.shape[0]):
    result_dict[feature_names[i]] =  feature_score[i]
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
feature_mask = feature_selection.get_support()

# 特征选择之后留下的特征对应的特征名称
feature_names = np.array(feature_names) 
transformed_feature_name = feature_names[feature_mask]

n_folds = 10
svc_linear =  SVC(C=1,kernel="linear")
predicted_linear = cross_val_predict(svc_linear, X_transformed,y, cv=n_folds)
print metrics.accuracy_score(y, predicted_linear)
svc_linear.fit(X_transformed,y)
# 排序特征
coef_svc = svc_linear.coef_
result_dict = {}
for i in xrange(coef_svc.shape[1]):
    result_dict[transformed_feature_name[i]] =  coef_svc[0][i]
coef_svc_feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
save_feature_sorted(coef_svc_feature_sorted,r'D:\FMRI_ROOT\coef_svc_feature_sorted.txt')
# KNN分类算法
neighbors = 4
nkc = KNeighborsClassifier(n_neighbors=neighbors, weights='uniform')
predicted_rbf = cross_val_predict(nkc, X_transformed,y, cv=n_folds)
print metrics.accuracy_score(y, predicted_rbf)

# 逻辑回归算法
from sklearn import linear_model
lr = linear_model.LogisticRegression(C=100, penalty='l2', tol=0.0001)
predicted_lr = cross_val_predict(lr, X_transformed,y, cv=n_folds)
print metrics.accuracy_score(y, predicted_lr)
# 排序特征
lr.fit(X_transformed,y)
coef_lr = lr.coef_
result_dict = {}
for i in xrange(coef_svc.shape[1]):
    result_dict[transformed_feature_name[i]] =  coef_lr[0][i]
coef_lr_feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
save_feature_sorted(coef_lr_feature_sorted,r'D:\FMRI_ROOT\coef_lr_feature_sorted.txt')

##############################################################################
"""
用递归特征消除选择特征，保存各个特征的权值
"""
from sklearn.feature_selection import RFECV
from sklearn.cross_validation import StratifiedKFold
# =====参数设置=========
step = 1 # 递归特征消除每次消除的特征数量
n_folds = 10 # 交叉验证的折数
svc_linear =  SVC(C=1,kernel="linear")
lr = linear_model.LogisticRegression(C=100, penalty='l2', tol=0.0001)

rfecv = RFECV(estimator=lr, step=step, cv=StratifiedKFold(y, n_folds = n_folds),scoring='accuracy')
X_rfecv = rfecv.fit_transform(X, y)

predicted_rbf = cross_val_predict(svc_linear, X_rfecv,y, cv=n_folds)
print metrics.accuracy_score(y, predicted_rbf)
# 获得特征排名
feature_mask = rfecv.support_
ranking = rfecv.ranking_

feature_names = np.array(feature_names) 
transformed_feature_name = feature_names[feature_mask]
lr.fit(X_rfecv,y)
feature_score = lr.coef_

result_dict = {}
for i in xrange(feature_score.shape[1]):
    result_dict[feature_names[i]] =  feature_score[0][i]
feature_sorted_rfecv = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
save_feature_sorted(feature_sorted_rfecv,r'D:\FMRI_ROOT\feature_sorted_rfecv.txt')



print("Optimal number of features : %d" % rfecv.n_features_)
# Plot number of features VS. cross-validation scores
plt.figure()
plt.xlabel("Number of features selected")
plt.ylabel("Cross validation score (nb of correct classifications)")
plt.plot([i*step for i in range(1, len(rfecv.grid_scores_) + 1)], rfecv.grid_scores_)
plt.show()
