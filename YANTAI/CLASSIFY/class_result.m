mvpa_path = 'D:\FMRI_ROOT\YANTAI\CLASSIFY\MVPA\';
subject_filter = '2016*';
cd(mvpa_path);
subExpID=dir(subject_filter);%=======================================
acc = cell(size(subExpID,1),3);
for  i=1:size(subExpID,1)
    class_result_path = [mvpa_path,subExpID(i).name,'\class_result.txt'];
    subject_acc = importdata(class_result_path);
    acc{i,1} = subject_acc(3);
    acc{i,2} = subject_acc(6);
    acc{i,3} = subject_acc(9);
end
accMat = cell2mat(acc);
cd(mvpa_path);
save('acc_stg','accMat');



