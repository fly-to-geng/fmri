function save_slice_view(file_path,save_path)
%--------------------------------------------------------------------------
% 功能：保存激活图像的slice_view图像
% 调用：save_slice_view(file_path,save_path)
% 参数：
%   file_path : spmT图像
%   save_path : 保存的绝对路径，包含文件名
% 示例：
%   file_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\20160911002\spmT_0020.hdr';
%   save_path = 'd:\aaa.png';
%   save_slice_view(file_path,save_path)
% -------------------------------------------------------------------------

%file_path = 'D:\FMRI_ROOT\YANTAI\ANALYSIS\first_level\20160911002\spmT_0020.hdr';
my_xjview(file_path);
hObject = spm_mip_ui('FindMIPax');
eventdata = [];
handles = guidata(hObject);
global sliceview

if(~isfield(sliceview, 'fig') || ~ishandle(sliceview.fig))
    sliceview.viewtype = 't';    
    sliceview.row = 6;
    sliceview.col = 8;
    sliceview.spacing = 4;
    sliceview.page = 1;
    sliceview.data = {{},{},{}}; % t,s,c
    sliceview.slices = {[],[],[]};% t,s,c
    sliceview.colormap = '';
    sliceview.fig = figure('color','k', 'unit','normalized','position',[0.1 0.1 .6 .8],'toolbar','none', 'name', 'xjView slice view', 'NumberTitle','off');
    sliceview.ax = axes('Visible','on','DrawMode','fast','Parent',sliceview.fig,...
    'YDir','normal','Ydir','normal','XTick',[],'YTick',[], 'position', [0.15 0.05 .8 .9]);
    %handles.sliceview.d  = image([],'Tag','Transverse','Parent',handles.sliceview.ax);
    set(sliceview.ax,'XTick',[],'YTick',[]);
    axis equal
    set(sliceview.ax,'color','k');
    %setcolormap(colormp)
    width = 0.05;
    height = 0.025;
    step = 0.025;
    labeloffset = step/2;
end

slicegraph = figure(sliceview.fig);

viewtype =    sliceview.viewtype;   
row =         sliceview.row;
col =         sliceview.col;
spacing =     sliceview.spacing;
page =        sliceview.page;
slice_fig = sliceview.fig;
ax = sliceview.ax;
%d = handles.sliceview.d;

[slicedata, colormp, slices] = cuixu_getSliceViewData(viewtype,row,col, spacing, page);

if isempty(slices)
    return;
end

for ii=1:length(slices)
    if(viewtype == 's')
        postmp = find(slices(ii) - sliceview.slices{2} == 0);
        if(isempty(postmp))
            sliceview.data{2}{end+1} = slicedata{ii};
            sliceview.slices{2}(end+1) = slices(ii);
        end   
    elseif(viewtype == 't')
        postmp = find(slices(ii) - sliceview.slices{1} == 0);
        if(isempty(postmp))
            sliceview.data{1}{end+1} = slicedata{ii};
            sliceview.slices{1}(end+1) = slices(ii);
        end    
    elseif(viewtype == 'c')
        postmp = find(slices(ii) - sliceview.slices{3} == 0);
        if(isempty(postmp))
            sliceview.data{3}{end+1} = slicedata{ii};
            sliceview.slices{3}(end+1) = slices(ii);
        end   
    end  
    
end



%slice_fig = figure('color','k', 'unit','normalized','position',[0.1 0.1 .6 .8],'toolbar','none');


if(length(size(slicedata{1})) == 3)
    [nx, ny, nz] = size(slicedata{1});
    slicedatafinal = zeros(nx*row, ny*col, nz );
    for ii=1:length(slicedata)
        slicedatafinal(nx*(floor((ii-1)/col))+1:nx*(1+floor((ii-1)/col)), ny*(mod(ii-1,col))+1:ny*(mod(ii-1,col)+1), :) = slicedata{ii};
    end
else
    [nx, ny] = size(slicedata{1});
    slicedatafinal = zeros(nx*row, ny*col );
    for ii=1:length(slicedata)
        slicedatafinal(nx*(floor((ii-1)/col))+1:nx*(1+floor((ii-1)/col)), ny*(mod(ii-1,col))+1:ny*(mod(ii-1,col)+1)) = slicedata{ii};
    end
end


try
    delete(handles.sliceview.d)
catch
    [];
end

handles.sliceview.d  = image(slicedatafinal,'Tag','Transverse','Parent',sliceview.ax);

% put slice positions
for ii=1:length(slicedata)
    %text(nx*(floor((ii-1)/col))+1:nx*(1+floor((ii-1)/col)), ny*(mod(ii-1,col))+1:ny*(mod(ii-1,col)+1), num2str(slices(ii)), 'color', 'w');
    text(ny*(mod(ii-1,col))+1, nx*(floor((ii-1)/col))+1+20, num2str(slices(ii)), 'color', 'w');
end
set(sliceview.ax,'XTick',[],'YTick',[]);
axis(sliceview.ax, 'equal');
set(sliceview.ax,'color','k');
guidata(hObject, handles);

%print(handles.figure,'bbb','-dpng');  % 保存主窗口图像
print(slicegraph,save_path,'-dpng');  % 保存slice_view图像
close(slicegraph);
close(handles.figure);
clc;

