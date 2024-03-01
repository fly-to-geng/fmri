% 将多个rp*头动文件，合成一个头动文件
pre_processing = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\';
cd(pre_processing);
subjects = dir('2016*');
for i = 1: size(subjects,1)
   cd([pre_processing,subjects(i).name]);
   SubRunID = dir('ep2d*');
   rps = ones(272*4,6);
   for j = 1:size(SubRunID,1)
       cd([pre_processing,subjects(i).name,'\',SubRunID(j).name]);
       file = dir('rp*');
       filename = file(1).name;
       a = load(filename);
       rps(272*(j-1)+1:272*j,1:6) = a;
   end
    cd([pre_processing,subjects(i).name]);
    save('rp_all.txt','rps','-ascii');
end