% 生成color bar 原始数据集
% colorname1 R G B
% colorname2 R G B 
% 产生颜色的种类
% color_num = 60;
% colors_unit = jet(color_num);
% colors = colors_unit * 255;
% fid=fopen('D:\FMRI_ROOT\TOOLS\circos-0.69-3\etc\colors.me.conf','w+');
% for i =1:size(colors,1)
%     fprintf(fid,['mecolor',num2str(size(colors,1)-i+1),'=',num2str(colors(i,1)),',',num2str(colors(i,2)),',',num2str(colors(i,3)),'\n']);
% end
% 
% fclose(fid); 
% 
% 
% colormap(colors_unit);
% colorbar();

% for a = 10:-1:1
%     disp(a)
% end

% 生成被试描述数据
% path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing'
% cd(path);
% s = dir('2016*');
% for i=1:size(s,1)
%     subjects(i).name = s(i).name;
%     subjects(i).label = '';
%     subjects(i).real_name = '';
%     subjects(i).age = '';
%     subjects(i).sex = '';
%     subjects(i).remark = '';
% end

% 打印功能连接混淆矩阵结果
ROI_mat_path  = 'D:\FMRI_ROOT\YIYU\CONN\conn_project01\results\secondlevel\ANALYSIS_02\AllSubjects\rest\ROI.mat';
save_path = 'D:\FMRI_ROOT\YIYU\MVPA\';
load(ROI_mat_path);
features = cell(1,size(ROI,2));
for i = 1:size(ROI,2)
   y = ROI(i).y;
   %y(:,i) = [];
   features{i} = y(:,1:132);
   clear y;
end
subjects_connection = cell(53,1);
for i=1:53
    temp = cell(size(features,2),1);
    for j=1:size(features,2)
        matrix_s = features{j};
        matrix_i = matrix_s(i,:);
        temp{j} = matrix_i;
    end
    subjects_connection{i} = cell2mat(temp);
end

%
