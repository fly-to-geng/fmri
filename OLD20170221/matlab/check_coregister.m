clear;
clc;

pre_processing_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\';
cd(pre_processing_path); %进入你的预处理之后的数据所在的目录。 FunImgSWRAF文件夹下是所有被试的名称，如
subExpID=dir ('20160927003*'); %列出所有被试名称
for sub=1:size(subExpID,1)
    cd ([pre_processing_path,subExpID(sub).name]);
    T1_file = dir('t1_*');
    cd([pre_processing_path,subExpID(sub).name,'\',T1_file.name]);
s=spm_get('Files',[cwd,'T1Img/',subExpID(sub).name,'/'],'wms*.img')? % 找到结构像。T1Img是标准化了的结构像所在的位

f=spm_get('Files',[cwd,'FunImgWRAF/',subExpID(sub).name,'/'],'wraf*000001*.
img')? %找到第一个功能像。
mm=strvcat(s,f)? %将功能像结构像名字粘贴在一起
spm_check_registration(mm,subExpID(sub).name)? %关键的函数登场了
spm_figure('print')? %打印成ps文件
%将ps文件转换成png格式，就能直接用常用看图软件打开了
clear dir
psfile=dir('spm*.ps')
eps2xxx(psfile(1).name,{'png'})
psfile2=dir('spm*.png')
delete(psfile(1).name)
delete('spm*')
movefile(psfile2(1).name,['RegistCheck',
subExpID(sub).name,'.png']) %给生成的图片改成包含被试编号的名字
movefile(['RegistCheck',
subExpID(sub).name,'.png'],cwd) %将所有图片输出到开始设置的cwd路径下
end