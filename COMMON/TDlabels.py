# -*- coding: utf-8 -*-
"""
Created on Thu Dec 08 23:26:49 2016

@author: FF120

将20个被试的TDLabels分类结果平均，得出排名前10 的脑区，
"""
import os
import string
import xlwt

subject_lists = ['20160911002','20160916001','20160919001','20160919001','20160921001','20160923003','20160927003','20161001001','20161003002','20161005003','20161006002','20161009002','20161012003','20161014001','20161015002','20161021002','20161024002','20161027002','20161101002','20161104002']
mvpa_root = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA'
line_num = 114
dict_sub = {}

for i in range(len(subject_lists)):
    file_path = mvpa_root + '\\'+ subject_lists[i] + '\\' + 'sorted_result.txt'
    if os.path.exists(file_path):
        f = open(file_path)
        for j in xrange(line_num):
            line = f.readline().split('    ');
            region_name = line[1]
            rn = region_name
            if dict_sub.has_key(rn):
                dict_sub[rn] =  dict_sub[rn]+ string.atof( line[0] )
            else:
                dict_sub[rn] =  string.atof(line[0])
        f.close()

# 将结果除以10，得到平均准确率，按照从大到小排序并保存结果   
for key,value in dict_sub.items():
    dict_sub[key] = dict_sub[key] / len(subject_lists)
    
sorted_dict_sub = sorted(dict_sub.items(), lambda x, y: cmp(x[1], y[1]), reverse=True)

os.chdir(mvpa_root)
wb = xlwt.Workbook()
ws = wb.add_sheet('TDLabels')
for i in xrange(len(sorted_dict_sub)):
    ws.write(i,0,sorted_dict_sub[i][0])
    ws.write(i,1,sorted_dict_sub[i][1])
    
wb.save('AAL_subjects.xls')