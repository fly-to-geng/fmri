% ���ɾ���չ����������֮���Ӧ�ı�ǩ
function names = convert_vector_to_vector(a)

%a = {'s1','s2','s3','s4'};
dim = size(a,2);
names = cell(1,dim*dim);
count = 1;
for i=1:dim
    for j=1:dim
        names{count} = [a{j},'->',a{i}];
        count = count + 1;
    end
end