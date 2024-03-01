function [AccMap] = searchlight(data_wholebrain1, label)
    AccMap = zeros(61,73,61);  
    count = 0;
    count2 = 0;
  
    for i = 1:61
        for j = 1:73
            for k = 1:61
                %�������һ�½��ȣ����Լ�����һ��
                count = count + 1;
                if mod(count,1000) == 0
                    disp(['=====this is the ', num2str(count), 'th voxels=========']);
                end
                %����ÿһ��7����Ԫ��С��Ԫ
                mask = zeros(61,73,61);
                mask(i,j,k) = 1;
                mask3 = mask(:);%չ����������
                index2 = mask3 == 1;
                dataSet = data_wholebrain1(:,index2);
                if isequal(dataSet, zeros(size(dataSet)))   %���dataSetȫ��0����һ�����صļ���һֱ��0�������˴�ѭ��
                  %  notAccMap(i,j,k) = 0;
                    AccMap(i,j,k) = 0;
                    clear dataSet  index2;
                    continue;
                end
                
                if i+1 <= 61
                    mask(i+1,j,k) = 1;
                end
                if i-1 > 0
                    mask(i-1,j,k) = 1;
                end
                if j+1 <= 73
                    mask(i,j+1,k) = 1;
                end
                if j-1 > 0
                    mask(i,j-1,k) = 1;
                end
                if k+1 <= 61
                    mask(i,j,k+1) = 1;
                end
                if k-1 > 0
                    mask(i,j,k-1) = 1;
                end

                %����ÿһ��С��Ԫ�õ���maskȡ����Ҫ������
                mask2 = mask(:);
                index = mask2 == 1;
                %disp(['===========',num2str(count),'==']);

                dataTest=data_wholebrain1(:,index);% ѡ������1��λ�õ�����
                count2 = count2 + 1;
                if mod(count2,100) == 0
                    disp(['[[[[[[[[[real processed ' , num2str(count2) , ' voxels]]]]]]]]']);
                end

                      AccMap(i,j,k)=svm_classify(dataTest,label);   
                clear dataTest;
            end
        end
    end

end