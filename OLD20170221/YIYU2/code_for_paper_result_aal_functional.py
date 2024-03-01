# -*- coding: utf-8 -*-
"""
Created on Fri Jan 13 23:33:11 2017

@author: FF120

为论文的result部分生成结果的代码
"""
import os
import scipy.io as sio
import numpy as np

root = r'D:\FMRI_ROOT\YIYU\MVPA2'
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

brain_region_names_path = r'D:\FMRI_ROOT\YIYU\MVPA2\features_from_fc_aal_first_level_vs_names.mat'
y_path = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_brainnetome_second_level_vs_labels.npy'
X_path = r'D:\FMRI_ROOT\YIYU\MVPA2\features_from_fc_aal_first_level.mat'

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
#Ks = np.linspace(200,400,10).astype(int)
Ks = np.array( [194,195,196,197,198,199,200,201,202,203,204,205,206] )
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
plt.legend(loc=4)
plt.show()

# 选出来特征选择 68 个， 分类器选择线性SVC， 计算特征排序
# 选出来特征选择 195 个， 分类器选择线性SVC， 计算特征排序
# ==========================================================================
svc_linear =  SVC(C=1,kernel="linear")
cv = LeavePOut(y.shape[0], p=1)
sk_f = SelectKBest(f_classif,k=195)
score_linear_svc = []
feaure_indexs = []
for train,test in cv:  
    XX_train = sk_f.fit_transform(X[train],y[train])
    XX_test = sk_f.transform(X[test])
    feaure_indexs.append( sk_f.get_support() )
    lr.fit(XX_train,y[train])
    score_linear_svc.append( lr.score(XX_test,y[test]) )   

print np.mean(score_linear_svc)    
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
    lr.fit(X_new[train],y[train])
    score_linear_svc.append( lr.score(X_new[test],y[test]) ) 
    score_feature_weight.append(lr.coef_.reshape(-1,))
print np.mean(score_linear_svc)

"""
用选择出来的一致的特征分类，看结果
""""
#svc = lr
## 以ROC曲线的形式显示分类结果
#from sklearn.metrics import roc_curve, auc
#from scipy import interp
#import matplotlib.pyplot as plt
#mean_tpr = 0.0
#mean_fpr = np.linspace(0, 1, 100)
#all_tpr = []
#for i, (train, test) in enumerate(cv):
#    probas_ = svc.fit(X[train], y[train]).predict_proba(X[test])
#    # Compute ROC curve and area the curve
#    fpr, tpr, thresholds = roc_curve(y[test], probas_[:, 1],pos_label=1)
#    mean_tpr += interp(mean_fpr, fpr, tpr)
#    mean_tpr[0] = 0.0
#    roc_auc = auc(fpr, tpr)
#    plt.plot(fpr, tpr, lw=1, label='ROC fold %d (area = %0.2f)' % (i, roc_auc))
#
#plt.plot([0, 1], [0, 1], '--', color=(0.6, 0.6, 0.6), label='Luck')
#mean_tpr /= len(cv)
#mean_tpr[-1] = 1.0
#mean_auc = auc(mean_fpr, mean_tpr)
#plt.plot(mean_fpr, mean_tpr, 'k--',
#label='Mean ROC (area = %0.2f)' % mean_auc, lw=2)
#plt.xlim([-0.05, 1.05])
#plt.ylim([-0.05, 1.05])
#plt.xlabel('False Positive Rate')
#plt.ylabel('True Positive Rate')
#plt.title('Receiver operating characteristic example')
#plt.legend(loc="lower right")
#plt.show()























# 得到与选择出来的特征对应的名称
names_selected = brain_region_names[:,feature_selected]
names_selected_list = []
for i in range(names_selected[0].shape[0]):
    names_selected_list.append( names_selected[0][i] )
    
# 得到各个特征在分类的时候所得到的权重，使用线性SVM
score_feature_weight_matrix =  np.array(score_feature_weight)  
mean_score_feature_weight = np.mean(score_feature_weight_matrix,axis=0)

# 权重取绝对值
mean_score_feature_weight = np.fabs(mean_score_feature_weight)

# 根据权重排序
result_dict = {}
for i in range(mean_score_feature_weight.shape[0]):
    result_dict[names_selected_list[i][0]] = mean_score_feature_weight[i]
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
workbook.save(r'Paper\result\MDD-HD-AAL-Functional.xls')   



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
for i in range(1,107):
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
    else:
        print i

node_size_end = [x*10 for x in node_size ]     
plot_regions_weight(node_coords,node_size_end)

str2 = ''   
for i in range(len(node_coords)):
    str2 = str2 +  str(node_coords[i][0])+'    '+str(node_coords[i][1])+'    '+str(node_coords[i][2])+'    '+str(node_size_end[i])+'    1     0.9 0.0 0.0    '+str(regions_sorted[i][0].split(' ')[0])
    str2 = str2 + '\n'

file_object = open(root + r'\Paper\result\aal_function_regions_106.txt', 'w')
file_object.write(str2)
file_object.close( )


# 写入excel, 保存结果
import xlwt
os.chdir(root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('plot_region_weight_aal')
worksheet.write(0, 0, label = 'label')
worksheet.write(0, 1, label = 'color')
worksheet.write(0, 2, label = 'module')
worksheet.write(0, 3, label = 'size')
worksheet.write(0, 4, label = 'x')
worksheet.write(0, 5, label = 'y')
worksheet.write(0, 6, label = 'z')
for i in range(len(node_coords)):
    worksheet.write(i+1, 0, label = str(regions_sorted[i][0].split(' ')[0]) )
    worksheet.write(i+1, 1, label = '1 0 0')
    worksheet.write(i+1, 2, label = '1')
    worksheet.write(i+1, 3, label = (node_size_end[i])  )
    worksheet.write(i+1, 4, label = (node_coords[i][0]) )
    worksheet.write(i+1, 5, label = (node_coords[i][1]) )
    worksheet.write(i+1, 6, label = (node_coords[i][2]) )
      
workbook.save(r'Paper\result\aal_function_regions_106.xls')  

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

file_object = open(root + r'\Paper\result\aal_function_links_106.txt', 'w')
file_object.write(strs)
file_object.close( )        
#"""
#从排序好的连接特征生成连接文件
#"""
#"""
#把选择出来的共同特征转换成行向量
#"""
#import scipy.io as sio
#import os
#savepath = r'D:\FMRI_ROOT\YIYU\MVPA2'
#os.chdir(savepath)
#a = np.zeros((1,5565))
#a[0,feature_selected] = mean_score_feature_weight
#sio.savemat('selected_feature_aal',{'selected_feature':a})