function mean_img(input_img,output_img)
% -------------------------------------------------------------------------
% 功能：求若干个图像的平均图像
% 调用：mean_img(input_img,output_img)
% 参数：
%   input_img : cell类型的输入图像，绝对路径
%   output_img : 输出图像的绝对路径
% 示例：
%   input_img = { 'd:\fmri_root\YANTAI\ANALYSIS\mean_smooth4\DW10\s4wraf20161104002-181316-00074-00074-1.img,1'
%                 'd:\fmri_root\YANTAI\ANALYSIS\mean_smooth4\DW11\s4wraf20161104002-181208-00040-00040-1.img,1'
%                 'd:\fmri_root\YANTAI\ANALYSIS\mean_smooth4\DW20\s4wraf20161104002-181822-00227-00227-1.img,1'
%                 'd:\fmri_root\YANTAI\ANALYSIS\mean_smooth4\DW21\s4wraf20161104002-181640-00176-00176-1.img,1'};
%   output_img = 'd:\out.img';
% 	mean_img(input_img,output_img)
% 说明：修改matlabbatch{1}.spm.util.imcalc.expression可以完成不同的计算任务
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