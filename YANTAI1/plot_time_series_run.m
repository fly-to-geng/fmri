function Y = plot_time_series_run(XYZ,run_dir,file_filter)
% -------------------------------------------------------------------------
% 功能 ： 绘制一个RUN的时间序列
% 调用：Y = plot_time_series_run(run_dir,file_filter)
% 参数：
%   XYZ : 图像中的某个点
%   run_dir : run文件夹路径
%   file_filter : 文件过滤器，e.g.w*.img
%   Y：提取的数据
% -------------------------------------------------------------------------
V = cell(272,1);
cd(run_dir);
files = dir(file_filter);
for k = 1:size(files,1)
    V{k} = [run_dir,'\',files(k).name];
end
Y = spm_get_data(V,XYZ);
plot(Y);