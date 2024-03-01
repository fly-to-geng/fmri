# -*- coding: utf-8 -*-
"""
Created on Tue Aug 23 20:08:48 2016

@author: FF120
"""
import os

########################################################################
from nilearn import image
subject_name="20160916001"

aa = image.load_img(r"D:\mazcx\matlabtoolbox\BrainnetomeALL_v1_Beta_20160106\Atlas\FC\*.nii.gz")
atlas_filename = r"D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\20160916001\DictionaryLearningAlats.nii"
frmi_files = r"D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\20160916001\funcImg\4Dwraf20160916001-172740-00006-00006-1.nii"
result_path = "D:\\FMRI_ROOT\\YANTAI\\CLASSIFY\MVPA\\" + subject_name
os.chdir(result_path)


from nilearn.input_data import NiftiMapsMasker
masker = NiftiMapsMasker(maps_img=aa, standardize=True)
time_series = masker.fit_transform(frmi_files, confounds=None)
labels = [x for x in range(246)]
############################################################################
# `time_series` is now a 2D matrix, of shape (number of time points x
# number of regions)
print(time_series.shape)

############################################################################
# Build and display a correlation matrix
import numpy as np
correlation_matrix = np.corrcoef(time_series.T)

# Display the correlation matrix
from matplotlib import pyplot as plt
plt.figure(figsize=(10, 10))
# Mask out the major diagonal
np.fill_diagonal(correlation_matrix, 0)
plt.imshow(correlation_matrix, interpolation="nearest", cmap="RdBu_r",vmax=0.8, vmin=-0.8)
plt.colorbar()
# And display the labels
x_ticks = plt.xticks(range(len(labels)), labels, rotation=90)
y_ticks = plt.yticks(range(len(labels)), labels)

############################################################################
## And now display the corresponding graph
#from nilearn import plotting
#coords = atlas.region_coords
#
## We threshold to keep only the 20% of edges with the highest value
## because the graph is very dense
#plotting.plot_connectome(correlation_matrix, coords,
#                         edge_threshold="80%", colorbar=True)
#
#plotting.show()

# Compute the sparse inverse covariance
from sklearn.covariance import GraphLassoCV
estimator = GraphLassoCV()

estimator.fit(time_series)

# Display the connectome matrix
from matplotlib import pyplot as plt

# Display the covariance
plt.figure(figsize=(10, 10))

# The covariance can be found at estimator.covariance_
plt.imshow(estimator.covariance_, interpolation="nearest",
           vmax=1, vmin=-1, cmap=plt.cm.RdBu_r)
# And display the labels
x_ticks = plt.xticks(range(len(labels)), labels, rotation=90)
y_ticks = plt.yticks(range(len(labels)), labels)
plt.title('Covariance')

from nilearn import plotting
# And now display the corresponding graph
import numpy as np
dict_coords_connectomes = np.load("D:\data_processing\Python\Sub001\dict_coords_connectomes.npy")
plotting.plot_connectome(-estimator.covariance_,dict_coords_connectomes,
                         title='Covariance')

plotting.show()


# Display the sparse inverse covariance (we negate it to get partial
# correlations)
plt.figure(figsize=(10, 10))
plt.imshow(-estimator.precision_, interpolation="nearest",
           vmax=1, vmin=-1, cmap=plt.cm.RdBu_r)
# And display the labels
x_ticks = plt.xticks(range(len(labels)), labels, rotation=90)
y_ticks = plt.yticks(range(len(labels)), labels)
plt.title('Sparse inverse covariance')

from nilearn import plotting
# And now display the corresponding graph
import numpy as np
dict_coords_connectomes = np.load("D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\20160916001\dict_coords_connectomes.npy")
plotting.plot_connectome(-estimator.precision_,dict_coords_connectomes,
                         title='Sparse inverse covariance')

plotting.show()