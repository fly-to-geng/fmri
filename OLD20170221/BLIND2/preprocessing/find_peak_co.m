
spmT_filepath = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\20160911002\spmT_0020.hdr';
xjview(spmT_filepath);
%显示出激活图像
% 找到峰值
h = spm_mip_ui('FindMIPax');
% loc     - String defining jump: 'dntmv' - don't move
%                                 'nrvox' - nearest suprathreshold voxel
%                                 'nrmax' - nearest local maxima
%                                 'glmax' - global maxima
loc = 'glmax';
xyz = spm_mip_ui('Jump',h,loc);