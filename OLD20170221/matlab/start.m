%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=====================
% set path 相关
%=====================
% addpath
% genpath
% rmpath
% savepath
addpath (genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
rmpath(genpath(fullfile(matlab_toolbox_root,'BrainnetomeALL_v1_Beta_20160106')));
savepath;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%=====================
%将行向量转换成对称方阵
%=====================
function b = convert_triangle_vector_to_matrix(v)
% 
vec = [5,9,13,10,14,15];
b=zeros(4);
bw=true(4);
%b(triu(bw,1))=vec;   %上三角用这句
b(tril(bw,-1))=vec;   %下三角用这句

b = b' + b;