function v = convert_matrix_to_triangle_vector(m)
% ���ԳƷ���ȡ�����Ǿ���չ�������������������Խ��ߡ�
%m = [1,2,3,4;5,6,7,8;9,10,11,12;13,14,15,16];
n = size(m,1);
len = n*(n-1)/2;
v = cell(1,len);
a = tril(m,-1);% ������
count = 1;
for i=1:n-1
   for j=i+1:n
       v{count} = a(j,i);
       count = count + 1;
   end
end
v = cell2mat(v);