fist_level_path = {'d:\data_processing\jianlong\data_processing\first_level3\'};
pre_processing_path = {'d:\data_processing\jianlong\data_processing\pre_processing3\'};

cd(pre_processing_path{1});
subExpID=dir('20*');
for i=1:size(subExpID,1)
    cd([pre_processing_path{1},subExpID(i).name]);
    runExpID=dir('ep*');
    for j=1:size(runExpID,1)
        cd([pre_processing_path{1},subExpID(i).name,'\',runExpID(j).name]);
        copyfile('w*',[fist_level_path{1},subExpID(i).name,'\','funcImg'],'f');
    end
end