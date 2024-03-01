function copy_structure(origin_path,destination_path,fileFilter,varargin)
% -------------------------------------------------------------------------
% 功能： 复制目录结构 或者 复制文件
% 调用1：copy_structure(origin_path,destination_path,filter)
% 调用2：copy_structure(origin_path,destination_path,fileFilter,subExpIDFilter)
% 调用3：copy_structure(origin_path,destination_path,fileFilter,subExpIDFilter，runExpIDFilter)
% 参数：
%   origin_path : 要复制的目录结构的绝对路径
%   destination_path : 新文件夹绝对路径
%   subExpIDFilter ：子一级目录通配符
%   runExpIDFilter : 子二级目录通配符
%   fileFilter: 过滤器，决定拷贝哪些文件
% 示例：
%   copy_structure(origin_path,destination_path,'s4w*')
%   copy_structure(origin_path,destination_path,'s4w*','20160916001*')
%   copy_structure(origin_path,destination_path,'s4w*','20160916001*','ep2d_bold_moco_p2_rest_0006*')
% 说明： subExpIDFilter默认值为'2016*';runExpIDFilter 默认值为 'ep2d*'
% --------------------------------------------------------------------------
if nargin < 4
   subExpIDFilter = '2016*';% 被试文件夹通配符 
else
    subExpIDFilter = varargin{1};
end
if nargin < 5
    runExpIDFilter = 'ep2d*';% RUN文件夹通配符
else
    runExpIDFilter = varargin{2};
end
%fileFilter = 'w*';
cd(origin_path);
subExpID=dir(subExpIDFilter); 
for i=1:size(subExpID,1)
    mkdir([destination_path,subExpID(i).name]);
    cd([origin_path,subExpID(i).name]);
    runExpID=dir(runExpIDFilter); 
    for j=1:size(runExpID,1)
        mkdir([destination_path,subExpID(i).name,'\',runExpID(j).name]);
        cd([origin_path,subExpID(i).name,'\',runExpID(j).name]);
        if nargin > 2
            copyfile(fileFilter,[destination_path,subExpID(i).name,'\',runExpID(j).name],'f');
        end
    end
end