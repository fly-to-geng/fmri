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

###############################################################################
##################################################################################
"""
定义特征选择函数
"""
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

"""
设置路径，并加载需要的变量
"""
# 需要的数据和生成的结果保存在这里或者其子文件夹下
root = r'D:\FMRI_ROOT\YIYU\CONN\conn_project05\meresult'#####################
save_root = r'D:\FMRI_ROOT\YIYU\Result\7'
data_root = os.path.join(root,'data')
# 特征对应的标签
brain_region_names = r'features_from_fc_aal_first_level_vs_names.mat'###########################
# 特征矩阵，第一列是标签
X_path = r'features_from_fc_aal_first_level.mat'############################################################
y_path = r'y.npy'

# 加载数据转成python格式

features_name = sio.loadmat(os.path.join(data_root,brain_region_names))['brain_map_names']
features_name = [i for i in features_name[0]]
features_name = np.asarray(features_name)
features=sio.loadmat(os.path.join(data_root,X_path))['subjects_features_mat']
y = np.load(os.path.join(data_root,y_path))
###############################################################################
"""
首先做一个单样本T检验，把那些不显著的特征设置为0，保存下来，用于后面的特征选择
"""
from scipy import stats
p = 0.05  # 去掉显著性大于0.001的连接#########################################
hc = features[0:26,:]
mdd = features[26:,:]
pvalues1 = stats.ttest_1samp(hc,0.0,axis=0)
p1 = pvalues1[1]
remain_mask1 = p1<p  #要删除的连接
deleted_mask1 = p1>=p # 要删除的连接
hc_t = hc[:,remain_mask1]
print("remain feature: ", np.sum(remain_mask1) )
print ("deleted features: ", np.sum(deleted_mask1))
print ("total features: ", np.sum(remain_mask1) + np.sum(deleted_mask1) )

print "==========================="
pvalues2 = stats.ttest_1samp(mdd,0.0,axis=0)
p2 = pvalues2[1]
remain_mask2 = p2<p 
deleted_mask2 = p2>=p 
mdd_t = mdd[:,remain_mask2]# 删除的连接置0
print("remain feature: ", np.sum(remain_mask2) )
print ("deleted features: ", np.sum(deleted_mask2))
print ("total features: ", np.sum(remain_mask2) + np.sum(deleted_mask2) )

print "=============================="
end_mask = np.logical_or(remain_mask1,remain_mask2)
print ("end features num: ",np.sum(end_mask) )

# 做完T检验之后获得的特征
X = features[:,end_mask]


"""
使用F值选择特征，找到分类准确率最高的特征个数和分类器
"""
X = X
X = preprocessing.scale(X) # 标准化
# 设置分类器
svc_linear =  SVC(C=1,kernel="linear")
svc_rbf = SVC(C=1,kernel="rbf")
knn = KNeighborsClassifier(6, weights='uniform')
lr = LogisticRegression(C=1, penalty='l2', tol=0.0001)

cv = LeavePOut(y.shape[0], p=1)
#Ks = np.linspace(10,1000,20).astype(int)
Ks = np.linspace(200,250,21).astype(int)
#Ks = np.array( [194,195,196,197,198,199,200,201,202,203,204,205,206] )
#Ks = np.array( [144,145,146,147,148,149,150,151,152,153,154,155,156] )

from time import time
linear_ks=[]
rbf_ks = []
knn_ks = []
lr_ks = []
#for i in xrange(Ks.shape[0]):
#    print("=======",i)
#    start = time()
#    score_linear_svc = []
#    score_rbf_svc = []
#    score_knn_svc = []
#    score_lr_svc = []
#    sk_f = SelectKBest(my_advance,k=Ks[i])
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
#    print time() - start
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

# 选出来特征选择 227个， 分类器选择线性linear_svm， 计算特征排序  准确率87.23%

cv = LeavePOut(y.shape[0], p=1)
sk_f = SelectKBest(my_advance,k=222)
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
print(np.mean(score_linear_svc))
acc_brainnetome_class = np.mean(score_linear_svc)

# 准确率.89.36%
   
#a = np.logical_and(feaure_indexs[0],feaure_indexs[1])
#for i in range(2,len(feaure_indexs)):
#    a = np.logical_and(a,feaure_indexs[i])
#    print np.where(a)[0].shape
## 最后选择出来的在每折交叉验证中都选择的特征   
#feature_selected = np.where(a)[0]
a = np.sum(np.asarray(feaure_indexs) ,axis=0) == X.shape[0]

score_feature_weight[:,~a] = 0
feature_weight_svm = np.mean(score_feature_weight,axis=0)
feature_selected = np.where(a)[0]
print "================="
print("common features num:",feature_selected.shape)
# 共同特征  150个

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
#p = (np.sum(random_score_list>acc_brainnetome_class) + 1 ) / float(k+1)
#print "分类显著性："
#print p

#分类显著性：
#0.000999000999001
################################################################################
"""
使用选择出来的共同的特征和分类器分类，得到分类器赋给每个特征的权重，这里权重取绝对值，
得到每个脑区的权重，
然后使用F值评估这些共同特征，再给出一个基于F值的排序
将以上三个结果保存成文本和xls两种格式的文件
"""
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
#使用选择出来的97个共同特征，分类的准确率达到了93.62%

## 得到与选择出来的特征对应的名称
names_selected = features_name[feature_selected,:]
score_feature_weight_matrix =  feature_weight_svm[feature_selected]
max_weight = np.max(score_feature_weight_matrix)

## 根据权重排序
result_dict = {}
for i in range(score_feature_weight_matrix.shape[0]):
    result_dict[names_selected[i][0]] = score_feature_weight_matrix[i]
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)

## 按照各个脑区分得连接 二分之一权重的方式 得到各个脑区的权重，没有的脑区权重为0
def split_aal_name(strs):
    s1 = strs.split('->')[0].split('.')[1]
    s2 = strs.split('->')[1].split('.')[1]
    return s1,s2
################################################################
"""
脑区权重的获得方式一
"""
regions_weight = {}    
for i in range(len(feature_sorted)):
    key = feature_sorted[i][0]
    vaule = feature_sorted[i][1]
    s1,s2 = split_aal_name(key)
    if regions_weight.has_key(s1):
        regions_weight[s1] = regions_weight[s1] + 0.5*feature_sorted[i][1]
    else:
        regions_weight[s1] = 0.5*feature_sorted[i][1]
        
    if regions_weight.has_key(s2):
        regions_weight[s2] = regions_weight[s2] + 0.5*feature_sorted[i][1]
    else:
        regions_weight[s2] = 0.5*feature_sorted[i][1]
regions_sorted = sorted(regions_weight.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)

"""
脑区权重的获得方式二，脑区在选择的特征中出现的次数。
"""
regions_weight2 = {}  
for i in range(len(feature_sorted)):
    key = feature_sorted[i][0]
    s1,s2 = split_aal_name(key)
    if regions_weight2.has_key(s1):
        regions_weight2[s1] = regions_weight2[s1]+1
    else:
        regions_weight2[s1] = 1
    if regions_weight2.has_key(s2):
        regions_weight2[s2] = regions_weight2[s2]+1
    else:
        regions_weight2[s2] = 1
check = np.sum(regions_weight2.values()) == (len(feature_sorted)*2) 
print("Is regions_weight2 true?",check)
regions_sorted2 = sorted(regions_weight2.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
#连接的排序和脑区的排序写入同一个excell 中
import xlwt
os.chdir(save_root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('region_weight_brainnetome')#####################################
for i in range(len(regions_sorted)):
    worksheet.write(i, 0, label = regions_sorted[i][0])
    worksheet.write(i, 1, label = regions_sorted[i][1])
    
    
worksheet = workbook.add_sheet('region_weight2_brainnetome')#####################################
for i in range(len(regions_sorted2)):
    worksheet.write(i, 0, label = regions_sorted2[i][0])
    worksheet.write(i, 1, label = regions_sorted2[i][1])
    
    
worksheet = workbook.add_sheet('connection_weight_brainnetome')#################################
for i in range(len(feature_sorted)):
    worksheet.write(i, 0, label = feature_sorted[i][0].split('->')[0])
    worksheet.write(i, 1, label = feature_sorted[i][0].split('->')[1])  
    worksheet.write(i, 2, label = feature_sorted[i][1])   
workbook.save(r'weight_func_brainnetome.xls') ##############################   

#################################################################################

# 得到脑区的中心点的坐标信息，写入文件画图用
import xlrd
brainnetome_file = r'D:\FMRI_ROOT\YIYU\ROIs\brainnetome_x\x_subregions.xlsx'
data = xlrd.open_workbook(brainnetome_file)
table = data.sheets()[1]          #通过索引顺序获取
#table = data.sheet_by_index(0) #通过索引顺序获取
#table = data.sheet_by_name(u'Sheet1')#通过名称获取
names = []
coords = []
import string
for i in range(1,273):
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

##################################################################
node_coords=[] 
node_size = []       
for i in range(len(regions_sorted)):
    key = regions_sorted[i][0]
    value = (regions_sorted[i][1] /max_weight ) * 8
    if na_co_dict.has_key(key):
        node_coords.append( na_co_dict[key] )
        node_size.append( value )
    else:
        print "error==================error"
        print key
#####################################################
node_coords2=[] 
node_size2 = []
for i in range(len(regions_sorted2)):
    key = regions_sorted2[i][0]
    value = regions_sorted2[i][1]
    if na_co_dict.has_key(key):
        node_coords2.append( na_co_dict[key] )
        node_size2.append( value )
    else:
        print "error==================error"
        print key
#node_size_end = [x*100 for x in node_size ]     ##################################这里调节节点的大小
#plot_regions_weight(node_coords,node_size_end)

"""
写入脑区数据，TXT格式  for 中科院画图软件
"""
#str2 = ''   
#for i in range(len(node_coords)):
#    str2 = str2 +  str(node_coords[i][0])+' '+str(node_coords[i][1]) \
#               +' '+str(node_coords[i][2])+' '+str(node_size[i]) \
#               +' 1 0.9 0.0 0.0 '+str(regions_sorted[i][0].split(' ')[0])
#    str2 = str2 + '\n'
#
#file_object = open(os.path.join(save_root,r'regions_func_brainnetome.txt'), 'w')#######################################
#file_object.write(str2)
#file_object.close( )

"""
写入脑区数据，TXT格式  for   brainnetviewer
"""
str2 = ''   
for i in range(len(node_coords)):
    str2 = str2 +  str(node_coords[i][0])+' '+str(node_coords[i][1]) \
               +' '+str(node_coords[i][2])+' 1 '+str(node_size[i])+' '\
               +str(regions_sorted[i][0].split(' ')[0])
    str2 = str2 + '\n'

file_object = open(os.path.join(save_root,r'regions_func_brainnetome.node'), 'w')#######################################
file_object.write(str2)
file_object.close( )

"""
写入脑区数据2，TXT格式  for   brainnetviewer
"""
str2 = ''   
for i in range(len(node_coords2)):
    str2 = str2 +  str(node_coords2[i][0])+' '+str(node_coords2[i][1]) \
               +' '+str(node_coords2[i][2])+' 1 '+str(node_size2[i])+' '\
               +str(regions_sorted2[i][0].split(' ')[0])
    str2 = str2 + '\n'

file_object = open(os.path.join(save_root,r'regions2_func_brainnetome.node'), 'w')#######################################
file_object.write(str2)
file_object.close( )


# 写入excel, 保存结果
#import xlwt
#os.chdir(save_root)
#workbook = xlwt.Workbook(encoding = 'ascii')
#worksheet = workbook.add_sheet('plot_region_weigh_brainnetome')##########################################
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
#    worksheet.write(i+1, 3, label = (node_size[i])  )
#    worksheet.write(i+1, 4, label = (node_coords[i][0]) )
#    worksheet.write(i+1, 5, label = (node_coords[i][1]) )
#    worksheet.write(i+1, 6, label = (node_coords[i][2]) )
#      
#workbook.save(r'brainnetome_selected_regions.xls') #########################################

"""
生成脑区对应的连接信息
"""
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
#file_object = open(os.path.join(save_root,r'brainnetome_regions_links.txt'), 'w')  ####################
#file_object.write(strs)
#file_object.close( )    

"""
生成脑区对应的连接信息2
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
        strs = strs + str(links_aal[i][j]) + '    '
    strs = strs + '\n'

file_object = open(os.path.join(save_root,r'brainnetome_regions_links.edge'), 'w')  ####################
file_object.write(strs)
file_object.close( ) 


