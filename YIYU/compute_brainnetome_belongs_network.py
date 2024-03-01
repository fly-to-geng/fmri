# -*- coding: utf-8 -*-
"""
Created on Thu Feb 23 23:37:47 2017
http://stackoverflow.com/questions/21647120/how-to-use-the-cross-spectral-density-to-calculate-the-phase-shift-of-two-relate

@author: FF120
"""
"""
通过AAL模版计算brainnetome模版的各个脑区所属的网络
计算方法是： 选择距离AAL模版最近的脑区，用该脑区所属的网络表示该脑区所属的网络
"""
import xlrd
import string 

aal_file = r'D:\FMRI_ROOT\YIYU\ROIs\AAL\AAL3.xls'
data = xlrd.open_workbook(aal_file)
table = data.sheets()[0] 

names = []
coords = []
net_works = []
for i in range(2,118):
    names.append( table.cell(i,1).value )
    net_works.append( table.cell(i,3).value )
    x,y,z = table.cell(i,10).value,table.cell(i,11).value,table.cell(i,12).value
    coords.append((x,y,z))


ban_file = r'D:\FMRI_ROOT\YIYU\ROIs\brainnetome\BNA_subregions.xlsx'
data2 = xlrd.open_workbook(ban_file)
table2 = data2.sheets()[1] 
names2=  []
cood2 = []
for i in range(1,247):
    names2.append( table2.cell(i,1).value )
    a = table2.cell(i,2).value.split(',')
    a = [string.atof(i)for i in a]
    x = a[0]
    y = a[1]
    z = a[2]
    cood2.append((x,y,z))
    
#循环计算和AAL模版的距离，选出距离最近的三个脑区，保存下来手工选择
min_regions_list = []
min_distance_list = []
networks_list = []
for i in range(len(names2)):
    x = cood2[i][0]
    y = cood2[i][1]
    z = cood2[i][2]
    distance_list = []
    for j in range(len(names)):
        x2 = coords[j][0]
        y2 = coords[j][1]
        z2 = coords[j][2]
        distance = ( (x2-x)**2 + (y2-y)**2 + (z2-z)**2 ) ** 0.5
        distance_list.append( distance )
        
    min_index = distance_list.index( min(distance_list) )  
    min_region = names[min_index]
    min_regions_list.append(min_region)
    networks_list.append( net_works[min_index] )
    min_distance_list.append( min(distance_list))
    distance_list = []
    # 获得所有脑区与其中一个脑区的距离
        
# 写入excel, 保存结果
import os
import xlwt
os.chdir(r"d:/")
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('plot_region_weigh_net_e')##########################################
for i in range(len(min_regions_list)):
    worksheet.write(i, 0, label = str(names2[i] ) )
    worksheet.write(i, 1, label = str(min_regions_list[i] ) )
    worksheet.write(i, 2, label = str(networks_list[i]))
    worksheet.write(i, 3, label = str(min_distance_list[i]) )
    
workbook.save(r'a.xls') #########################################