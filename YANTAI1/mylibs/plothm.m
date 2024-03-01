function plothm(file_path,save_name)
% -------------------------------------------------------------------------
% 功能：根据头动文件画头动图
% 调用：plothm(file_path,save_name)
% 参数：
%   file_path : rp*头动文件绝对路径
%   save_name : 生成图像的名称
% 示例：
%   file_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\pre_processing\20160716002\ep2d_bold_moco_p2_rest_0016\rp_af20160716002-183602-00006-00006-1.txt';
%   save_name = 'd:\realign_run1.png'
% 	plothm(file_path,save_name)
% 说明：需要事先打开SPM的Graph窗口；save_name如果只有名称，则保存在Matlab当前工作目录下，如果提供了绝对路径，则保存为绝对路径指定的地方。
% -------------------------------------------------------------------------
Params = load(file_path);
fg=spm_figure('FindWin','Graphics');
if ~isempty(fg),
    % display results
    % translation and rotation over time series
    %-------------------------------------------------------------------
    spm_figure('Clear','Graphics');
    ax=axes('Position',[0.1 0.65 0.8 0.2],'Parent',fg,'Visible','off');
    set(get(ax,'Title'),'String','Image realignment','FontSize',16,'FontWeight','Bold','Visible','on');
    ax=axes('Position',[0.1 0.35 0.8 0.2],'Parent',fg,'XGrid','on','YGrid','on');
    plot(Params(:,1:3),'Parent',ax)
    s = ['x translation';'y translation';'z translation'];
    %text([2 2 2], Params(2, 1:3), s, 'Fontsize',10,'Parent',ax)
    legend(ax, s, 0)
    set(get(ax,'Title'),'String','translation','FontSize',16,'FontWeight','Bold');
    set(get(ax,'Xlabel'),'String','image');
    set(get(ax,'Ylabel'),'String','mm');


    ax=axes('Position',[0.1 0.05 0.8 0.2],'Parent',fg,'XGrid','on','YGrid','on');
    plot(Params(:,4:6)*180/pi,'Parent',ax)
    s = ['pitch';'roll ';'yaw  '];
    %text([2 2 2], Params(2, 4:6)*180/pi, s, 'Fontsize',10,'Parent',ax)
    legend(ax, s, 0)
    set(get(ax,'Title'),'String','rotation','FontSize',16,'FontWeight','Bold');
    set(get(ax,'Xlabel'),'String','image');
    set(get(ax,'Ylabel'),'String','degrees');

    % print realigment parameters
    spm_print(save_name);
    print(fg,save_name,'-dpng');% 打印出PNG图片，还可以输出其他的格式，参考Matlab的print函数。
end
return;




