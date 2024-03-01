# -*- coding: utf-8 -*-
"""
Created on Fri Jan 13 23:33:11 2017

@author: FF120

为论文的result部分生成结果的代码
"""
###############################################################################
"""
导入需要的包
"""
import os
import scipy.io as sio
import numpy as np
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
from sklearn.cross_validation import LeavePOut   
from sklearn.cross_validation import StratifiedShuffleSplit


###############################################################################
"""
设置路径，并加载需要的变量
"""
# 需要的数据和生成的结果保存在这里或者其子文件夹下
root = r'D:\FMRI_ROOT\YIYU\CONN\conn_project02\classresult'#####################
# 特征对应的标签
brain_region_names = r'feature_vs_names_brainnetome.mat'############################
y_path = r'features_from_fc_brainnetome_second_level_vs_labels.npy'
X_path = r'features_from_fc_brainnetome_second_level.mat'

features = sio.loadmat(os.path.join(root,X_path))
brain_region_names = sio.loadmat(os.path.join(root,brain_region_names))


brain_region_names = brain_region_names['brain_map_names']
features = features['subjects_features_mat']

X = features[:,1:]
y = np.load(os.path.join(root,y_path))
###############################################################################
"""
使用F值选择特征，找到分类准确率最高的特征个数和分类器
"""
###############################################################################
def test(X_train,y_train,X_valid,y_valid,feature_num):
    X = X_train
    y = y_train
    X = preprocessing.scale(X) # 标准化
    # 设置分类器
    svc_linear =  SVC(C=1,kernel="linear")
    svc_rbf = SVC(C=1,kernel="rbf")
    knn = KNeighborsClassifier(4, weights='uniform')
    lr = LogisticRegression(C=1, penalty='l2', tol=0.0001)
    cv = LeavePOut(y.shape[0], p=1)
    sk_f = SelectKBest(f_classif,k=143)
    score_linear_svc = []
    feaure_indexs = []
    for train,test in cv:  
        XX_train = sk_f.fit_transform(X[train],y[train])
        XX_test = sk_f.transform(X[test])
        feaure_indexs.append( sk_f.get_support() )
        svc_linear.fit(XX_train,y[train])##################################################
        score_linear_svc.append( svc_linear.score(XX_test,y[test]) )   #######################
    
    print(np.mean(score_linear_svc))
       
    a = np.logical_and(feaure_indexs[0],feaure_indexs[1])
    for i in range(2,len(feaure_indexs)):
        a = np.logical_and(a,feaure_indexs[i])
        print np.where(a)[0].shape
    # 最后选择出来的在每折交叉验证中都选择的特征   
    feature_selected = np.where(a)[0]
    #最后选择出来的共同特征66个
    
    # 用选择的共同特征在训练集上分类
    X_new = X[:,feature_selected]
    score_linear_svc = []
    score_feature_weight = [] # 记录每次交叉验证的权重
    for train,test in cv:  
        svc_linear.fit(X_new[train],y[train])
        score_linear_svc.append( svc_linear.score(X_new[test],y[test]) ) 
        coef = np.fabs(svc_linear.coef_)
        cc = np.mean(coef,axis=0)
        score_feature_weight.append(cc)
    print np.mean(score_linear_svc)
    
    # 使用前面得到的参数生成最终的分类模型
    svc_linear.fit(X_new,y)
    print svc_linear.score(X_new,y)
    
    # 在验证集上验证已经得到的分类模型的准确率
    X_v = X_valid[:,feature_selected]
    y = y_valid
    scored = svc_linear.score(X_v,y)
    return scored
# 首先划分训练集和验证集，留出一部分数据来验证最终的结果
###########################################################
fold = 2
sss = StratifiedShuffleSplit(y, fold, test_size=0.1, random_state=0)
soced = []
for train, test in sss:
    print("%s %s" % (train, test))
    soced.append( test(X[train],y[train],X[test],y[test],143) )
    
#train_mask = np.array([39,36,37,33,24,10,7,44,32,6,42,25,14,28,9,26,17,0,\
#    13,30,20,41,19,31,8,4,23,18,22,11,3,5,27,2,34,40,1,29,43,16,35,38] ) 
#valid_mask = np.array([12,15,21,45,46])
#
#X_train = X[train_mask]
#y_train = y[train_mask]
#X_valid = X[valid_mask]
#y_valid = y[valid_mask]
#################################################################
#X = X_train
#y = y_train
#X = preprocessing.scale(X) # 标准化
## 设置分类器
#svc_linear =  SVC(C=1,kernel="linear")
#svc_rbf = SVC(C=1,kernel="rbf")
#knn = KNeighborsClassifier(4, weights='uniform')
#lr = LogisticRegression(C=1, penalty='l2', tol=0.0001)
#
#cv = LeavePOut(y.shape[0], p=1)


######################################################################
## 这一部分主要是为了得到最佳的特征选择个数
##Ks = np.linspace(1,1000,20).astype(int)
#Ks = np.array( [140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165] )
#
#linear_ks=[]
#rbf_ks = []
#knn_ks = []
#lr_ks = []
#for i in xrange(Ks.shape[0]):
#    score_linear_svc = []
#    score_rbf_svc = []
#    score_knn_svc = []
#    score_lr_svc = []
#    sk_f = SelectKBest(f_classif,k=Ks[i])
#    for train,test in cv:
#        XX_train = sk_f.fit_transform(X[train],y[train])
#        XX_test = sk_f.transform(X[test])
#        # ----------------------------------------------------------
#        svc_linear.fit(XX_train,y[train])
#        score_linear_svc.append( svc_linear.score(XX_test,y[test]) )
#        # ----------------------------------------------------------
#        svc_rbf.fit(XX_train,y[train])
#        score_rbf_svc.append( svc_rbf.score(XX_test,y[test]) )
#        # ----------------------------------------------------------
#        knn.fit(XX_train,y[train])
#        score_knn_svc.append( knn.score(XX_test,y[test]) )
#        # ----------------------------------------------------------
#        lr.fit(XX_train,y[train])
#        score_lr_svc.append( lr.score(XX_test,y[test]) )
#    final_score_linear = np.mean(score_linear_svc)
#    final_score_rbf = np.mean(score_rbf_svc)
#    final_score_knn = np.mean(score_knn_svc)
#    final_score_lr = np.mean(score_lr_svc)
#    # -------------------------------------
#    linear_ks.append(final_score_linear)
#    rbf_ks.append(final_score_rbf)
#    knn_ks.append(final_score_knn)
#    lr_ks.append(final_score_lr)
#
## 绘制结果
## 弹出窗口显示
##%matplotlib qt
#plt.plot(Ks, linear_ks, 'ro-',label='Linear_SVM' , lw=2)
#plt.plot(Ks, rbf_ks, 'gs-',label='NonLinear_SVM' , lw=2)
#plt.plot(Ks, knn_ks, 'kv--',label='KNN' , lw=2)
#plt.plot(Ks, lr_ks, 'cD-',label='LR' , lw=2)
##plt.xlim([-0.05, 1.05])
##plt.ylim([0.8, 1.05])
#plt.xlabel('Feature Num')
#plt.ylabel('Accuracy')
#plt.title('Feature Num vs Accuracy')
#plt.legend(loc=4)
#plt.show()
###############################################################################
"""
根据选择出来的特征和分类，再做一遍分折交叉验证，得到每折都选择到的共同的特征
"""

# 选出来特征选择 149 个， 分类器选择线性Linear_SVM， 计算特征排序  76.6%
# 143  70%

#cv = LeavePOut(y.shape[0], p=1)
#sk_f = SelectKBest(f_classif,k=143)
#score_linear_svc = []
#feaure_indexs = []
#for train,test in cv:  
#    XX_train = sk_f.fit_transform(X[train],y[train])
#    XX_test = sk_f.transform(X[test])
#    feaure_indexs.append( sk_f.get_support() )
#    svc_linear.fit(XX_train,y[train])##################################################
#    score_linear_svc.append( svc_linear.score(XX_test,y[test]) )   #######################
#
#print(np.mean(score_linear_svc))
#   
#a = np.logical_and(feaure_indexs[0],feaure_indexs[1])
#for i in range(2,len(feaure_indexs)):
#    a = np.logical_and(a,feaure_indexs[i])
#    print np.where(a)[0].shape
## 最后选择出来的在每折交叉验证中都选择的特征   
#feature_selected = np.where(a)[0]
##最后选择出来的共同特征66个
#
## 用选择的共同特征在训练集上分类
#X_new = X[:,feature_selected]
#cv = LeavePOut(y.shape[0], p=1)
#score_linear_svc = []
#score_feature_weight = [] # 记录每次交叉验证的权重
#for train,test in cv:  
#    svc_linear.fit(X_new[train],y[train])
#    score_linear_svc.append( svc_linear.score(X_new[test],y[test]) ) 
#    coef = np.fabs(svc_linear.coef_)
#    cc = np.mean(coef,axis=0)
#    score_feature_weight.append(cc)
#print np.mean(score_linear_svc)
#
## 使用前面得到的参数生成最终的分类模型
#svc_linear.fit(X_new,y)
#print svc_linear.score(X_new,y)
################################################################################
"""
使用选择出来的共同的特征和分类器分类，得到分类器赋给每个特征的权重，这里权重取绝对值，
得到每个脑区的权重，
然后使用F值评估这些共同特征，再给出一个基于F值的排序
将以上三个结果保存成文本和xls两种格式的文件
"""
# 在验证集上验证已经得到的分类模型的准确率
#X_v = X_valid[:,feature_selected]
#y = y_valid
#svc_linear.score(X_v,y)



################################################################################
# 得到并保存实验结果
## 得到与选择出来的特征对应的名称
#names_selected = brain_region_names[:,feature_selected]
#names_selected_list = []
#for i in range(names_selected[0].shape[0]):
#    names_selected_list.append( names_selected[0][i] )
##    
### 得到各个特征在分类的时候所得到的权重，
#score_feature_weight_matrix =  np.array(score_feature_weight)  
#mean_score_feature_weight = np.mean(score_feature_weight_matrix,axis=0)
#
### 根据权重排序
#result_dict = {}
#for i in range(mean_score_feature_weight.shape[0]):
#    result_dict[names_selected_list[i][0]] = mean_score_feature_weight[i]
#feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
#
### 按照各个脑区分得连接 二分之一权重的方式 得到各个脑区的权重，没有的脑区权重为0
#def split_aal_name(strs):
#    s1 = strs.split('->')[0].split('.')[1]
#    s2 = strs.split('->')[1].split('.')[1]
#    return s1,s2
#
#regions_weight = {}    
#for i in range(len(feature_sorted)):
#    key = feature_sorted[i][0]
#    vaule = feature_sorted[i][1]
#    s1,s2 = split_aal_name(key)
#    if regions_weight.has_key(s1):
#        print s1
#        regions_weight[s1] = regions_weight[s1] + 0.5*feature_sorted[i][1]
#    else:
#        regions_weight[s1] = 0.5*feature_sorted[i][1]
#        
#    if regions_weight.has_key(s2):
#        print s2
#        regions_weight[s2] = regions_weight[s2] + 0.5*feature_sorted[i][1]
#    else:
#        regions_weight[s2] = 0.5*feature_sorted[i][1]
#regions_sorted = sorted(regions_weight.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
#
##连接的排序和脑区的排序写入同一个excell 中
#import xlwt
#os.chdir(root)
#workbook = xlwt.Workbook(encoding = 'ascii')
#worksheet = workbook.add_sheet('region_weight_brainnetome')#####################################
#for i in range(len(regions_sorted)):
#    worksheet.write(i, 0, label = regions_sorted[i][0])
#    worksheet.write(i, 1, label = regions_sorted[i][1])
#    
#worksheet = workbook.add_sheet('connection_weight_brainnetome')#################################
#for i in range(len(feature_sorted)):
#    worksheet.write(i, 0, label = feature_sorted[i][0].split('->')[0])
#    worksheet.write(i, 1, label = feature_sorted[i][0].split('->')[1])  
#    worksheet.write(i, 2, label = feature_sorted[i][1])   
#workbook.save(r'paper_result\weight_func_brainnetome.xls') ##############################   
#
##################################################################################
#
## 得到脑区的中心点的坐标信息，写入文件画图用
#import xlrd
#aal_file = r'D:\FMRI_ROOT\YIYU\ROIs\brainnetome\BNA_subregions.xlsx'
#data = xlrd.open_workbook(aal_file)
#table = data.sheets()[1]          #通过索引顺序获取
##table = data.sheet_by_index(0) #通过索引顺序获取
##table = data.sheet_by_name(u'Sheet1')#通过名称获取
#names = []
#coords = []
#import string
#for i in range(1,247):
#    names.append( table.cell(i,1).value )
#    co = table.cell(i,2).value
#    cos = co.split(',')
#    cos_float = [string.atof(x) for x in cos]
#    cos_tuple = tuple(cos_float)
#    coords.append(cos_tuple)
#
#
#na_co_dict = {} # 存放脑区和坐标的对应情况
#for i in range(len(names)):  
#    if na_co_dict.has_key(names[i]):
#        print "error"
#    if not na_co_dict.has_key(names[i]):
#        na_co_dict[names[i]] = coords[i]
#
#
#node_coords=[] 
#node_size = []       
#for i in range(len(regions_sorted)):
#    key = regions_sorted[i][0]
#    value = regions_sorted[i][1]
#    if na_co_dict.has_key(key):
#        node_coords.append( na_co_dict[key] )
#        node_size.append( value )
#
#node_size_end = [x*5 for x in node_size ]     ##################################这里调节节点的大小
##plot_regions_weight(node_coords,node_size_end)
#
#"""
#写入脑区数据，TXT格式
#"""
#str2 = ''   
#for i in range(len(node_coords)):
#    str2 = str2 +  str(node_coords[i][0])+' '+str(node_coords[i][1]) \
#               +' '+str(node_coords[i][2])+' '+str(node_size_end[i]) \
#               +' 1 0.9 0.0 0.0 '+str(regions_sorted[i][0].split(' ')[0])
#    str2 = str2 + '\n'
#
#file_object = open(root+r'\paper_result\regions_MNI_func_brainnetome.txt', 'w')#######################################
#file_object.write(str2)
#file_object.close( )
#
#
## 写入excel, 保存结果
#import xlwt
#os.chdir(root)
#workbook = xlwt.Workbook(encoding = 'ascii')
#worksheet = workbook.add_sheet('plot_region_weight_brainnetome')##########################################
#worksheet.write(0, 0, label = 'label')
#worksheet.write(0, 1, label = 'color')
#worksheet.write(0, 2, label = 'module')
#worksheet.write(0, 3, label = 'size')
#worksheet.write(0, 4, label = 'x')
#worksheet.write(0, 5, label = 'y')
#worksheet.write(0, 6, label = 'z')
#for i in range(len(node_coords)):
#    worksheet.write(i+1, 0, label = str(regions_sorted[i][0].split(' ')[0]) )
#    worksheet.write(i+1, 1, label = '0 1 0')
#    worksheet.write(i+1, 2, label = '1')
#    worksheet.write(i+1, 3, label = (node_size_end[i])  )
#    worksheet.write(i+1, 4, label = (node_coords[i][0]) )
#    worksheet.write(i+1, 5, label = (node_coords[i][1]) )
#    worksheet.write(i+1, 6, label = (node_coords[i][2]) )
#      
#workbook.save(r'paper_result\brainnetome_regions_weight.xls') #########################################
#
#"""
#生成脑区对应的连接信息
#"""
#sorted_region_list = []
#sorted_region_intensity = []
#lens = len(regions_sorted)
#links_aal = np.zeros((lens,lens))
#for i in range(lens):
#   sorted_region_list.append(regions_sorted[i][0])
#   sorted_region_intensity.append(regions_sorted[i][1])
#   
#for i in range(len(feature_sorted)):
#   key = feature_sorted[i][0]
#   value = feature_sorted[i][1]
#   s1,s2 = split_aal_name(key)
#   index1 = sorted_region_list.index(s1)
#   index2 = sorted_region_list.index(s2)
#   links_aal[index1][index2] = value
#   links_aal[index2][index1] = value     
#
## links_aal 写入文件
#strs = ''
#for i in range(lens):
#    for j in range(lens):
#        strs = strs + str(links_aal[i][j]) + ','
#    strs = strs + '\n'
#
#file_object = open(root + r'\paper_result\brainnetome_regions_links.txt', 'w')  ####################
#file_object.write(strs)
#file_object.close( )    


