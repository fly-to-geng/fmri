function [AccMap] = searchlight(data_wholebrain1, label)
    AccMap = zeros(61,73,61);  
    count = 0;
    count2 = 0;
  
    for i = 1:61
        for j = 1:73
            for k = 1:61
                %用来输出一下进度，让自己安心一下
                count = count + 1;
                if mod(count,1000) == 0
                    disp(['=====this is the ', num2str(count), 'th voxels=========']);
                end
                %制作每一个7个体元的小单元
                mask = zeros(61,73,61);
                mask(i,j,k) = 1;
                mask3 = mask(:);%展开成列向量
                index2 = mask3 == 1;
                dataSet = data_wholebrain1(:,index2);
                if isequal(dataSet, zeros(size(dataSet)))   %如果dataSet全是0，（一个体素的激活一直是0）结束此次循环
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

                %利用每一个小单元得到的mask取出需要的数据
                mask2 = mask(:);
                index = mask2 == 1;
                %disp(['===========',num2str(count),'==']);

                dataTest=data_wholebrain1(:,index);% 选出等于1的位置的数据
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