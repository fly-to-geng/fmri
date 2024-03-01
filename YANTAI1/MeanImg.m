% 加载实验设计
condition_mat_path = 'D:\FMRI_ROOT\YANTAI\DESIGN\conditons_dcm.mat';
load(condition_mat_path);
% 读取图像

% 预处理图像文件夹
pre_processing_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\'};
% 平均之后的图像存储的文件夹
mean_img_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_mean_img\'};

cd(pre_processing_path{1});
subjects = dir('2016*');%=========================================================

%先用一个循环把需要的文件拷贝到mean_img_path文件夹中
for i = 1:size(subjects,1)
     cd(mean_img_path{1});
     mkdir(subjects(i).name);
     cd([pre_processing_path{1},subjects(i).name]);
     SubRuns = dir('ep2d*');
      for j = 1:size(SubRuns,1)
        cd([mean_img_path{1},subjects(i).name]);
        mkdir(SubRuns(j).name);
        cd( [pre_processing_path{1},subjects(i).name,'\',SubRuns(j).name] );
        filter = 's4*';
        copyfile(filter,[mean_img_path{1},subjects(i).name,'\',SubRuns(j).name]);
      end
end
for i = 1:size(subjects,1)
    %cd(mean_img_path{1});
    %mkdir(subjects(i).name);
    cd([pre_processing_path{1},subjects(i).name]);
    SubRuns = dir('ep2d*');%======================================================
    for j = 1:size(SubRuns,1)
        %cd(mean_img_path{1},subjects(i).name);
        %mkdir(SubRuns(j).name);
       cd( [pre_processing_path{1},subjects(i).name,'\',SubRuns(j).name] );
       imgs = dir('s4*.img');
       duration = durations{j};
       
       for k = 1:duration  % 求duration次平均图像，对每一个类别来说
           condition_count = size(onsets,2); % 条件数，这里指JX，DW，RL，ZR

           for m = 1: condition_count
               sub_conditon_count = size(onsets{1,m},2); % 子条件数目，这里是指JX10，JX20，JX11，JX21
               input_img = cell(sub_conditon_count,1);
               % 获得input_img
               for n = 1:sub_conditon_count
                    index = onsets{1,m}(n) + 1;
                    input_img{n} = [pre_processing_path{1},subjects(i).name,'\',SubRuns(j).name,'\',imgs(index).name,',1'];
               end
               % 计算图像的平均值
               ouput_img = [mean_img_path{1},'temp.img'];
               mean_img2(input_img,ouput_img);
               % 创建新的文件夹，用平均图像替换原来的图像，图像的文件名保持不变
               cd(mean_img_path{1});
               for n = 1:sub_conditon_count
                   [path,name,exit] = fileparts(input_img{n}) ;
                   [pathhdr,namehdr,exithdr] = fileparts(ouput_img) ;
                   copyfile(ouput_img,[mean_img_path{1},subjects(i).name,'\',SubRuns(j).name,'\',name,'.img']);
                   copyfile([pathhdr,'\',namehdr,'.hdr'],[mean_img_path{1},subjects(i).name,'\',SubRuns(j).name,'\',name,'.hdr']);
               end
           end
       end
    end
end

