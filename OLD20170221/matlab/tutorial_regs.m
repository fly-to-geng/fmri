%生成MVPA中需要的tutorial_regs，表示的是每个TR对应的刺激类别

label = label';
labels = zeros(1,1088);
j = 1;
count = 0;
for i =1:768
   labels(j) = label(i);
   count = count + 1;
   j = j + 1;
   if count == 12
      j = j + 5;
      count = 0;
   end
end
tutorial_regs = zeros(4,1088);
for i=1:1088
    if (labels(i)==1 ||labels(i)==2 ||labels(i)==3 ||labels(i)==4)
        tutorial_regs(1,i) = 1;
    end
    if (labels(i)==5 ||labels(i)==6 ||labels(i)== 7 ||labels(i)==8)
        tutorial_regs(2,i) = 1;
    end
    if (labels(i)==9 ||labels(i)==10 ||labels(i)==11 ||labels(i)==12)
        tutorial_regs(3,i) = 1;
    end
    if (labels(i)==13 ||labels(i)==14 ||labels(i)==15 ||labels(i)==16)
        tutorial_regs(4,i) = 1;
    end
end

save('tutorial_regs.mat','tutorial_regs');