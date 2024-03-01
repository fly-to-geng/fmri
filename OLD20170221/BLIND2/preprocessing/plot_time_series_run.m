function Y = plot_time_series_run(XYZ,run_dir,file_filter)
% -------------------------------------------------------------------------
% ���� �� ����һ��RUN��ʱ������
% ���ã�Y = plot_time_series_run(run_dir,file_filter)
% ������
%   XYZ : ͼ���е�ĳ����
%   run_dir : run�ļ���·��
%   file_filter : �ļ���������e.g.w*.img
%   Y����ȡ������
% -------------------------------------------------------------------------
V = cell(272,1);
cd(run_dir);
files = dir(file_filter);
for k = 1:size(files,1)
    V{k} = [run_dir,'\',files(k).name];
end
Y = spm_get_data(V,XYZ);
plot(Y);