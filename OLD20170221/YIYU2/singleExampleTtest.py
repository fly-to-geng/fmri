# -*- coding: utf-8 -*-
"""
Created on Wed Feb 15 19:26:00 2017

@author: FF120
"""


from scipy import stats
import numpy as np

# 要检验的数据，每列得到一个p值
data_matrix = '';
# 显著性标准
significance = 0.05

np.random.seed(7654567)
data_matrix = stats.norm.rvs(loc=5, scale=10, size=(50,100))
#rvs = stats.norm.rvs(loc=5, scale=10, size=(50,2))
#a = stats.ttest_1samp(rvs,0.0)
#data = rvs[:,0]
pvalues = stats.ttest_1samp(data_matrix,0.0)
p = pvalues[1]
# 得到显著性检验之后的mask
mask_significance = p<significance
print data_matrix.shape[1]
print np.sum(mask_significance)