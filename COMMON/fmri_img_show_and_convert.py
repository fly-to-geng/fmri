# -*- coding: utf-8 -*-
"""
Created on Tue Jan 24 10:08:47 2017

@author: FF120

用于试验各种图像计算方法
"""
Nifti1Image
import numpy as np
from nilearn import image
img = image.load_img(aal_multiple_label)
img_data = img.get_data()
print np.unique(img_data)
print np.sum(img_data == 91)
# 显示多重标签的图像
from nilearn import plotting

aal_multiple_label = r'C:\mazcx\matlabtoolbox\conn16b\rois\xAAL.nii'
#aa = r'C:\mazcx\matlabtoolbox\Brat2.1.5\Brat\template\spm12_masks\GM_brain.nii'
plotting.plot_roi(aal_multiple_label, title="AAL atlas")
plotting.show()

brainnetome_multiple_label = r'C:\mazcx\matlabtoolbox\conn16b\rois\Brainnetome.nii'
plotting.plot_roi(brainnetome_multiple_label, title="brainnetome atlas")
plotting.show()

# 显示ROI
roi_path = r'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\AAL\MNI_Amygdala_L_roi.img'
roi2_path = r'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\AAL\MNI_Frontal_Sup_Orb_R_roi.img'
roi3_path = r'D:\FMRI_ROOT\YANTAI\DESIGN\MASK\AAL\MNI_Amygdala_L_roi.img'
from nilearn import image
print plotting.find_xyz_cut_coords(roi3_path,activation_threshold=0.1)
img = image.load_img(roi3_path)
plotting.plot_roi(roi3_path)

from nilearn import image
atlas_region_coords = []
path = r'C:\mazcx\matlabtoolbox\BrainnetomeALL_v1_Beta_20160106\Atlas\subregion\f20.nii'
path = aa 
img = image.load_img(path)
atlas_region_coords.append( plotting.find_xyz_cut_coords(img) )
# 显示结构像
T1_img = r'D:\FMRI_ROOT\YIYU\T1Img\sub1001\s507-0010-00001-000176-01.img'
plotting.plot_anat(T1_img)

# 显示功能像
func_img = r'D:\FMRI_ROOT\YIYU\FunImg\sub1001\f507-0004-00001-000001-01.img'
plotting.plot_epi(func_img)

"""
#=============================================================================
计算AAL模版各个脑区的中心坐标并保存下来，
#=============================================================================
"""
import os
import numpy as np

aal = r'D:\FMRI_ROOT\YIYU\ROIs\AAL\mutiple_file'
#from nilearn import image
from nilearn import plotting
xyz_list = []
for i in range(1,133):
    filename = 'MNI_' + str(i) + '.img'
    path = os.path.join(aal,filename)
    xyz = plotting.find_xyz_cut_coords(path,activation_threshold=0.1)
    xyz2 = [round(x,2)  for x in xyz]
    xyz_list.append(xyz2)

#aal = image.load_img(path)
#aal_data = aal.get_data()
#print np.unique(aal_data)
#print np.sum(aal_data == 1)


import xlwt
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('MNI')
for i in range(len(xyz_list)):
    worksheet.write(i, 0, label = str(xyz_list[i][0])+', '+str(xyz_list[i][1]) + ', '+str(xyz_list[i][2]))
workbook.save(r'd:\MNI.xls')
#
#
## 读取excel表格
#import xlrd
#f = r'D:\FMRI_ROOT\YIYU\ROIs\brainnetome\BNA_subregions.xlsx'
#data = xlrd.open_workbook(f)
#table = data.sheets()[0]          #通过索引顺序获取
#count = 1

#
###########################################################
"""
读取图像数据，修改，然后保存成图像
"""
import numpy as np
from nilearn import image
import nibabel as nib

aal_multiple_label = r'D:\FMRI_ROOT\YIYU\ROIs\AAL\Resliced_aal_MNI_V4.nii'
img = image.load_img(aal_multiple_label)
img_data = img.get_data()
deleted_mask = img_data[:,:,:] <= 90
img_data[deleted_mask] = 0
new_img = image.new_img_like(img,img_data)
print np.unique(img_data)
nib.save(new_img,r'D:\xAAL.nii')
