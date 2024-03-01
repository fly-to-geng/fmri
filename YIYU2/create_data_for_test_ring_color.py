# -*- coding: utf-8 -*-
"""
Created on Tue Jan 03 18:00:59 2017

@author: FF120

创建测试数据集，测试自定义颜色的用处
"""
string2 = ''
for i in range(60):
    string2 = string2 + 'chr - ' + 's'+str(i) + ' '+str(i) + ' 0 1 '+' mecolor'+str((i+1)%60)+'\n'
file_object2 = open(r'D:\FMRI_ROOT\TOOLS\circos-0.69-3\bin\test\colors\brain.data.txt', 'w')
file_object2.write(string2)
file_object2.close()  
