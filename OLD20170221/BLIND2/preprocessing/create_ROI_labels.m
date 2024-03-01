% 创建分割过标签图像需要的ROI标记数据
aal_file = 'D:\FMRI_ROOT\YIYU\ROIs\AAL\multiple_label_single_file\atlas.txt';
f = fopen(aal_file);
i = 1;
while 1
    ROI(i).ID = i;
    a = fgetl(f);
    if ~ischar(a), break, end
    ROI(i).Nom_C = a;
    ROI(i).Nom_L = a;
    i = i + 1;
end