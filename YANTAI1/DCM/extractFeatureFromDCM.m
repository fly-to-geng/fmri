% dcm_model_path  要提取特征的DCM模型
% label   该模型对应的标签
function cow = extractFeatureFromDCM(dcm_model_path,label)
load(dcm_model_path);
A = reshape(Ep.A,1, size(Ep.A,1) * size(Ep.A,2));
C = reshape(Ep.C,1,size(Ep.C,1) * size(Ep.C,2));
cow = [label A C];
return;