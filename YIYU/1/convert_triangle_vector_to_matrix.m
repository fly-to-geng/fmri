%function b = convert_triangle_vector_to_matrix(v)
% 将行向量转换成对称方阵
vec = [5,9,13,10,14,15];
vec = selected_feature;
b=zeros(246);
bw=true(246);
%b(triu(bw,1))=vec;   %上三角用这句
b(tril(bw,-1))=vec;   %下三角用这句

b = b' + b;
filename = 'brainnetome_function_links_106.txt';
dlmwrite(filename, b);
