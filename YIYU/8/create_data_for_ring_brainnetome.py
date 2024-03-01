# -*- coding: utf-8 -*-
"""
Created on Sun Feb 26 21:50:49 2017

@author: FF120

为换环状图形生成数据
"""
import pandas as pd
import os
func_aal = r'D:\FMRI_ROOT\YIYU\Result\8\classi_weight_func_brainnetome.xls'
df = pd.read_excel(func_aal,sheetname='region_weight2_brainnetome')
df_sorted = df.sort_values(by="netID")
save_path = r'D:\FMRI_ROOT\YIYU\Result\8'
os.chdir(save_path)
df_sorted.to_excel('classi_weight_func_brainnetome_sorted_net.xlsx', sheet_name='Sheet1')
# 生成排序后的脑区数据
df_region =  pd.read_excel(r'classi_weight_func_brainnetome_sorted_net.xlsx',sheetname='Sheet1')
"""
写入脑区数据，TXT格式
"""
import os
save_root = r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\brainnetome8'
str2 = ''   
for i in range(df_region.shape[0]):
    str2 = str2 +  'chr - '+df_region['name'][i]+' '+df_region['name'][i] + \
        ' 0  '+str(int(df_region['intensity'][i]*1000))+'  lum'+str(i%89)
    str2 = str2 + '\n'

file_object = open(os.path.join(save_root,r'regions_brainnetome.txt'), 'w')#######################################
file_object.write(str2)
file_object.close( )

"""
写入连接数据，TXT个格式
"""
df_links = pd.read_excel(func_aal,sheetname='connection_weight_brainnetome')
save_root = r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\brainnetome8'
str2 = ''   
for i in range(df_links.shape[0]):
    if df_links['intensity'][i]*1000 > 1 and df_links['name1_netID'][i]!=10 and df_links['name2_netID'][i]!=10:
        str2 = str2 +  df_links['name1'][i].split('.')[1]+' 0 10000 '+df_links['name2'][i].split('.')[1] + ' 0 10000 ' + 'thickness='+str(df_links['intensity'][i]*1000)+',color=mecolor'+str(i%50)+',z='+str(df_links.shape[0]-i)
        str2 = str2 + '\n'

file_object = open(os.path.join(save_root,r'links_brainnetome.txt'), 'w')#######################################
file_object.write(str2)
file_object.close( )