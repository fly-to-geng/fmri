# -*- coding: utf-8 -*-
"""
Created on Thu Feb 16 20:51:59 2017
116个脑区的conn默认模版对应的功能连接数据
@author: FF120
"""
import scipy.io as sio
import numpy as np
from scipy import stats
import os

root = r'D:\FMRI_ROOT\YIYU\CONN\conn_project01\meresult'
func_matrix_aal_name = r'subjects_funtional_conectivity_matrix_from_first_level.mat'
func_matrix_aal_names_name = r'subjects_funtional_conectivity_matrix_from_first_level_vs_names.mat'
labels_path = r'y.npy'
features_name = r'features_from_fc_aal_first_level_vs_names.mat'
# 加载数据转成python格式
data_root = os.path.join(root,'data')
func_matrix_aal =  [i for i in sio.loadmat(os.path.join(data_root,func_matrix_aal_name))['subjects'] ] 
func_matrix_aal_name = np.asarray( [a for a in sio.loadmat(os.path.join(data_root,func_matrix_aal_names_name))['region_names'][0] ] )
temp = []
for i in xrange(len(func_matrix_aal)):
    temp.append(np.nan_to_num(func_matrix_aal[i][0]))
func_matrix_aal = np.asarray(temp)
labels = np.load(os.path.join(data_root,labels_path)) #被试所属类别的标签
features_name = sio.loadmat(os.path.join(data_root,features_name))['brain_map_names']
features_name = [i for i in features_name[0]]
features_name = np.asarray(features_name)
##############################################################################
"""
# 单样本T检验，分别检查每组被试平均的连接是否显著大于0
"""
p = 0.001  # 去掉显著性大于0.001的连接##############################################
hc = func_matrix_aal[0:26,:,:]
mdd = func_matrix_aal[26:,:,:]
pvalues1 = stats.ttest_1samp(hc,0.0,axis=0)
p1 = pvalues1[1]
deleted_mask1 = p1>p # 要删除的连接
hc[:,deleted_mask1] = 0 # 删除的连接置0

pvalues2 = stats.ttest_1samp(mdd,0.0,axis=0)
p2 = pvalues2[1]
deleted_mask2 = p2>p # 要删除的连接
mdd[:,deleted_mask2] = 0 # 删除的连接置0

"""
# 双样本T检验，检查两组之间差异显著的功能连接，把差异不显著的置0
"""
indepedent_t = stats.ttest_ind(hc,mdd,axis=0)
p3 = indepedent_t[1]
deleted_mask3 = p3>p
func_matrix_aal[:,deleted_mask3] = 0
# 不同的被试的功能连接值平均一下得到组水平的结果
mean_hc = np.mean(hc,axis=0)
mean_mdd = np.mean(mdd,axis=0)
mean_func_matrix_aal = np.mean(func_matrix_aal,axis=0)

# 保存结果
os.chdir(os.path.join(root,'func_result'))
sio.savemat('mean_func_matrix.mat',{'mean_hc':mean_hc,'mean_mdd':mean_mdd,\
        'mean_func_matrix_aal':mean_func_matrix_aal})

##############################################################################       
"""
生成AAL模板对应的染色体
"""
os.chdir(os.path.join(root,'func_result'))

# 分割脑区名称
def aal_split(region_name):
    name = region_name.split('.')[1].split('(')[0].replace(' ','_')
    return name
 
#脑区名称   
brain_region_names = []
for i in xrange(func_matrix_aal_name.shape[0]):
    name = aal_split(func_matrix_aal_name[i][0])
    brain_region_names.append(name)

# 生成环状图形需要的染色体文件
str2 = ''   
for i in range(len(brain_region_names)):
    str2 = str2 + 'chr - ' + brain_region_names[i] + ' ' + brain_region_names[i] + ' 0 1 ' + 'chr'+str((i+8)%20)
    str2 = str2 + '\n'
os.chdir(os.path.join(root,'func_result'))
file_object = open(r'regions_conn_for_ring.data.txt', 'w')
file_object.write(str2)
file_object.close( )
"""
# 生成环状图形需要的连接文件
"""
mean_vector_name = r'mean_func_vector.mat'
mean_vector = sio.loadmat(os.path.join(root,'func_result',mean_vector_name) )
mean_aal_vector = mean_vector['mean_aal_vector']
mean_hc_vector = mean_vector['mean_hc_vector']
mean_mdd_vector = mean_vector['mean_mdd_vector']


aal_dict = {}
for i in xrange(features_name.shape[0]):
    aal_dict[features_name[i][0]] = mean_aal_vector[0][i]
    
hc_dict = {}
for i in xrange(features_name.shape[0]):
    hc_dict[features_name[i][0]] = mean_hc_vector[0][i]
    
mdd_dict = {}
for i in xrange(features_name.shape[0]):
    mdd_dict[features_name[i][0]] = mean_mdd_vector[0][i]

aal_conn_sorted = sorted(aal_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
hc_conn_sorted = sorted(hc_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
mdd_conn_sorted = sorted(mdd_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)


#########################################
aal_strings=''
lens = len(aal_conn_sorted)
for i in xrange( lens ):
    key = aal_conn_sorted[i][0]
    value = aal_conn_sorted[i][1]
    rs = key.split('->')
    r1 = aal_split(rs[0])
    r2 = aal_split(rs[1])
    if value*10 >= 1 and i < 400: #控制显示的数量
        aal_strings = aal_strings + r1 + ' 0 1 ' +r2+ ' 0 100 ' + 'thickness='+str(value*10)+',color=mecolor'+str(i%60)+',z='+str(lens-i)+'\n'
    
# 写入连接信息
file_object = open(os.path.join(root,'func_result','all_subjects_conn_links.txt'),'w')
file_object.write(aal_strings)
file_object.close() 


##########################################
hc_strings=''
lens = len(hc_conn_sorted)
for i in xrange( lens ):
    key = hc_conn_sorted[i][0]
    value = hc_conn_sorted[i][1]
    rs = key.split('->')
    r1 = aal_split(rs[0])
    r2 = aal_split(rs[1])
    if value*10 >= 1 and i < 400: #控制显示的数量
        hc_strings = hc_strings + r1 + ' 0 1 ' +r2+ ' 0 100 ' + 'thickness='+str(value*10)+',color=mecolor'+str(i%60)+',z='+str(lens-i)+'\n'
    
# 写入连接信息
file_object = open(os.path.join(root,'func_result','hc_subjects_links.txt'),'w')
file_object.write(hc_strings)
file_object.close() 

#################################################
mdd_strings=''
lens = len(mdd_conn_sorted)
for i in xrange( lens ):
    key = mdd_conn_sorted[i][0]
    value = mdd_conn_sorted[i][1]
    rs = key.split('->')
    r1 = aal_split(rs[0])
    r2 = aal_split(rs[1])
    if value*10 >= 1 and i < 400: #控制显示的数量
        mdd_strings = mdd_strings + r1 + ' 0 1 ' +r2+ ' 0 100 ' + 'thickness='+str(value*10)+',color=mecolor'+str(i%60)+',z='+str(lens-i)+'\n'
    
# 写入连接信息
file_object = open(os.path.join(root,'func_result','mdd_subjects_links.txt'),'w')
file_object.write(mdd_strings)
file_object.close() 