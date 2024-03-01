subjects = {'sub1028*','sub1029*'};
for i = 1 : size(subjects,2)
    disp((subjects{i}));
    pre_processing_yy(subjects{i});
end
