filter = {'20170117002*','20170117003*'};
% for i =1:size(filter,2)
%     dicom_import(filter{i});
% end

for i= 1:size(filter,2)
   pre_processing(filter{i}); 
end

for i=1:size(filter,2)
    first_level(filter{i});
end