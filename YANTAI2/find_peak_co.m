function xyz=find_peak_co(spmT_filepath,input_xyz)
%���ܣ� �ҵ��ļ�spmT������input_xyz��������󼤻�λ�ã����ؼ���λ�õ�����
%
%
%spmT_filepath = 'D:\FMRI_ROOT\YANTAI2\ANALYSIS\first_level_dcm_4class\HC\20160911002\spmF_0001.nii';
%input_xyz= [-10,20,10];
%xjview(spmT_filepath);
%��ʾ������ͼ��
% �ҵ���ֵ
% loc     - String defining jump: 'dntmv' - don't move
%                                 'nrvox' - nearest suprathreshold voxel
%                                 'nrmax' - nearest local maxima
%                                 'glmax' - global maxima
%loc = 'glmax';
%xyz = spm_mip_ui('Jump',h,loc);
h = spm_mip_ui('FindMIPax');
hC = 0;
[xyz,d] = spm_mip_ui('SetCoords',input_xyz,h,hC);
loc = 'nrmax';
xyz = spm_mip_ui('Jump',h,loc);