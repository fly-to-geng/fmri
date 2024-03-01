# -*- coding: utf-8 -*-
"""
Created on Tue Jan 03 11:58:17 2017

@author: FF120

为环转图形生成数据
"""

"""
==============================================================================
brainnetome : 获得brainnetome每个脑区的体素数量，此处并没有重采样为实验中的格式，所以只用来估计各脑区体素的比例
==============================================================================
"""

brainnetome_path = r'C:\mazcx\matlabtoolbox\conn16b\rois\Brainnetome.nii'
import numpy as np
from nilearn import image
img = image.load_img(brainnetome_path)
img_data = np.round( img.get_data() )
region_voxel_num = []
for i in range(1,len(np.unique(img_data))):
    region_voxel_num.append( np.sum(img_data == i) )

if (sum(region_voxel_num) + np.sum(img_data == 0)) == img_data.shape[0] * img_data.shape[1] * img_data.shape[2]:
    print "成功获得各个脑区的体素数量"


"""
==============================================================================
brainnetome : 生成染色体文件 for brainnetome,324个脑区,每个脑区大小相同
==============================================================================
"""
brain_regions_path = r'C:\mazcx\matlabtoolbox\BrainnetomeALL_v1_Beta_20160106\Atlas\atlas.txt'
f = open(brain_regions_path)
brain_region_names = []
for line in f:
    l = line.split()
    brain_region_names.append(l[1])

# 去掉最后一个    
brain_region_names.pop()
str2 = ''   
for i in range(len(brain_region_names)):
    str2 = str2 + 'chr - ' + brain_region_names[i] + ' ' + brain_region_names[i] + ' 0 100 '+ 'chr'+str(i%20)
    str2 = str2 + '\n'

file_object = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\me\brainnetome.data.txt', 'w')
file_object.write(str2)
file_object.close( )

"""
==============================================================================
brainnetome ： 生成324个脑区的染色体，每个脑区根据自身体素多少确定大小
==============================================================================
"""
brain_regions_path = r'C:\mazcx\matlabtoolbox\BrainnetomeALL_v1_Beta_20160106\Atlas\atlas.txt'

f = open(brain_regions_path)
brain_region_names = []
for line in f:
    l = line.split()
    brain_region_names.append(l[1])

# 去掉最后一个    
brain_region_names.pop()
str2 = ''   
for i in range(len(brain_region_names)):
    str2 = str2 + 'chr - ' + brain_region_names[i] + ' ' + brain_region_names[i] + ' 0 '+str(region_voxel_num[i])+' chr'+str((i+8)%20)
    str2 = str2 + '\n'

file_object = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\me\brainnetome.voxelnum.data.txt', 'w')
file_object.write(str2)
file_object.close( )
"""
==============================================================================
根据平均功能连接vector生成连接文件，for brainnetome
==============================================================================
"""
MDD = r'D:\FMRI_ROOT\YIYU\MVPA\MDD_mean_functional_connectivity_brainnetome_vector.mat';
HD = r'D:\FMRI_ROOT\YIYU\MVPA\HD_mean_functional_connectivity_brainnetome_vector.mat'
labels = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_briannetome_second_level_vs_names.mat'
import scipy.io as sio
sMDD = sio.loadmat(MDD)['MDD_vector']
sHD = sio.loadmat(HD)['HD_vector']
brain_map_names = sio.loadmat(labels)['brain_map_names'][0];
sMDD_brain_dict = {}
for i in xrange(brain_map_names.shape[0]):
    #sMDD_brain_dict[brain_map_names[i][0]] = sMDD[0][i]
    sMDD_brain_dict[brain_map_names[i][0]] = sHD[0][i]

feature_sorted = sorted(sMDD_brain_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
a= feature_sorted[0]
kk = a[0].split('.')[1].replace(' ','_').split('(')[0][0:-1]
vv = a[1]
strings=''
lens = len(feature_sorted)
for i in xrange( len(feature_sorted) ):
    key = feature_sorted[i][0]
    value = feature_sorted[i][1]
    rs = key.split('->')
    r1 = rs[0].split('.')[1].replace(' ','_').split('(')[0]
    r2 = rs[1].split('.')[1].replace(' ','_').split('(')[0]
    if value*10 >= 1 and i < 400:
        strings = strings + r1 + ' 0 1 ' +r2+ ' 0 100 ' + 'thickness='+str(value*10)+',color=mecolor'+str(i%60)+',z='+str(lens-i)+'\n'
    
# 写入连接信息
file_object = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\brainnetomeF\links_hd_brainnetome.data.txt', 'w')
file_object.write(strings)
file_object.close() 

"""
==============================================================================
 DMN_DAN_SN： 生成染色体文件，for DMN_DAN_SN,每个脑区的大小相同
==============================================================================
"""
brain_regions_path = r'D:\FMRI_ROOT\YIYU\CONN\Mask\DMN_DAN_SN.txt'
f = open(brain_regions_path)
brain_region_names = []
for line in f:
    #l = line.split()
    brain_region_names.append(line.replace("\n", ""))

# 去掉最后一个    
#brain_region_names.pop()
str2 = ''   
for i in range(len(brain_region_names)):
    str2 = str2 + 'chr - ' + brain_region_names[i] + ' ' + brain_region_names[i] + ' 0 100 '+ 'chr'+str((i+4)%20)
    str2 = str2 + '\n'

file_object = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\NETF\network.data.txt', 'w')
file_object.write(str2)
file_object.close( )
"""
==============================================================================
 DMN_DAN_SN ： 生成DMN_DAN_SN对应的连接文件，来自平均功能连接文件
==============================================================================
"""
MDD = r'D:\FMRI_ROOT\YIYU\MVPA\MDD_mean_functional_connectivity_DMN_DAN_SN_vector.mat';
HD = r'D:\FMRI_ROOT\YIYU\MVPA\HD_mean_functional_connectivity_DMN_DAN_SN_vector.mat'
labels = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_DMN_DAN_SN_second_level_vs_names.mat'
import scipy.io as sio
sMDD = sio.loadmat(MDD)['MDD_vector']
sHD = sio.loadmat(HD)['HD_vector']
brain_map_names = sio.loadmat(labels)['brain_map_names'][0];
sMDD_brain_dict = {}
for i in xrange(brain_map_names.shape[0]):
    sMDD_brain_dict[brain_map_names[i][0]] = sMDD[0][i]
    #sMDD_brain_dict[brain_map_names[i][0]] = sHD[0][i]

feature_sorted = sorted(sMDD_brain_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
a= feature_sorted[0]
kk = a[0].split('->')
vv = a[1]
strings=''
lens = len(feature_sorted)
for i in xrange( len(feature_sorted) ):
    key = feature_sorted[i][0]
    value = feature_sorted[i][1]
    rs = key.split('->')
    r1 = rs[0]
    r2 = rs[1]
    if (value)*10 + 10 >= 1 and i < 400:
        strings = strings + r1 + ' 0 100 ' +r2+ ' 0 100 ' + 'thickness='+str((value)*10+10)+',color=mecolor'+str(i%60)+',z='+str(lens-i)+'\n'
    
# 写入连接信息
file_object = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\NETF\links_MDD.data.txt', 'w')
file_object.write(strings)
file_object.close() 





"""
==============================================================================
生成AAL模板对应的染色体
==============================================================================
"""
brain_regions_path = r'D:\FMRI_ROOT\YIYU\MVPA\subjects_funtional_conectivity_matrix_from_first_level_vs_names.mat'
import scipy.io as sio
brain_regions = sio.loadmat(brain_regions_path)['region_names'][0]
brain_region_names = []
for i in xrange(brain_regions.shape[0]):
    name = brain_regions[i][0].split('.')[1]
    name = name.replace(' ','_').split('(')[0]
    brain_region_names.append(name)

str2 = ''   
for i in range(len(brain_region_names)):
    str2 = str2 + 'chr - ' + brain_region_names[i] + ' ' + brain_region_names[i] + ' 0 1 ' + 'chr'+str((i+8)%20)
    str2 = str2 + '\n'

file_object = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\AALF\brainAAL.data.txt', 'w')
file_object.write(str2)
file_object.close( )

"""
==============================================================================
生成AAL模板对应染色体的连接文件
==============================================================================
"""
MDD = r'D:\FMRI_ROOT\YIYU\MVPA\MDD_mean_functional_connectivity_vector.mat';
HD = r'D:\FMRI_ROOT\YIYU\MVPA\HD_mean_functional_connectivity_vector.mat'
labels = r'D:\FMRI_ROOT\YIYU\MVPA\features_from_fc_aal_second_level_vs_names.mat'
import scipy.io as sio
sMDD = sio.loadmat(MDD)['MDD_vector']
sHD = sio.loadmat(HD)['HD_vector']
brain_map_names = sio.loadmat(labels)['brain_map_names'][0];
sMDD_brain_dict = {}
for i in xrange(brain_map_names.shape[0]):
    #sMDD_brain_dict[brain_map_names[i][0]] = sMDD[0][i]
    sMDD_brain_dict[brain_map_names[i][0]] = sHD[0][i]

feature_sorted = sorted(sMDD_brain_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)
a= feature_sorted[0]
kk = a[0].split('.')[1].replace(' ','_').split('(')[0][0:-1]
vv = a[1]
strings=''
lens = len(feature_sorted)
for i in xrange( len(feature_sorted) ):
    key = feature_sorted[i][0]
    value = feature_sorted[i][1]
    rs = key.split('->')
    r1 = rs[0].split('.')[1].replace(' ','_').split('(')[0]
    r2 = rs[1].split('.')[1].replace(' ','_').split('(')[0]
    if value*10 >= 1 and i < 400:
        strings = strings + r1 + ' 0 1 ' +r2+ ' 0 100 ' + 'thickness='+str(value*10)+',color=mecolor'+str(i%60)+',z='+str(lens-i)+'\n'
    
# 写入连接信息
file_object = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\AALF\links_hd.data.txt', 'w')
file_object.write(strings)
file_object.close() 
"""
==============================================================================
生成连接数据和脑区实体，只包括出现在特征中的脑区
==============================================================================
"""
import numpy as np
links_regions_path = r'D:\FMRI_ROOT\YIYU\MVPA\sorted_feature_selection_by_selectKBest.npy'
links = np.load(links_regions_path)
strings = ''
brain_regions_dict = {}
# plot first 1000 feature links
feature_num = 1000  # 要显示的连接的数量
color_num = 60 #自定义颜色的数量
for i in xrange(feature_num):
    r2r = links[i][0]
    intensity = links[i][1]
    r2rs = r2r.split('->')
    d1 = r2rs[0].split('.')[1]
    d2 = r2rs[1].split('.')[1]
    
    if brain_regions_dict.has_key(d1):
        brain_regions_dict[d1] = brain_regions_dict[d1] + 1
    else:
        brain_regions_dict[d1] = 1
    if brain_regions_dict.has_key(d2):
        brain_regions_dict[d2] = brain_regions_dict[d2] + 1
    else:
        brain_regions_dict[d2] = 1
    color =   int( i/int(i/60+1) ) + 1 # 定义每个连接的颜色
    z = feature_num-i  # 定义每个连接的层次，值越大，越靠上
    strings = strings + d1 + ' 0 100 ' +d2+ ' 0 100 ' + 'thickness='+str(intensity)+',color=mecolor'+str(color)+',z='+str(z)+'\n'

# 写入连接信息
file_object = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\me\links1000.data.txt', 'w')
file_object.write(strings)
file_object.close()  
    
# 写入染色体信息
string2 = ''
i = 1
for key,value in brain_regions_dict.items():
    #string2 = string2 + 'chr - ' + str(key) + ' ' + str(key) + ' 0 '+ str(value)+' mecolor'+str(i%60)+'\n'
    string2 = string2 + 'chr - ' + str(key) + ' ' + str(key) + ' 0 '+ str(value)+' chr'+str((value+10)%21)+'\n'
    i = i + 1
file_object2 = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\me\brain1000.data.txt', 'w')
file_object2.write(string2)
file_object2.close()  

 