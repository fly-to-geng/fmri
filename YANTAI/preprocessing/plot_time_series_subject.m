function Y = plot_time_series_subject(XYZ,subject_filter,file_filter)
% -------------------------------------------------------------------------
% ���� �� ����һ������4��RUN��ʱ������
% ���ã�plot_time_series_subject(XYZ,subject_filter,file_filter)
% ������
%   XYZ : ͼ���е�ĳ����
%   subject_filter : ���Թ�������e.g. 20161115*
%   file_filter : �ļ���������e.g.w*.img
%   Y����ȡ������
% -------------------------------------------------------------------------
pre_processing_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\'};
run_num = 272;
wFuncImg_filenames = cell(272*4,1);
cd(pre_processing_path{1});
subExpID = dir(subject_filter); 

for i=1:size(subExpID,1)
    cd([pre_processing_path{1},subExpID(i).name]);
    subRunID = dir('ep2d*');
    for j=1:size(subRunID,1)
        cd([pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name]);
        filenames = dir(file_filter);
        start = run_num*(j-1);
        for k=1:size(filenames,1)
            wFuncImg_filenames{start + k} = [pre_processing_path{1},subExpID(i).name,'\',subRunID(j).name,'\',filenames(k).name];
        end
    end
end
Y = extract_time_series(wFuncImg_filenames,XYZ);
plot(Y);