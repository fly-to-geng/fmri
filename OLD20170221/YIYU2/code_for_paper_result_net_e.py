# -*- coding: utf-8 -*-
"""
Created on Fri Jan 13 23:33:11 2017

@author: FF120

为论文的result部分生成结果的代码
for  三个网络
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

"""
加载需要的数据
功能连接特征 和  有效连接特征
"""
import os
import scipy.io as sio
root = r'D:\FMRI_ROOT\YIYU\MVPA'
# 功能连接特征
X_path_f = r'features_from_fc_DMN_DAN_SN_second_level.mat'
y_path = r'features_from_fc_brainnetome_second_level_vs_labels.npy'
names_path_f = r'features_from_fc_DMN_DAN_SN_second_level_vs_names.mat'
X_f = sio.loadmat(os.path.join(root,X_path_f))
X_f = X_f['subjects_features_mat']
y = np.load(os.path.join(root,y_path))
names_f = sio.loadmat(os.path.join(root,names_path_f))
names_f = names_f['brain_map_names']
names_f = [x for x in names_f[0]]

# 有效连接特征
X_path_e = r'features_vs_labels_from_DCM_DMN_DAN_SN.mat'
names_path_e = r'features_vs_labels_from_DCM_DMN_DAN_SN_vs_names'
X_e = sio.loadmat(os.path.join(root,X_path_e))
X_e = X_e['data']
X_e = X_e[:,1:]
names_e = sio.loadmat(os.path.join(root,names_path_e))
names_e = names_e['effective_feature_names']
names_e = [x for x in names_e[0]]

#######################################################################
# 开始数据处理
X = preprocessing.scale(X_e) # 标准化
# 设置分类器
svc_linear =  SVC(C=1,kernel="linear")
svc_rbf = SVC(C=1,kernel="rbf")
knn = KNeighborsClassifier(4, weights='uniform')
lr = LogisticRegression(C=1, penalty='l2', tol=0.0001)

from sklearn.cross_validation import LeavePOut   
cv = LeavePOut(y.shape[0], p=1)
Ks = np.linspace(1,41,41).astype(int)
#Ks = np.array( [65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80] )
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
#plt.ylim([0.3, 1.05])
plt.xlabel('Feature Num')
plt.ylabel('Accuracy')
plt.title('Feature Num vs Accuracy')
plt.legend(loc=4)
plt.show()

# 选出来特征选择 10 个， 分类器选择线性LR， 计算特征排序
# ==========================================================================
svc_linear =  SVC(C=1,kernel="linear")
cv = LeavePOut(y.shape[0], p=1)
sk_f = SelectKBest(f_classif,k=10)
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

# 得到与选择出来的特征对应的名称
names = np.array(names_e).T
names_selected = names[:,feature_selected]

    
# 得到各个特征在分类的时候所得到的权重，使用线性SVM
score_feature_weight_matrix =  np.array(score_feature_weight)  
mean_score_feature_weight = np.mean(score_feature_weight_matrix,axis=0)

# 根据权重排序
result_dict = {}
for i in range(mean_score_feature_weight.shape[0]):
    result_dict[names_selected[0][i]] = mean_score_feature_weight[i]
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)

# 按照各个脑区分得连接 二分之一权重的方式 得到各个脑区的权重，没有的脑区权重为0
def split_network_name(strs):
    s1 = strs.split('->')[0]
    s2 = strs.split('->')[1]
    return s1,s2

regions_weight = {}    
for i in range(len(feature_sorted)):
    key = feature_sorted[i][0]
    vaule = feature_sorted[i][1]
    s1,s2 = split_network_name(key)
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
worksheet = workbook.add_sheet('region_weight_network_effective')
for i in range(len(regions_sorted)):
    worksheet.write(i, 0, label = regions_sorted[i][0])
    worksheet.write(i, 1, label = regions_sorted[i][1])
    
worksheet = workbook.add_sheet('connection_weight_network_e')
for i in range(len(feature_sorted)):
    worksheet.write(i, 0, label = feature_sorted[i][0].split('->')[0])
    worksheet.write(i, 1, label = feature_sorted[i][0].split('->')[1])  
    worksheet.write(i, 2, label = feature_sorted[i][1])   
workbook.save(r'Paper\result\MDD-HD-net-effect.xls')   



"""
选择排名靠前的若干个特征，在以大脑为背景的图像中显示出来

"""

#  

# 需要下面三个变量画出脑区权重图像
# node_coords 排序好的脑区中心坐标
# node_size 与坐标对应的脑区的大小
# node_color 每个节点对应的颜色
# 注意这三个变量内的元素都是对应的，所以变量内的元素的顺序不能乱，
# 所以不能使用无序容器，例如dict来存储，
node_coords = [(26.44, 52.0, 8.6),(-25.0, 52.78, 7.75),(37.5, 2.65, -0.17),(15.08, 17.52, 57.58),(-14.56, 17.96, 56.57)]
node_size = [200,100,100,80,150]
node_color = []

def plot_regions_weight(node_coords,node_size):
    from nilearn import plotting
    import numpy as np
    n = len( node_coords )
    adjacency_matrix = np.zeros((n,n))
    display = plotting.plot_connectome(adjacency_matrix,node_coords,node_color='auto',node_size=node_size,colorbar=False)
    display.savefig('sbc_z.pdf')
    
# 得到AAL脑区和对应的脑区坐标
import xlrd
aal_file = r'D:\FMRI_ROOT\YIYU\ROIs\AAL\AAL.xlsx'
data = xlrd.open_workbook(aal_file)
table = data.sheets()[0]          #通过索引顺序获取
#table = data.sheet_by_index(0) #通过索引顺序获取
#table = data.sheet_by_name(u'Sheet1')#通过名称获取
names = []
coords = []
import string
for i in range(1,133):
    names.append( table.cell(i,1).value )
    co = table.cell(i,2).value
    cos = co.split(',')
    cos_float = [string.atof(x) for x in cos]
    cos_tuple = tuple(cos_float)
    coords.append(cos_tuple)

na_co_dict = {}
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

node_size_end = [x*1000 for x in node_size ]     
plot_regions_weight(node_coords,node_size_end)


"""
把选择出来的共同特征转换成行向量
"""
import scipy.io as sio
import os
savepath = r'D:\FMRI_ROOT\YIYU\MVPA'
os.chdir(savepath)
a = np.zeros((1,41))
a[0,feature_selected] = mean_score_feature_weight
sio.savemat('selected_feature_net_f',{'selected_feature':a})