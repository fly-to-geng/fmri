# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 16:52:25 2017

@author: FF120
"""

# 网络节点的定义
# ---------------
vmPFC = (3,54,-2)
lIPL = (-50,-63,32)
rIPL = (48,-69,35)
PCC = (0,-52,26)
DMN = [vmPFC,lIPL,rIPL,PCC]
# -------------------------------
lFEF = (-24,-15,66)
rFEF = (28,-10,58)
lSPL = (-24,-55,72)
rSPL = (24,-55,72)
DAN = [lFEF,rFEF,lSPL,rSPL]
#- --------------------------
dACC = (0,-10,40)
lAI = (-43,-11,-1)
rAI = (43,-11,-1)
SN = [dACC,lAI,rAI]
# -----------------------------
node_coords = SN
node_size = [100,100,100]

def plot_regions_weight(node_coords,node_size):
    from nilearn import plotting
    import numpy as np
    n = len( node_coords )
    adjacency_matrix = np.zeros((n,n))
    display = plotting.plot_connectome(adjacency_matrix,node_coords,title='SN',node_color='auto',node_size=node_size,colorbar=False)
    
    #display.savefig('sbc_z.pdf') 
plot_regions_weight(node_coords,node_size)


#from matplotlib import pyplot as plt
#import numpy as np
#plt.figure(figsize=(9,6))
#n=10
##rand 均匀分布和 randn高斯分布
#x=np.random.randn(1,n)
#y=np.random.randn(1,n)
#T=np.arctan2(x,y)
#label = ['1']*10
#plt.scatter(x,y,c=T,s=25,alpha=0.4,marker='o')
##plt.plot(x,y,'ro',color='red',label='label')
#for i in range(len(label)):
#    plt.text(x[0][i],y[0][i],str(label[i]))

#T:散点的颜色
#s：散点的大小
#alpha:是透明程度
#plt.show()