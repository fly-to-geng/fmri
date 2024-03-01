spm('FnBanner',mfilename,SVNid);
% SPM8: spm_imcalc_extend (v3691)                    22:17:00 - 16/11/2016
% ========================================================================
SPMid = spm('FnBanner',mfilename,'$Rev: 3756 $');


% 获得文件P的头信息
P = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\af20160911002-182750-00006-00006-1.img',
    'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160911002\ep2d_bold_moco_p2_rest_0006\af20160911002-182750-00006-00006-1.img'};
header = spm_vol(P);

% 获得图像某个坐标的值
V = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\20160911002\beta_0001.img'};
XYZ = [13;48;2];
Y = spm_get_data(V,XYZ);

% 让Matlab发出声音的代码
sp=actxserver('SAPI.SpVoice');
sp.Speak('第一个被试处理完了！')
# 随机生成数据
XXX = np.random.rand(47, 100)
yyy  = [int(round(x+1)) for x in np.random.rand(47,1)]

# 排序特征
feature_sorted = sorted(result_dict.items(),lambda x,y : cmp(x[1],y[1]),reverse=True)

# 写入Excel
import xlwt
os.chdir(root)
workbook = xlwt.Workbook(encoding = 'ascii')
worksheet = workbook.add_sheet('MDD-HD-AAL-Functional')
for i in range(20):
    worksheet.write(i, 0, label = 'Row 0, Column 0 Value')
    worksheet.write(i, 1, label = 'Row 0, Column 0 Value')
    worksheet.write(i, 2, label = 'Row 0, Column 0 Value')
workbook.save(r'Paper\result\MDD-HD-AAL-Functional.xls')

# 弹出窗口
#%matplotlib qt
