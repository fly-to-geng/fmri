==========
## start.m
记录一些常用的语句

======
## 头动相关函数
- plothm.m	
根据头动文件rp*.txt生成图像并保存
- plothm_for_subjects.m
生成多个被试所有RUN的头动图像，保存在被试文件夹(与RUN同级的文件夹中)
- plothm_for_subjects_multiple_pattern.m
匹配多个通配符生成多个被试所有RUN的头动图像。是plothm_for_subjects的升级版

==============
## 预处理相关函数
- dicom_import.m
格式转换，多被试，一个通配符。
- dicom_import_for_multiple_pattern.m
格式转换，多被试，多个通配符
- pre_processing.m
预处理，多被试，一个通配符
- pre_processing_for_multiple_pattern.m
预处理，多被试，多个通配符
- smooth.m
平滑，用来用额外的平滑核做平滑，pre_processing中的平滑核是[6 6 6]
- smooth_for_multiple_pattern.m
平滑，多个被试，多个通配符

========
## First_level处理相关函数
- first_level.m
23个T检验的First_Level分析,4个RUN放在一起
- first_level_for_dcm_single_run
每个RUN单独做first_level,条件只有4个方向，专门为做DCM做的。
first_level_for_dcm_whole.m
4个RUN放在一起做的，也是为了做DCM做的。


