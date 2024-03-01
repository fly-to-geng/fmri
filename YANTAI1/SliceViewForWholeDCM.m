function SliceViewForWholeDCM(subject_filter)
first_level_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level_dcm_run_s4\';
cd(first_level_path);
%subject_filter = '2016*';
SubExpID = dir(subject_filter);
for i = 1:size(SubExpID,1)
   cd([first_level_path,SubExpID(i).name]) ;
   JX_path = dir('spmT_0002.img*'); % JX
   DW_path = dir('spmT_0003.img*');
   RL_path = dir('spmT_0004.img*');
   ZR_path = dir('spmT_0005.img*');
    cd(first_level_path);
    if ~exist('result','dir') 
        mkdir('result')         % 若不存在，在当前目录中产生一个子目录‘Figure’
    end 
    cd([first_level_path,'result\']);
    if ~exist('JX','dir')
        mkdir('JX');
    end
     if ~exist('DW','dir')
        mkdir('DW');
     end
     if ~exist('RL','dir')
        mkdir('RL');
     end
     if ~exist('ZR','dir')
        mkdir('ZR');
     end
    save_slice_view([first_level_path,SubExpID(i).name,'\',JX_path.name],[first_level_path,'result\JX\s',SubExpID(i).name,'.png']);
    save_slice_view([first_level_path,SubExpID(i).name,'\',DW_path.name],[first_level_path,'result\DW\s',SubExpID(i).name,'.png']);
    save_slice_view([first_level_path,SubExpID(i).name,'\',RL_path.name],[first_level_path,'result\RL\s',SubExpID(i).name,'.png']);
    save_slice_view([first_level_path,SubExpID(i).name,'\',ZR_path.name],[first_level_path,'result\ZR\s',SubExpID(i).name,'.png']);
end