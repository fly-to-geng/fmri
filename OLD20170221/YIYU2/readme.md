# Matlab 代码

## plot_graph_use_matrix.m	
根据邻接矩阵绘制对应的有向连接图

## Bayes_model_selection_for_single_subject.m
每个被试单独选择最适合自己的模型，多个被试批量处理

## Bayes_model_selection_for_multiple_subjects.m
组水平的贝叶斯模型选择，选出组水平的最好的模型

## Bayes_model_selection_batch.m
SPM8用于贝叶斯模型选择的Batch，这里是一个被试的。

## define_GLM1.m  && define_GLM2.m
生成SPM.mat;为了后面做功能连接和有效连接的时候使用

## define_DCM_spm12.m && estimate_DCM_spm12.m
定义和估计静息态的DCM模型，可同时处理多个DCM，处理多个被试。

## dicom_import_for_functional_data.m && dicom_import_for_structure_data.m
转换抑郁症病人的数据格式

## spm_dcm_specify_ui_spm12.m
改写的SPM12中的同名函数，用来定义DCM模型。

======================================
# Python 代码

## classify_for_EC_yy.py
使用DCM模型提取出来的特征做分类

## classify_for_FC_yy.py
使用功能连接提取出来的特征做分类

## extract_feature_from_whole_brain.py
抽取全脑的体素值作为特征矩阵保存下来

## classify_use_multipe_feature_selection.py
使用一个大规模的特征，利用多种降维方法降维，再用同一个分类方法测试降维的效果

## classify_use_multiple_classifier.py
测试不同的分类器的分类效果，使用一个规模不大的特征



