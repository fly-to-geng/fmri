# -*- coding: utf-8 -*-
"""
Created on Thu Aug 18 22:54:19 2016

@author: FF120
"""
import os
import numpy as np
import Utils.fmriUtils as fm
root = r"D:\FMRI_ROOT\YANTAI"
save_path = r"D:\FMRI_ROOT\YANTAI\CLASSIFY\RESULT\20160911002"
n_folds = 10

os.chdir(root)
label_path = root+'\DESIGN\label.npy'
empty_tr_path = root+'\DESIGN\empty_tr.npy'
mask_path = root + '\DESIGN\MASK\mask.img'
func_path = r"D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\funcImg\20160911002\4Dwraf20160911002-182750-00006-00006-1.nii"
label = np.load(label_path)
empty_tr = np.load(empty_tr_path)

from nilearn.decoding import SpaceNetRegressor
decoder = SpaceNetRegressor(mask=mask_path, penalty="tv-l1",l1_ratios=0.5,
                            eps=1e-1,  # prefer large alphas
                            memory="nilearn_cache")

from nilearn import image
func_imgs = []
for volume in image.iter_img(func_path): 
    func_imgs.append(volume)
    
func_imgs2 = np.delete(func_imgs,empty_tr-1,axis=0)
func_imgs3 = func_imgs2.tolist()
yy = fm.defineClass(label)
decoder.fit(func_imgs3, yy)
decoder.coef_img_.to_filename("SpaceNetMask001_07")
# Visualize TV-L1 weights
from nilearn.plotting import plot_stat_map, show
plot_stat_map(decoder.coef_img_, title="tv-l1", display_mode="yz",
              cut_coords=[20, -2])
              

# 保存spyder工作区所有的变量
os.chdir(save_path)
import dill
filename= 'create_mask_with_SpaceNet.pkl'
dill.dump_session(filename)
              
###########################################################################################            
            
              
#========================================================================
#decoder2 = SpaceNetRegressor(mask=mask_path, penalty="tv-l1",l1_ratios=[0.1,0.3,0.5,0.8],
#                            eps=1e-1,  # prefer large alphas
#                            memory="nilearn_cache")
#
#func_path2 = root + '\Sub002\wBoldImg4D_sub002.nii'              
#from nilearn import image
#func_imgs2 = []
#for volume in image.iter_img(func_path2): 
#    func_imgs2.append(volume)
#    
#func_imgs22 = np.delete(func_imgs2,empty_tr-1,axis=0)
#func_imgs33 = func_imgs22.tolist()
#yy = fm.defineClass(label)
#decoder2.fit(func_imgs33, yy)
#decoder2.coef_img_.to_filename("SpaceNetMask002")
## Visualize TV-L1 weights
#from nilearn.plotting import plot_stat_map, show
#plot_stat_map(decoder2.coef_img_, title="tv-l1", display_mode="yz",
#              cut_coords=[20, -2])              
# 加载fmri图像数据
#import nibabel as nib
#path = r"D:\data_processing\Python\sub001_s.img"
#img = nib.load(path)
#img_data = img.get_data()