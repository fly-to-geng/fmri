clear;clc;
% 根据临接阵绘制有向连接图像
% ----------------
% 邻接矩阵的定义
Connections = cell(8,1);
Connections{1} = [0	1	1	1;1	0	1	1;1	1	0	1;1	1	1	0];
Connections{2} = [0	0	1	1;1	0	1	1;1	0	0	1;1	0	1	0];
Connections{3} = [0	1	1	1;0	0	1	1;0	1	0	1;0	1	1	0];
Connections{4} = [0	1	0	0;1	0	0	0;1	1	0	1;1	1	1	0];
Connections{5} = [0	1	1	1;1	0	1	1;1	1	0	0;1	1	0	0];
Connections{6} = [0	0	1	1;1	0	1	1;1	0	0	0;1	0	0	0];
Connections{7} = [0	1	1	1;0	0	1	1;0	1	0	0;0	1	0	0];
Connections{8} = [0	1	0	0;1	0	0	0;1	1	0	0;1	1	0	0];
Connections{9} = [1 1 1 1;1 1 1 1; 1 1 1 1; 1 1 1 1]; % 全连接
% ------------------
% 节点名称的定义
node_names = {'PCC','mPFC','RIPC','LIPC'};

% -----------
% 绘制图像
for i=1:size(Connections,1)
    c = sparse(Connections{i}); %转换成稀疏矩阵形式
    bg = biograph(c,node_names);
    set(bg.nodes,'shape','circle','color',[0.8,0.4,1],'lineColor',[0,0,0],'Size',[2,4]);
    set(bg,'layoutType','radial');
    set(bg.nodes,'textColor',[0,0,0],'lineWidth',1,'fontsize',10);
    set(bg,'arrowSize',5,'edgeFontSize',1);
    get(bg.nodes,'position');
    dolayout(bg);
    bg.nodes(1).position=[70,20];
    bg.nodes(2).position=[70,120];
    bg.nodes(3).position=[120,60];
    bg.nodes(4).position=[20,60];
    dolayout(bg,'pathsonly',true);
    ff = view(bg);
    clear bg c;
end
