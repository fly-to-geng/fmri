# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 14:57:48 2017

@author: FF120
"""
##############################################################################
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
##############################################################################
"""
加载数据
"""
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
##############################################################################
"""
划分数据集
"""
fold = 100
sss = StratifiedShuffleSplit(y, fold, test_size=0.025, random_state=0)
aa = []
for train, test in sss:
    print("%s %s" % (train, test))
    aa.append( test_svm(X,y,train,test) )

s = 0
for i in range(len(aa)):
       s = s + aa[i][0] 
       
print s/len(aa)

qq = np.logical_and(aa[0][1],aa[1][1])
for i in range(2,len(aa)):
    a = np.logical_and(qq,aa[i][1])
    print np.where(a)[0].shape
# 最后选择出来的在每折交叉验证中都选择的特征   
feature_selected_qq = np.where(a)[0]

names_selected = brain_region_names[:,feature_selected_qq]
names_selected_list = []
for i in range(names_selected[0].shape[0]):
    names_selected_list.append( names_selected[0][i] )
    
X_new = X[:,feature_selected_qq]
cv = LeavePOut(y.shape[0], p=1)
svc_linear =  SVC(C=1,kernel="linear")
score_linear_svc = []
score_feature_weight = [] # 记录每次交叉验证的权重
for train,test in cv:  
    svc_linear.fit(X_new[train],y[train])
    score_linear_svc.append( svc_linear.score(X_new[test],y[test]) ) 
    coef = np.fabs(svc_linear.coef_)
    cc = np.mean(coef,axis=0)
    score_feature_weight.append(cc)
print np.mean(score_linear_svc)


### 得到各个特征在分类的时候所得到的权重，
score_feature_weight_matrix =  np.array(score_feature_weight)  
mean_score_feature_weight = np.mean(score_feature_weight_matrix,axis=0)

## 根据权重排序
result_dict = {}
for i in range(mean_score_feature_weight.shape[0]):
    result_dict[names_selected_list[i][0]] = mean_score_feature_weight[i]
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)

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

#连接的排序和脑区的排序写入同一个excell 中
import xlwt
os.chdir(root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('region_weight_brainnetome')#####################################
for i in range(len(regions_sorted)):
    worksheet.write(i, 0, label = regions_sorted[i][0])
    worksheet.write(i, 1, label = regions_sorted[i][1])
    
worksheet = workbook.add_sheet('connection_weight_brainnetome')#################################
for i in range(len(feature_sorted)):
    worksheet.write(i, 0, label = feature_sorted[i][0].split('->')[0])
    worksheet.write(i, 1, label = feature_sorted[i][0].split('->')[1])  
    worksheet.write(i, 2, label = feature_sorted[i][1])   
workbook.save(r'paper_result\weight_func_brainnetome_COM.xls') ##############################   

#################################################################################

# 得到脑区的中心点的坐标信息，写入文件画图用
import xlrd
aal_file = r'D:\FMRI_ROOT\YIYU\ROIs\brainnetome\BNA_subregions.xlsx'
data = xlrd.open_workbook(aal_file)
table = data.sheets()[1]          #通过索引顺序获取
#table = data.sheet_by_index(0) #通过索引顺序获取
#table = data.sheet_by_name(u'Sheet1')#通过名称获取
names = []
coords = []
import string
for i in range(1,247):
    names.append( table.cell(i,1).value )
    co = table.cell(i,2).value
    cos = co.split(',')
    cos_float = [string.atof(x) for x in cos]
    cos_tuple = tuple(cos_float)
    coords.append(cos_tuple)


na_co_dict = {} # 存放脑区和坐标的对应情况
for i in range(len(names)):  
    if na_co_dict.has_key(names[i]):
        print "error"
    if not na_co_dict.has_key(names[i]):
        na_co_dict[names[i]] = coords[i]


node_coords=[] 
node_size = []       
for i in range(len(regions_sorted)):
    key = regions_sorted[i][0]
    value = regions_sorted[i][1]
    if na_co_dict.has_key(key):
        node_coords.append( na_co_dict[key] )
        node_size.append( value )

node_size_end = [x*5 for x in node_size ]     ##################################这里调节节点的大小
#plot_regions_weight(node_coords,node_size_end)

"""
写入脑区数据，TXT格式
"""
str2 = ''   
for i in range(len(node_coords)):
    str2 = str2 +  str(node_coords[i][0])+' '+str(node_coords[i][1]) \
               +' '+str(node_coords[i][2])+' '+str(node_size_end[i]) \
               +' 1 0.9 0.0 0.0 '+str(regions_sorted[i][0].split(' ')[0])
    str2 = str2 + '\n'

file_object = open(root+r'\paper_result\regions_MNI_func_brainnetome_COM.txt', 'w')#######################################
file_object.write(str2)
file_object.close( )


# 写入excel, 保存结果
import xlwt
os.chdir(root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('plot_region_weight_brainnetome')##########################################
worksheet.write(0, 0, label = 'label')
worksheet.write(0, 1, label = 'color')
worksheet.write(0, 2, label = 'module')
worksheet.write(0, 3, label = 'size')
worksheet.write(0, 4, label = 'x')
worksheet.write(0, 5, label = 'y')
worksheet.write(0, 6, label = 'z')
for i in range(len(node_coords)):
    worksheet.write(i+1, 0, label = str(regions_sorted[i][0].split(' ')[0]) )
    worksheet.write(i+1, 1, label = '0 1 0')
    worksheet.write(i+1, 2, label = '1')
    worksheet.write(i+1, 3, label = (node_size_end[i])  )
    worksheet.write(i+1, 4, label = (node_coords[i][0]) )
    worksheet.write(i+1, 5, label = (node_coords[i][1]) )
    worksheet.write(i+1, 6, label = (node_coords[i][2]) )
      
workbook.save(r'paper_result\brainnetome_regions_weight_COM.xls') #########################################

"""
生成脑区对应的连接信息
"""
sorted_region_list = []
sorted_region_intensity = []
lens = len(regions_sorted)
links_aal = np.zeros((lens,lens))
for i in range(lens):
   sorted_region_list.append(regions_sorted[i][0])
   sorted_region_intensity.append(regions_sorted[i][1])
   
for i in range(len(feature_sorted)):
   key = feature_sorted[i][0]
   value = feature_sorted[i][1]
   s1,s2 = split_aal_name(key)
   index1 = sorted_region_list.index(s1)
   index2 = sorted_region_list.index(s2)
   links_aal[index1][index2] = value
   links_aal[index2][index1] = value     

# links_aal 写入文件
strs = ''
for i in range(lens):
    for j in range(lens):
        strs = strs + str(links_aal[i][j]) + ','
    strs = strs + '\n'

file_object = open(root + r'\paper_result\brainnetome_regions_links_COM.txt', 'w')  ####################
file_object.write(strs)
file_object.close( )    


##############################################################################
"""
循环体内
输入： train_index, test_index
输出： 验证准确率和最终选择的特征的索引数组
"""
def test_svm(X_input,y_input,train_index,test_index):
    X_valid = X_input[test_index]
    y_valid = y_input[test_index]
    
    X = X_input[train_index]
    y = y_input[train_index]
    
    X = preprocessing.scale(X) # 标准化
    # 设置分类器
    svc_linear =  SVC(C=1,kernel="linear")
    #svc_rbf = SVC(C=1,kernel="rbf")
    #knn = KNeighborsClassifier(4, weights='uniform')
    #lr = LogisticRegression(C=1, penalty='l2', tol=0.0001)
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
    X_valid = preprocessing.scale(X_valid) # 标准化
    X_v = X_valid[:,feature_selected]
    y = y_valid
    scored = svc_linear.score(X_v,y)
    print "======================="
    print scored
    return scored,a