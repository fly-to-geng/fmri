function []=setcolormap(what)

switch lower(what), case 'gray'
	colormap(gray(64))
case 'hot'
	colormap(hot(64))
case 'pink'
	colormap(pink(64))
case 'gray-hot'
	tmp = hot(64 + 16);  tmp = tmp([1:64] + 16,:);
	colormap([gray(64); tmp])
case 'gray-cold'
	tmp = jet(64 + 48);  tmp = tmp([1:64] + 16,:);
	colormap([gray(64); tmp])    
case 'gray-hot-cold'
	tmp = jet(64 + 16);  tmp = tmp([1:64] + 16,:);
	colormap([gray(64); tmp])
case 'gray-pink'
	tmp = pink(64 + 16); tmp = tmp([1:64] + 16,:);
	colormap([gray(64); tmp])
case 'invert'
	colormap(flipud(colormap))
case 'brighten'
	colormap(brighten(colormap, 0.2))
case 'darken'
	colormap(brighten(colormap, -0.2))
otherwise
	error('Illegal ColAction specification')
end