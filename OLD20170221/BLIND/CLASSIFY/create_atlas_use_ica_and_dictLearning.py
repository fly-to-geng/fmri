"""
Dictionary Learning and ICA for doing group analysis of resting-state fMRI
==========================================================================

This example applies dictionary learning and ICA to resting-state data,
visualizing resulting components using atlas plotting tools.

Dictionary learning is a sparsity based decomposition method for extracting
spatial maps. It extracts maps that are naturally sparse and usually cleaner
than ICA

    * Gael Varoquaux et al.
      Multi-subject dictionary learning to segment an atlas of brain spontaneous
      activity
      Information Processing in Medical Imaging, 2011, pp. 562-573, Lecture Notes
      in Computer Science

Available on https://hal.inria.fr/inria-00588898/en/
"""
import os
###############################################################################
subject_name="20160916001"
######################################
func_filenames = "D:\\FMRI_ROOT\\YANTAI\\CLASSIFY\\MVPA\\"+subject_name+"\\funcImg\\4Dwraf20160916001-172740-00006-00006-1.nii"
result_path = "D:\\FMRI_ROOT\\YANTAI\\CLASSIFY\MVPA\\" + subject_name
os.chdir(result_path)
################################################################################
from nilearn import image
func_imgs =image.load_img(func_filenames)

###############################################################################
# Create two decomposition estimators
from nilearn.decomposition import DictLearning, CanICA

n_components = 40

###############################################################################
# Dictionary learning
dict_learning = DictLearning(n_components=n_components,
                             memory="nilearn_cache", memory_level=2,
                             verbose=1,
                             random_state=0,
                             n_epochs=1)
###############################################################################
# CanICA
canica = CanICA(n_components=n_components,
                memory="nilearn_cache", memory_level=2,
                threshold=3.,
                n_init=1,
                verbose=1)

###############################################################################
# Fit both estimators
estimators = [dict_learning, canica]
names = {dict_learning: 'DictionaryLearning', canica: 'CanICA'}
components_imgs = []

for estimator in estimators:
    print('[Example] Learning maps using %s model' % names[estimator])
    estimator.fit(func_imgs)
    print('[Example] Saving results')
    # Decomposition estimator embeds their own masker
    masker = estimator.masker_
    # Drop output maps to a Nifti   file
    components_img = masker.inverse_transform(estimator.components_)
    components_img.to_filename('%s_resting_state' %
                               names[estimator])
    components_imgs.append(components_img)

components_imgs[0].to_filename("DictionaryLearningAlats")
components_imgs[1].to_filename("CanICAAlats")

from nilearn import plotting
import numpy as np
dict_coords_connectomes=[]
for img in image.iter_img(components_imgs[0]):
    dict_coords_connectomes.append( plotting.find_xyz_cut_coords(img) )
dict_coords_connectomes = np.array(dict_coords_connectomes)
np.save("dict_coords_connectomes.npy",dict_coords_connectomes)
ica_coords_connectomes=[]
for img in image.iter_img(components_imgs[1]):
    ica_coords_connectomes.append( plotting.find_xyz_cut_coords(img) )
ica_coords_connectomes = np.array(ica_coords_connectomes)
np.save("ica_coords_connectomes.npy",ica_coords_connectomes)
###############################################################################

# Visualize the results
from nilearn.plotting import (plot_prob_atlas, find_xyz_cut_coords, show,
                              plot_stat_map)
from nilearn.image import index_img

# Selecting specific maps to display: maps were manually chosen to be similar
indices = {dict_learning: 1, canica: 31}
# We select relevant cut coordinates for displaying
cut_component = index_img(components_imgs[0], indices[dict_learning])
cut_coords = find_xyz_cut_coords(cut_component)
for estimator, components in zip(estimators, components_imgs):
    # 4D plotting
    plot_prob_atlas(components, view_type="filled_contours",
                    title="%s" % names[estimator],
                    cut_coords=cut_coords, colorbar=False)
    # 3D plotting
    plot_stat_map(index_img(components, indices[estimator]),
                  title="%s" % names[estimator],
                  cut_coords=cut_coords, colorbar=False)
show()


import dill
filename= 'create_atlas_use_ica_dictlearning.pkl'
dill.dump_session(filename)


