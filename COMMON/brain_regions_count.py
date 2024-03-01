# -*- coding: utf-8 -*-
"""
Created on Tue Dec 06 14:23:29 2016

@author: FF120
"""

import os
import numpy as np

mvpa_path = r'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA'
subject_lists = ['20160911002','20160916001','20160919001','20160919001','20160921001','20160923003','20160927003','20161001001','20161003002','20161005003','20161006002','20161009002','20161012003','20161014001','20161015002','20161021002','20161024002','20161027002','20161101002','20161104002']
line_num = 5 #读取多少行

region_list = []
for i in xrange(len(subject_lists)):
    path = mvpa_path + '\\'+subject_lists[i] + '\\sorted_result.txt'
    if os.path.exists(path):
        
        f = open(path)
        for j in xrange(line_num):
            line = f.readline().split('    ');
            region_name = line[1]
            region_list.append(region_name)
        
# 统计频率
word_count = {}
for region in region_list:
    word_count[region] = word_count.get(region,0) + 1
    
sorted_word_count = sorted(word_count.items(), lambda x, y: cmp(x[1], y[1]), reverse=True)
lineString = '';
for i in xrange(len(sorted_word_count)):
    line = sorted_word_count[i]
    lineString = lineString + str(line[1]) + '    ' + str(line[0]) + '\n'
os.chdir(r'd:\\')
output = open('sorted_word_count.txt', 'w')
output.write(lineString)
output.close()