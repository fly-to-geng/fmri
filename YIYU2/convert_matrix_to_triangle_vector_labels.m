function map_names = convert_matrix_to_triangle_vector_labels(labels)
% 与convert_matrix_to_triangle_vector匹配的标签转换
%labels = {'s1','s2','s3','s4'};
dim = size(labels,2);
map_names = cell(1,dim*(dim-1)/2);
count = 1;
for i=1:(dim-1)
    for j = i+1:size(labels,2)
        map_names{count} = [labels{j},'->',labels{i}];
        count = count + 1;
    end
end
