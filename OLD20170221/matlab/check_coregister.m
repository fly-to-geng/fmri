clear;
clc;

pre_processing_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\';
cd(pre_processing_path); %�������Ԥ����֮����������ڵ�Ŀ¼�� FunImgSWRAF�ļ����������б��Ե����ƣ���
subExpID=dir ('20160927003*'); %�г����б�������
for sub=1:size(subExpID,1)
    cd ([pre_processing_path,subExpID(sub).name]);
    T1_file = dir('t1_*');
    cd([pre_processing_path,subExpID(sub).name,'\',T1_file.name]);
s=spm_get('Files',[cwd,'T1Img/',subExpID(sub).name,'/'],'wms*.img')? % �ҵ��ṹ��T1Img�Ǳ�׼���˵Ľṹ�����ڵ�λ

f=spm_get('Files',[cwd,'FunImgWRAF/',subExpID(sub).name,'/'],'wraf*000001*.
img')? %�ҵ���һ��������
mm=strvcat(s,f)? %��������ṹ������ճ����һ��
spm_check_registration(mm,subExpID(sub).name)? %�ؼ��ĺ����ǳ���
spm_figure('print')? %��ӡ��ps�ļ�
%��ps�ļ�ת����png��ʽ������ֱ���ó��ÿ�ͼ�������
clear dir
psfile=dir('spm*.ps')
eps2xxx(psfile(1).name,{'png'})
psfile2=dir('spm*.png')
delete(psfile(1).name)
delete('spm*')
movefile(psfile2(1).name,['RegistCheck',
subExpID(sub).name,'.png']) %�����ɵ�ͼƬ�ĳɰ������Ա�ŵ�����
movefile(['RegistCheck',
subExpID(sub).name,'.png'],cwd) %������ͼƬ�������ʼ���õ�cwd·����
end