% ��ȡ�������ӵ�����
root_path = 'D:\FMRI_ROOT\YANTAI\CONN\conn_project_batch\results\secondlevel\ANALYSIS_01\AllSubjects\';
save_path = 'D:\FMRI_ROOT\YANTAI\CONN\conn_project_batch\results\';
regions_sum = 132;% ���������
sunjects_sum = 20;% ���Ե�����
cd(root_path);
conditions = {'JX','DW','RL','ZR'};
data_Conn = cell(size(conditions,2),1);
y_Conn = cell(size(conditions,2),1);
for i = 1:size(conditions,2)
    cd([root_path,conditions{i}]);
    load('ROI.mat'); % ��������ΪROI�ı���
    for j = 1 : size(ROI,2)
        features = ROI(j).y;
        features(:,j) = [];
        data_matrix(:,regions_sum*(j-1)+1:regions_sum*j) = features;
    end
    data_Conn{i} = data_matrix;
    % ������Ӧ��label
    label = zeros(sunjects_sum,1);
    label(:,1) = i;
    y_Conn{i} = label;
end
X = cell2mat(data_Conn);
y = cell2mat(y_Conn);
data = [y X];
cd(save_path);
save('data_Conn','data');