clear;
clc;
filters_cell = '20161215002*';
pres = 's4';
for i=1:size(filters_cell,2)
    smooth(filter,pres);
end
