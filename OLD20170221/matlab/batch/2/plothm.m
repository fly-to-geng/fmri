function plothm(file_path,save_name)

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




