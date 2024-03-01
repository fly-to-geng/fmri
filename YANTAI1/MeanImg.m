% ����ʵ�����
condition_mat_path = 'D:\FMRI_ROOT\YANTAI\DESIGN\conditons_dcm.mat';
load(condition_mat_path);
% ��ȡͼ��

% Ԥ����ͼ���ļ���
pre_processing_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\'};
% ƽ��֮���ͼ��洢���ļ���
mean_img_path = {'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_mean_img\'};

cd(pre_processing_path{1});
subjects = dir('2016*');%=========================================================

%����һ��ѭ������Ҫ���ļ�������mean_img_path�ļ�����
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
       
       for k = 1:duration  % ��duration��ƽ��ͼ�񣬶�ÿһ�������˵
           condition_count = size(onsets,2); % ������������ָJX��DW��RL��ZR

           for m = 1: condition_count
               sub_conditon_count = size(onsets{1,m},2); % ��������Ŀ��������ָJX10��JX20��JX11��JX21
               input_img = cell(sub_conditon_count,1);
               % ���input_img
               for n = 1:sub_conditon_count
                    index = onsets{1,m}(n) + 1;
                    input_img{n} = [pre_processing_path{1},subjects(i).name,'\',SubRuns(j).name,'\',imgs(index).name,',1'];
               end
               % ����ͼ���ƽ��ֵ
               ouput_img = [mean_img_path{1},'temp.img'];
               mean_img2(input_img,ouput_img);
               % �����µ��ļ��У���ƽ��ͼ���滻ԭ����ͼ��ͼ����ļ������ֲ���
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

