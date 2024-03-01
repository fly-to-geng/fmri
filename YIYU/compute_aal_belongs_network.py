# -*- coding: utf-8 -*-
"""
Created on Tue Feb 28 08:54:26 2017

@author: FF120
"""

from nilearn import image
import numpy as np
aal = r'D:\FMRI_ROOT\YIYU\ROIs\AAL\aal.nii'
img = image.load_img(aal)
aal_data = img.get_data()
aal_unique = np.unique(aal_data)
print aal_unique

net = r'D:\FMRI_ROOT\YIYU\ROIs\Yeo\Resliced_a.nii'
net_img = image.load_img(net)
net_data = net_img.get_data()
net_unique = np.unique(net_data)
print net_unique

net_belongs = []
for i in range(net_unique.shape[0]):
    net_belongs.append( aal_data[net_data == i] )
    
b = []    
for i in range(len(net_belongs)):
    print("---------",i)
    aal_regions = np.unique( net_belongs[i] )
    # 统计个数
    a = {}
    for j in range(aal_regions.shape[0]):
        a[ aal_regions[j]] = ( np.sum(net_belongs[i] == aal_regions[j]) )
        
    b.append(a)

#qq=[]
#for i in range(len(b)):
#    qq.append( np.sum(b[i].values()) )
# 写入excel, 保存结果
save_root = r'd:/'
import os
import xlwt
os.chdir(save_root)
workbook = xlwt.Workbook()
worksheet = workbook.add_sheet('ff')##########################################
for i in range(1,8):
    k = b[i].keys()
    v = b[i].values()
    for j in range(len(k)):
        worksheet.write(int(k[j]),i,label = int(v[j]) )

# 得到每个脑区的体素数量写入文件
for i in range(aal_unique.shape[0]):  
    voxel_num=(np.sum(aal_data == aal_unique[i]))
    worksheet.write(i,8,label = int(voxel_num) )
workbook.save(r'aa.xls')
    