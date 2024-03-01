function mean_img(input_img,output_img)
% -------------------------------------------------------------------------
% ���ܣ������ɸ�ͼ���ƽ��ͼ��
% ���ã�mean_img(input_img,output_img)
% ������
%   input_img : cell���͵�����ͼ�񣬾���·��
%   output_img : ���ͼ��ľ���·��
% ʾ����
%   input_img = { 'd:\fmri_root\YANTAI\ANALYSIS\mean_smooth4\DW10\s4wraf20161104002-181316-00074-00074-1.img,1'
%                 'd:\fmri_root\YANTAI\ANALYSIS\mean_smooth4\DW11\s4wraf20161104002-181208-00040-00040-1.img,1'
%                 'd:\fmri_root\YANTAI\ANALYSIS\mean_smooth4\DW20\s4wraf20161104002-181822-00227-00227-1.img,1'
%                 'd:\fmri_root\YANTAI\ANALYSIS\mean_smooth4\DW21\s4wraf20161104002-181640-00176-00176-1.img,1'};
%   output_img = 'd:\out.img';
% 	mean_img(input_img,output_img)
% ˵�����޸�matlabbatch{1}.spm.util.imcalc.expression������ɲ�ͬ�ļ�������
% -------------------------------------------------------------------------
[path,name,exit] = fileparts(output_img) ;
spm_jobman('initcfg')
%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.util.imcalc.input = input_img;
matlabbatch{1}.spm.util.imcalc.output = [name,exit];
matlabbatch{1}.spm.util.imcalc.outdir = {path};
matlabbatch{1}.spm.util.imcalc.expression = '(i1+i2+i3+i4)/4';
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;
%--------------------------------------------------------------------------
spm_jobman('run',matlabbatch);
disp('mean_img successful !');
clear matlabbatch;