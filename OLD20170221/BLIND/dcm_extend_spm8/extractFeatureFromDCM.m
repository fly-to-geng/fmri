% dcm_model_path  Ҫ��ȡ������DCMģ��
% label   ��ģ�Ͷ�Ӧ�ı�ǩ
function cow = extractFeatureFromDCM(dcm_model_path,label)
load(dcm_model_path);
A = reshape(Ep.A,1, size(Ep.A,1) * size(Ep.A,2));
C = reshape(Ep.C,1,size(Ep.C,1) * size(Ep.C,2));
cow = [label A C];
return;