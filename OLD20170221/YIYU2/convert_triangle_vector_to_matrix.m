%function b = convert_triangle_vector_to_matrix(v)
% ��������ת���ɶԳƷ���
vec = [5,9,13,10,14,15];
vec = selected_feature;
b=zeros(246);
bw=true(246);
%b(triu(bw,1))=vec;   %�����������
b(tril(bw,-1))=vec;   %�����������

b = b' + b;
filename = 'brainnetome_function_links_106.txt';
dlmwrite(filename, b);
