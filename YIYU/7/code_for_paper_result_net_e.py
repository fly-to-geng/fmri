# -*- coding: utf-8 -*-
"""
Created on Fri Jan 13 23:33:11 2017

@author: FF120

为论文的result部分生成结果的代码
for  三个网络
"""
##############################################################################
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
import os
import scipy.io as sio
import numpy as np
##############################################################################
"""
定义路径和加载数据
"""
root = r'D:\FMRI_ROOT\YIYU\DCM'
data_root = os.path.join(root,'data')
save_root = os.path.join(root,'class_result')

# 有效连接特征
features = r'features_vs_labels_from_DCM_DMN_DAN_SN.mat'
features_name = r'features_vs_labels_from_DCM_DMN_DAN_SN_vs_names.mat'
features = sio.loadmat(os.path.join(data_root,features))['data']
features_name = sio.loadmat(os.path.join(data_root,features_name))['effective_feature_names']
features_name = [i for i in features_name[0]]
features_name = np.asarray(features_name)
#######################################################################
def my_advance(X,y):   
    y_unique = np.unique(y)
    hc_mask = y==y_unique[0]
    mdd_mask = y==y_unique[1]
    hc_num = np.sum(hc_mask)
    mdd_num = np.sum(mdd_mask)
    sums = ( hc_num * mdd_num  )
    pairs = []
    # 1. 计算nc nd
    for i in range(hc_num):
        for j in range(hc_num,hc_num+mdd_num):
            vec = X[i,:] - X[j,:]
            pairs.append(vec)
    
    pairs_matrix = np.asarray(pairs)
    nc_vector = np.sum(pairs_matrix>0,axis=0)
    nd_vector = np.sum(pairs_matrix<0,axis=0)
    features_weight=( (nc_vector-nd_vector)/ float(sums) )
    
    f= np.asarray(np.fabs(features_weight)).ravel() 
    return f,f 
    
######################################################################
# 开始数据处理
X = features[:,1:]
y = features[:,0].astype(int)
X = preprocessing.scale(X) # 标准化
# 设置分类器
svc_linear =  SVC(C=1,kernel="linear")
svc_rbf = SVC(C=1,kernel="rbf")
knn = KNeighborsClassifier(4, weights='uniform')
lr = LogisticRegression(C=1, penalty='l2', tol=0.0001)

from sklearn.cross_validation import LeavePOut   
cv = LeavePOut(y.shape[0], p=1)
Ks = np.linspace(1,41,41).astype(int)

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
#plt.ylim([0.3, 1.05])
plt.xlabel('Feature Num')
plt.ylabel('Accuracy')
plt.title('Feature Num vs Accuracy')
plt.legend(loc=4)
plt.show()

# 选出来特征选择 18 个， 分类器选择线性linear_svm， 计算特征排序
# ==========================================================================
svc_linear =  SVC(C=1,kernel="linear")
cv = LeavePOut(y.shape[0], p=1)
sk_f = SelectKBest(f_classif,k=18)
score_linear_svc = []
feaure_indexs = []
score_feature_weight = np.zeros((len(cv),X.shape[1]))

for i,(train,test) in enumerate(cv):  
    XX_train = sk_f.fit_transform(X[train],y[train])
    XX_test = sk_f.transform(X[test])
    feaure_indexs.append( sk_f.get_support() )
    svc_linear.fit(XX_train,y[train])
    score_linear_svc.append( svc_linear.score(XX_test,y[test]) )   
    coef = np.fabs(svc_linear.coef_)
    cc = np.mean(coef,axis=0)
    score_feature_weight[i,sk_f.get_support()] = cc
net_e_acc = np.mean(score_linear_svc)  
print net_e_acc 
############################################################################## 
"""
置换检验测试，验证分类器的分类准确率是否在随机水平
"""
#1. 随机打乱标签
#k = 1000 #置换次数
#def random_class(X,y,cv):
#    score_linear_svc_random=[]
#    for train,test in cv:  
#        y_random = np.random.permutation(y[train])
#        XX_train = sk_f.fit_transform(X[train],y_random)
#        XX_test = sk_f.transform(X[test])
#        svc_linear.fit(XX_train,y_random)
#        score_linear_svc_random.append( svc_linear.score(XX_test,y[test]) )
#    return np.mean(score_linear_svc_random)
#    
#random_score_list=[]
#for i in range(k):
#    random_score_list.append( random_class(X,y,cv) )
#
##将运行时间长的数据保存下来，下次就不用再运行
#os.chdir(save_root) 
#np.save('random_class_acc_1000',np.asarray(random_score_list))   
#p = (np.sum(random_score_list>net_e_acc) + 1 ) / float(k+1)
#print "分类显著性："
#print p

#分类显著性：
#0.000999000999001

##############################################################################
a = np.logical_and(feaure_indexs[0],feaure_indexs[1])
for i in range(2,len(feaure_indexs)):
    a = np.logical_and(a,feaure_indexs[i])
    print np.where(a)[0].shape
# 最后选择出来的在每折交叉验证中都选择的特征   
score_feature_weight[:,~a] = 0
feature_weight_svm = np.mean(score_feature_weight,axis=0)
feature_selected = np.where(a)[0]

# ===================================================================
# 用最后选择的特征做一个分类，看准确率比选择之前是否有所提高
# 结果是所有的准确率都变成了1
#X_new = X[:,feature_selected]
#svc_linear =  SVC(C=1,kernel="linear")
#cv = LeavePOut(y.shape[0], p=1)
#score_linear_svc = []
#score_feature_weight = [] # 记录每次交叉验证的权重
#for train,test in cv:  
#    svc_linear.fit(X_new[train],y[train])
#    score_linear_svc.append( svc_linear.score(X_new[test],y[test]) ) 
#    score_feature_weight.append(svc_linear.coef_.reshape(-1,))
#print np.mean(score_linear_svc)

# 得到与选择出来的特征对应的名称
names_selected = features_name[feature_selected,:]

    
## 得到各个特征在分类的时候所得到的权重，
score_feature_weight_matrix =  feature_weight_svm[feature_selected]
max_weight = np.max(score_feature_weight_matrix)
# 根据权重排序
result_dict = {}
for i in range(score_feature_weight_matrix.shape[0]):
    result_dict[names_selected[i][0]] = score_feature_weight_matrix[i]
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)

# 按照各个脑区分得连接 二分之一权重的方式 得到各个脑区的权重，没有的脑区权重为0
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
os.chdir(save_root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('region_weight_net_e')
for i in range(len(regions_sorted)):
    worksheet.write(i, 0, label = regions_sorted[i][0])
    worksheet.write(i, 1, label = regions_sorted[i][1])
    
worksheet = workbook.add_sheet('connection_weight_net_e')
for i in range(len(feature_sorted)):
    worksheet.write(i, 0, label = feature_sorted[i][0].split('->')[0])
    worksheet.write(i, 1, label = feature_sorted[i][0].split('->')[1])  
    worksheet.write(i, 2, label = feature_sorted[i][1])   
workbook.save(r'classi_weight_e_net.xls')   



"""
选择排名靠前的若干个特征，在以大脑为背景的图像中显示出来

"""

"""
选择排名靠前的若干个特征，在以大脑为背景的图像中显示出来

"""
import xlrd
net_file = r'D:\FMRI_ROOT\YIYU\ROIs\network\network.xlsx'
data = xlrd.open_workbook(net_file)
table = data.sheets()[0] 

names = []
coords = []
import string
for i in range(2,13):
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

# 获得regions_sorted的最大值
region_sorted_list=[]
for i in range(len(regions_sorted)):
    region_sorted_list.append(regions_sorted[i][1])
max_weight = max(region_sorted_list)
node_coords=[] 
node_size = []       
for i in range(len(regions_sorted)):
    key = regions_sorted[i][0]
    value = (regions_sorted[i][1] / max_weight) * 8
    if na_co_dict.has_key(key):
        node_coords.append( na_co_dict[key] )
        node_size.append( value )

#node_size_end = [x*5 for x in node_size ] 
"""
写入脑区数据，TXT格式
"""
str2 = ''   
for i in range(len(node_coords)):
    str2 = str2 +  str(node_coords[i][0])+' '+str(node_coords[i][1]) \
               +' '+str(node_coords[i][2])+' '+str(node_size[i]) \
               +' 1 0.9 0.0 0.0 '+str(regions_sorted[i][0].split(' ')[0])
    str2 = str2 + '\n'

file_object = open(os.path.join(save_root,r'regions_func_net_e.txt'), 'w')#######################################
file_object.write(str2)
file_object.close( )

# 写入excel, 保存结果
import xlwt
os.chdir(save_root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('plot_region_weigh_net_e')##########################################
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
    worksheet.write(i+1, 3, label = (node_size[i])  )
    worksheet.write(i+1, 4, label = (node_coords[i][0]) )
    worksheet.write(i+1, 5, label = (node_coords[i][1]) )
    worksheet.write(i+1, 6, label = (node_coords[i][2]) )
      
workbook.save(r'net_e_selected_regions.xls') #########################################

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

file_object = open(os.path.join(save_root,r'nef_e_regions_links.txt'), 'w')  ####################
file_object.write(strs)
file_object.close( ) 
    
