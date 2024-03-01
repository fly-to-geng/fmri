function [slicedata, colormp, slices] = cuixu_getSliceViewData(viewtype,row,col, spacing,page)

global sliceview


slicedata = {};
pos = {};
slices = -80+(page-1)*spacing*col:spacing:100+(page)*spacing;

if(isempty(slices))
    colormp = '';
    return
end

global st
bb   = st.bb;
Dims = round(diff(bb)'+1);
is   = inv(st.Space);
cent = is(1:3,1:3)*st.centre(:) + is(1:3,4);

kk = 1;
for slice = slices
    if(kk > row*col)
        slices = slices(1:kk-1);
        break;
    end
    
if(viewtype == 's')
    cent(2) = -slice;
    postmp = find(slice - sliceview.slices{2} == 0);
    if(~isempty(postmp))
        slicedata{kk} = sliceview.data{2}{postmp(1)};
        kk = kk+1;
        continue;
    end
elseif(viewtype == 't')
    cent(3) = slice;
    postmp = find(slice - sliceview.slices{1} == 0);
    if(~isempty(postmp))
        slicedata{kk} = sliceview.data{1}{postmp(1)};
        kk = kk+1;
        continue;
    end
elseif(viewtype == 'c')
    cent(1) = slice;
    postmp = find(slice - sliceview.slices{3} == 0);
    if(~isempty(postmp))
        slicedata{kk} = sliceview.data{3}{postmp(1)};
        kk = kk+1;
        continue;
    end
end       

if(viewtype == 's')

for i = 1
	M = st.vols{i}.premul*st.vols{i}.mat;


	CM0 = [	1 0 0 -bb(1,1)+1
		0 0 1 -bb(1,3)+1
		0 1 0 -cent(2)
		0 0 0 1];
	CM = inv(CM0*(st.Space\M));
	CD = Dims([1 3]);



	ok=1;
   
    eval('imgc  = (spm_slice_vol(st.vols{i},CM,CD,st.hld))'';','ok=0;');

	if (ok==0), fprintf('Image "%s" can not be resampled\n', st.vols{i}.fname);
	else,
                % get min/max threshold
                if strcmp(st.vols{i}.window,'auto')
                        mn = -Inf;
                        mx = Inf;
                else
                        mn = min(st.vols{i}.window);
                        mx = max(st.vols{i}.window);
                end;
                % threshold images
                imgc = max(imgc,mn); imgc = min(imgc,mx);
                % compute intensity mapping, if histeq is available
                if license('test','image_toolbox') == 0
                    st.vols{i}.mapping = 'linear';
                end;
                switch st.vols{i}.mapping,
                 case 'linear',
                 case 'histeq',
                  % scale images to a range between 0 and 1
                  imgc1=(imgc-min(imgc(:)))/(max(imgc(:)-min(imgc(:)))+eps);
                  img  = histeq([imgt1(:); imgc1(:); imgs1(:)],1024);
                  imgc = reshape(img(numel(imgt1)+[1:numel(imgc1)]),size(imgc1));
                  mn = 0;
                  mx = 1;
                 case 'quadhisteq',
                  % scale images to a range between 0 and 1
                  imgt1=(imgt-min(imgt(:)))/(max(imgt(:)-min(imgt(:)))+eps);
                  imgc1=(imgc-min(imgc(:)))/(max(imgc(:)-min(imgc(:)))+eps);
                  imgs1=(imgs-min(imgs(:)))/(max(imgs(:)-min(imgs(:)))+eps);
                  img  = histeq([imgt1(:).^2; imgc1(:).^2; imgs1(:).^2],1024);
                  imgt = reshape(img(1:numel(imgt1)),size(imgt1));
                  imgc = reshape(img(numel(imgt1)+[1:numel(imgc1)]),size(imgc1));
                  imgs = reshape(img(numel(imgt1)+numel(imgc1)+[1:numel(imgs1)]),size(imgs1));
                  mn = 0;
                  mx = 1;
                 case 'loghisteq',
                  warning off % messy - but it may avoid extra queries
                  imgt = log(imgt-min(imgt(:)));
                  imgc = log(imgc-min(imgc(:)));
                  imgs = log(imgs-min(imgs(:)));
                  warning on
                  imgt(~isfinite(imgt)) = 0;
                  imgc(~isfinite(imgc)) = 0;
                  imgs(~isfinite(imgs)) = 0;
                  % scale log images to a range between 0 and 1
                  imgt1=(imgt-min(imgt(:)))/(max(imgt(:)-min(imgt(:)))+eps);
                  imgc1=(imgc-min(imgc(:)))/(max(imgc(:)-min(imgc(:)))+eps);
                  imgs1=(imgs-min(imgs(:)))/(max(imgs(:)-min(imgs(:)))+eps);
                  img  = histeq([imgt1(:); imgc1(:); imgs1(:)],1024);
                  imgt = reshape(img(1:numel(imgt1)),size(imgt1));
                  imgc = reshape(img(numel(imgt1)+[1:numel(imgc1)]),size(imgc1));
                  imgs = reshape(img(numel(imgt1)+numel(imgc1)+[1:numel(imgs1)]),size(imgs1));
                  mn = 0;
                  mx = 1;
                end;
                % recompute min/max for display
                if strcmp(st.vols{i}.window,'auto')
                    mx = -inf; mn = inf;
                end;
                
                if ~isempty(imgc),
			tmp = imgc(isfinite(imgc));
                        mx = max([mx max(max(tmp))]);
                        mn = min([mn min(min(tmp))]);
                end;
                
                if mx==mn, mx=mn+eps; end;

		if isfield(st.vols{i},'blobs'),
			if ~isfield(st.vols{i}.blobs{1},'colour'),
				% Add blobs for display using the split colourmap
				scal = 64/(mx-mn);
				dcoff = -mn*scal;
				imgc = imgc*scal+dcoff;

				if isfield(st.vols{i}.blobs{1},'max'),
					mx = st.vols{i}.blobs{1}.max;
				else,
					mx = max([eps maxval(st.vols{i}.blobs{1}.vol)]);
					st.vols{i}.blobs{1}.max = mx;
				end;
				if isfield(st.vols{i}.blobs{1},'min'),
					mn = st.vols{i}.blobs{1}.min;
				else,
					mn = min([0 minval(st.vols{i}.blobs{1}.vol)]);
					st.vols{i}.blobs{1}.min = mn;
				end;

				vol  = st.vols{i}.blobs{1}.vol;
				M    = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;

                tmpc = spm_slice_vol(vol,inv(CM0*(st.Space\M)),CD,[0 NaN])';

				

				%tmpt_z = find(tmpt==0);tmpt(tmpt_z) = NaN;
				%tmpc_z = find(tmpc==0);tmpc(tmpc_z) = NaN;
				%tmps_z = find(tmps==0);tmps(tmps_z) = NaN;

				sc   = 64/(mx-mn);
				off  = 65.51-mn*sc;
				msk  = find(isfinite(tmpc)); imgc(msk) = off+tmpc(msk)*sc;

				cmap = get(st.fig,'Colormap');

                %figure(st.fig)
                if mn*mx < 0
                    setcolormap('gray-hot-cold')                    
                elseif mx > 0
                    setcolormap('gray-hot');
                else
                    setcolormap('gray-cold')
                end                
                %                redraw_colourbar(i,1,[mn mx],[1:64]'+64); 
			elseif isstruct(st.vols{i}.blobs{1}.colour),
				% Add blobs for display using a defined
                                % colourmap

				% colourmaps
				gryc = [0:63]'*ones(1,3)/63;
				actc = ...
				    st.vols{1}.blobs{1}.colour.cmap;
				actp = ...
				    st.vols{1}.blobs{1}.colour.prop;
				
				% scale grayscale image, not finite -> black
				imgc = scaletocmap(imgc,mn,mx,gryc,65);
				gryc = [gryc; 0 0 0];
				
				% get max for blob image
				vol = st.vols{i}.blobs{1}.vol;
				mat = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;
				if isfield(st.vols{i}.blobs{1},'max'),
					cmx = st.vols{i}.blobs{1}.max;
				else,
					cmx = max([eps maxval(st.vols{i}.blobs{1}.vol)]);
				end;
				if isfield(st.vols{i}.blobs{1},'min'),
					cmn = st.vols{i}.blobs{1}.min;
				else,
					cmn = -cmx;
				end;

				% get blob data
				vol  = st.vols{i}.blobs{1}.vol;
				M    = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;
				tmpc = spm_slice_vol(vol,inv(CM0*(st.Space\M)),CD,[0 NaN])';
				
				% actimg scaled round 0, black NaNs
				topc = size(actc,1)+1;
				tmpc = scaletocmap(tmpc,cmn,cmx,actc,topc);
				actc = [actc; 0 0 0];
				
				% combine gray and blob data to
				% truecolour
				imgc = reshape(actc(tmpc(:),:)*actp+ ...
					       gryc(imgc(:),:)*(1-actp), ...
					       [size(imgc) 3]);
				
				
			else,
				% Add full colour blobs - several sets at once
				scal  = 1/(mx-mn);
				dcoff = -mn*scal;

				wc = zeros(size(imgc));

				imgc  = repmat(imgc*scal+dcoff,[1,1,3]);

				cimgc = zeros(size(imgc));

				for j=1:length(st.vols{i}.blobs), % get colours of all images first
					if isfield(st.vols{i}.blobs{j},'colour'),
						colour(j,:) = reshape(st.vols{i}.blobs{j}.colour, [1 3]);
					else,
						colour(j,:) = [1 0 0];
					end;
				end;
				%colour = colour/max(sum(colour));

				for j=1:length(st.vols{i}.blobs),
					if isfield(st.vols{i}.blobs{j},'max'),
						mx = st.vols{i}.blobs{j}.max;
					else,
						mx = max([eps max(st.vols{i}.blobs{j}.vol(:))]);
						st.vols{i}.blobs{j}.max = mx;
					end;
					if isfield(st.vols{i}.blobs{j},'min'),
						mn = st.vols{i}.blobs{j}.min;
					else,
						mn = min([0 min(st.vols{i}.blobs{j}.vol(:))]);
						st.vols{i}.blobs{j}.min = mn;
					end;

					vol  = st.vols{i}.blobs{j}.vol;
					M    = st.Space\st.vols{i}.premul*st.vols{i}.blobs{j}.mat;
                    tmpc = spm_slice_vol(vol,inv(CM0*M),CD,[0 NaN])';
                    % check min/max of sampled image
                    % against mn/mx as given in st
                    tmpc(tmpc(:)<mn) = mn;
                    tmpc(tmpc(:)>mx) = mx;
					tmpc = (tmpc-mn)/(mx-mn);
					tmpc(~isfinite(tmpc)) = 0;

					cimgc = cimgc + cat(3,tmpc*colour(j,1),tmpc*colour(j,2),tmpc*colour(j,3));

					wc = wc + tmpc;
                                        cdata=permute(shiftdim([1/64:1/64:1]'* ...
                                                               colour(j,:),-1),[2 1 3]);
                                        redraw_colourbar(i,j,[mn mx],cdata);
				end;

				imgc = repmat(1-wc,[1 1 3]).*imgc+cimgc;

				imgc(imgc<0)=0; imgc(imgc>1)=1;
			end;
		else,
			scal = 64/(mx-mn);
			dcoff = -mn*scal;
			imgc = imgc*scal+dcoff;
		end;

% 		set(st.vols{i}.ax{1}.d,'HitTest','off', 'Cdata',imgt);
% 		set(st.vols{i}.ax{1}.lx,'HitTest','off',...
% 			'Xdata',[0 TD(1)]+0.5,'Ydata',[1 1]*(cent(2)-bb(1,2)+1));
% 		set(st.vols{i}.ax{1}.ly,'HitTest','off',...
% 			'Ydata',[0 TD(2)]+0.5,'Xdata',[1 1]*(cent(1)-bb(1,1)+1));
% 
% 		set(st.vols{i}.ax{2}.d,'HitTest','off', 'Cdata',imgc);
% 		set(st.vols{i}.ax{2}.lx,'HitTest','off',...
% 			'Xdata',[0 CD(1)]+0.5,'Ydata',[1 1]*(cent(3)-bb(1,3)+1));
% 		set(st.vols{i}.ax{2}.ly,'HitTest','off',...
% 			'Ydata',[0 CD(2)]+0.5,'Xdata',[1 1]*(cent(1)-bb(1,1)+1));
% 
% 		set(st.vols{i}.ax{3}.d,'HitTest','off','Cdata',imgs);
% 		if st.mode ==0,
% 			set(st.vols{i}.ax{3}.lx,'HitTest','off',...
% 				'Xdata',[0 SD(1)]+0.5,'Ydata',[1 1]*(cent(2)-bb(1,2)+1));
% 			set(st.vols{i}.ax{3}.ly,'HitTest','off',...
% 				'Ydata',[0 SD(2)]+0.5,'Xdata',[1 1]*(cent(3)-bb(1,3)+1));
% 		else,
% 			set(st.vols{i}.ax{3}.lx,'HitTest','off',...
% 				'Xdata',[0 SD(1)]+0.5,'Ydata',[1 1]*(cent(3)-bb(1,3)+1));
% 			set(st.vols{i}.ax{3}.ly,'HitTest','off',...
% 				'Ydata',[0 SD(2)]+0.5,'Xdata',[1 1]*(bb(2,2)+1-cent(2)));
% 		end;


	end;
end;

elseif(viewtype == 't')

for i = 1
	M = st.vols{i}.premul*st.vols{i}.mat;
	TM0 = [	1 0 0 -bb(1,1)+1
		0 1 0 -bb(1,2)+1
		0 0 1 -cent(3)
		0 0 0 1];
	TM = inv(TM0*(st.Space\M));
	TD = Dims([1 2]);



	ok=1;
    eval('imgt  = (spm_slice_vol(st.vols{i},TM,TD,st.hld))'';','ok=0;');

	if (ok==0), fprintf('Image "%s" can not be resampled\n', st.vols{i}.fname);
	else,
                % get min/max threshold
                if strcmp(st.vols{i}.window,'auto')
                        mn = -Inf;
                        mx = Inf;
                else
                        mn = min(st.vols{i}.window);
                        mx = max(st.vols{i}.window);
                end;
                % threshold images
                imgt = max(imgt,mn); imgt = min(imgt,mx);
                % compute intensity mapping, if histeq is available
                if license('test','image_toolbox') == 0
                    st.vols{i}.mapping = 'linear';
                end;
                switch st.vols{i}.mapping,
                 case 'linear',
                 case 'histeq',
                  % scale images to a range between 0 and 1
                  imgt1=(imgt-min(imgt(:)))/(max(imgt(:)-min(imgt(:)))+eps);
                  img  = histeq([imgt1(:); imgc1(:); imgs1(:)],1024);
                  imgt = reshape(img(1:numel(imgt1)),size(imgt1));
                  mn = 0;
                  mx = 1;
                 case 'quadhisteq',
                  % scale images to a range between 0 and 1
                  imgt1=(imgt-min(imgt(:)))/(max(imgt(:)-min(imgt(:)))+eps);
                  imgc1=(imgc-min(imgc(:)))/(max(imgc(:)-min(imgc(:)))+eps);
                  imgs1=(imgs-min(imgs(:)))/(max(imgs(:)-min(imgs(:)))+eps);
                  img  = histeq([imgt1(:).^2; imgc1(:).^2; imgs1(:).^2],1024);
                  imgt = reshape(img(1:numel(imgt1)),size(imgt1));
                  imgc = reshape(img(numel(imgt1)+[1:numel(imgc1)]),size(imgc1));
                  imgs = reshape(img(numel(imgt1)+numel(imgc1)+[1:numel(imgs1)]),size(imgs1));
                  mn = 0;
                  mx = 1;
                 case 'loghisteq',
                  warning off % messy - but it may avoid extra queries
                  imgt = log(imgt-min(imgt(:)));
                  imgc = log(imgc-min(imgc(:)));
                  imgs = log(imgs-min(imgs(:)));
                  warning on
                  imgt(~isfinite(imgt)) = 0;
                  imgc(~isfinite(imgc)) = 0;
                  imgs(~isfinite(imgs)) = 0;
                  % scale log images to a range between 0 and 1
                  imgt1=(imgt-min(imgt(:)))/(max(imgt(:)-min(imgt(:)))+eps);
                  imgc1=(imgc-min(imgc(:)))/(max(imgc(:)-min(imgc(:)))+eps);
                  imgs1=(imgs-min(imgs(:)))/(max(imgs(:)-min(imgs(:)))+eps);
                  img  = histeq([imgt1(:); imgc1(:); imgs1(:)],1024);
                  imgt = reshape(img(1:numel(imgt1)),size(imgt1));
                  imgc = reshape(img(numel(imgt1)+[1:numel(imgc1)]),size(imgc1));
                  imgs = reshape(img(numel(imgt1)+numel(imgc1)+[1:numel(imgs1)]),size(imgs1));
                  mn = 0;
                  mx = 1;
                end;
                % recompute min/max for display
                if strcmp(st.vols{i}.window,'auto')
                    mx = -inf; mn = inf;
                end;
                if ~isempty(imgt),
			tmp = imgt(isfinite(imgt));
                        mx = max([mx max(max(tmp))]);
                        mn = min([mn min(min(tmp))]);
                end;
                
                if mx==mn, mx=mn+eps; end;

		if isfield(st.vols{i},'blobs'),
			if ~isfield(st.vols{i}.blobs{1},'colour'),
				% Add blobs for display using the split colourmap
				scal = 64/(mx-mn);
				dcoff = -mn*scal;
				imgt = imgt*scal+dcoff;

				if isfield(st.vols{i}.blobs{1},'max'),
					mx = st.vols{i}.blobs{1}.max;
				else,
					mx = max([eps maxval(st.vols{i}.blobs{1}.vol)]);
					st.vols{i}.blobs{1}.max = mx;
				end;
				if isfield(st.vols{i}.blobs{1},'min'),
					mn = st.vols{i}.blobs{1}.min;
				else,
					mn = min([0 minval(st.vols{i}.blobs{1}.vol)]);
					st.vols{i}.blobs{1}.min = mn;
				end;

				vol  = st.vols{i}.blobs{1}.vol;
				M    = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;
                
                tmpt = spm_slice_vol(vol,inv(TM0*(st.Space\M)),TD,[0 NaN])';


				%tmpt_z = find(tmpt==0);tmpt(tmpt_z) = NaN;
				%tmpc_z = find(tmpc==0);tmpc(tmpc_z) = NaN;
				%tmps_z = find(tmps==0);tmps(tmps_z) = NaN;

				sc   = 64/(mx-mn);
				off  = 65.51-mn*sc;
				msk  = find(isfinite(tmpt)); imgt(msk) = off+tmpt(msk)*sc;

				cmap = get(st.fig,'Colormap');

                %figure(st.fig)
                if mn*mx < 0
                    setcolormap('gray-hot-cold')                    
                elseif mx > 0
                    setcolormap('gray-hot');
                else
                    setcolormap('gray-cold')
                end                
                %                redraw_colourbar(i,1,[mn mx],[1:64]'+64); 
			elseif isstruct(st.vols{i}.blobs{1}.colour),
				% Add blobs for display using a defined
                                % colourmap

				% colourmaps
				gryc = [0:63]'*ones(1,3)/63;
				actc = ...
				    st.vols{1}.blobs{1}.colour.cmap;
				actp = ...
				    st.vols{1}.blobs{1}.colour.prop;
				
				% scale grayscale image, not finite -> black
				imgt = scaletocmap(imgt,mn,mx,gryc,65);
				gryc = [gryc; 0 0 0];
				
				% get max for blob image
				vol = st.vols{i}.blobs{1}.vol;
				mat = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;
				if isfield(st.vols{i}.blobs{1},'max'),
					cmx = st.vols{i}.blobs{1}.max;
				else,
					cmx = max([eps maxval(st.vols{i}.blobs{1}.vol)]);
				end;
				if isfield(st.vols{i}.blobs{1},'min'),
					cmn = st.vols{i}.blobs{1}.min;
				else,
					cmn = -cmx;
				end;

				% get blob data
				vol  = st.vols{i}.blobs{1}.vol;
				M    = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;
				tmpt = spm_slice_vol(vol,inv(TM0*(st.Space\M)),TD,[0 NaN])';
				
				% actimg scaled round 0, black NaNs
				topc = size(actc,1)+1;
				tmpt = scaletocmap(tmpt,cmn,cmx,actc,topc);
				actc = [actc; 0 0 0];
				
				% combine gray and blob data to
				% truecolour
				imgt = reshape(actc(tmpt(:),:)*actp+ ...
					       gryc(imgt(:),:)*(1-actp), ...
					       [size(imgt) 3]);
% 				
%                                 redraw_colourbar(i,1,[cmn cmx],[1:64]'+64); 
				
			else,
				% Add full colour blobs - several sets at once
				scal  = 1/(mx-mn);
				dcoff = -mn*scal;

				wt = zeros(size(imgt));

				imgt  = repmat(imgt*scal+dcoff,[1,1,3]);

				cimgt = zeros(size(imgt));

				for j=1:length(st.vols{i}.blobs), % get colours of all images first
					if isfield(st.vols{i}.blobs{j},'colour'),
						colour(j,:) = reshape(st.vols{i}.blobs{j}.colour, [1 3]);
					else,
						colour(j,:) = [1 0 0];
					end;
				end;
				%colour = colour/max(sum(colour));

				for j=1:length(st.vols{i}.blobs),
					if isfield(st.vols{i}.blobs{j},'max'),
						mx = st.vols{i}.blobs{j}.max;
					else,
						mx = max([eps max(st.vols{i}.blobs{j}.vol(:))]);
						st.vols{i}.blobs{j}.max = mx;
					end;
					if isfield(st.vols{i}.blobs{j},'min'),
						mn = st.vols{i}.blobs{j}.min;
					else,
						mn = min([0 min(st.vols{i}.blobs{j}.vol(:))]);
						st.vols{i}.blobs{j}.min = mn;
					end;

					vol  = st.vols{i}.blobs{j}.vol;
					M    = st.Space\st.vols{i}.premul*st.vols{i}.blobs{j}.mat;
                    tmpt = spm_slice_vol(vol,inv(TM0*M),TD,[0 NaN])';
                    % check min/max of sampled image
                    % against mn/mx as given in st
                    tmpt(tmpt(:)<mn) = mn;
                    tmpt(tmpt(:)>mx) = mx;
                    tmpt = (tmpt-mn)/(mx-mn);
					tmpt(~isfinite(tmpt)) = 0;

					cimgt = cimgt + cat(3,tmpt*colour(j,1),tmpt*colour(j,2),tmpt*colour(j,3));

					wt = wt + tmpt;
                                        cdata=permute(shiftdim([1/64:1/64:1]'* ...
                                                               colour(j,:),-1),[2 1 3]);
                                        %redraw_colourbar(i,j,[mn mx],cdata);
				end;

				imgt = repmat(1-wt,[1 1 3]).*imgt+cimgt;

				imgt(imgt<0)=0; imgt(imgt>1)=1;
			end;
		else,
			scal = 64/(mx-mn);
			dcoff = -mn*scal;
			imgt = imgt*scal+dcoff;
		end;

% 		set(st.vols{i}.ax{1}.d,'HitTest','off', 'Cdata',imgt);
% 		set(st.vols{i}.ax{1}.lx,'HitTest','off',...
% 			'Xdata',[0 TD(1)]+0.5,'Ydata',[1 1]*(cent(2)-bb(1,2)+1));
% 		set(st.vols{i}.ax{1}.ly,'HitTest','off',...
% 			'Ydata',[0 TD(2)]+0.5,'Xdata',[1 1]*(cent(1)-bb(1,1)+1));
% 
% 		set(st.vols{i}.ax{2}.d,'HitTest','off', 'Cdata',imgc);
% 		set(st.vols{i}.ax{2}.lx,'HitTest','off',...
% 			'Xdata',[0 CD(1)]+0.5,'Ydata',[1 1]*(cent(3)-bb(1,3)+1));
% 		set(st.vols{i}.ax{2}.ly,'HitTest','off',...
% 			'Ydata',[0 CD(2)]+0.5,'Xdata',[1 1]*(cent(1)-bb(1,1)+1));
% 
% 		set(st.vols{i}.ax{3}.d,'HitTest','off','Cdata',imgs);
% 		if st.mode ==0,
% 			set(st.vols{i}.ax{3}.lx,'HitTest','off',...
% 				'Xdata',[0 SD(1)]+0.5,'Ydata',[1 1]*(cent(2)-bb(1,2)+1));
% 			set(st.vols{i}.ax{3}.ly,'HitTest','off',...
% 				'Ydata',[0 SD(2)]+0.5,'Xdata',[1 1]*(cent(3)-bb(1,3)+1));
% 		else,
% 			set(st.vols{i}.ax{3}.lx,'HitTest','off',...
% 				'Xdata',[0 SD(1)]+0.5,'Ydata',[1 1]*(cent(3)-bb(1,3)+1));
% 			set(st.vols{i}.ax{3}.ly,'HitTest','off',...
% 				'Ydata',[0 SD(2)]+0.5,'Xdata',[1 1]*(bb(2,2)+1-cent(2)));
% 		end;


	end;
end;

elseif(viewtype == 'c')
    
for i = 1
	M = st.vols{i}.premul*st.vols{i}.mat;
	

	if st.mode ==0,
		SM0 = [	0 0 1 -bb(1,3)+1
			0 1 0 -bb(1,2)+1
			1 0 0 -cent(1)
			0 0 0 1];
		SM = inv(SM0*(st.Space\M)); SD = Dims([3 2]);
	else,
		SM0 = [	0  1 0 -bb(1,2)+1
			0  0 1 -bb(1,3)+1
			1  0 0 -cent(1)
			0  0 0 1];
		SM0 = [	0 -1 0 +bb(2,2)+1
			0  0 1 -bb(1,3)+1
			1  0 0 -cent(1)
			0  0 0 1];
		SM = inv(SM0*(st.Space\M));
		SD = Dims([2 3]);
	end;

	ok=1;

        eval('imgs  = (spm_slice_vol(st.vols{i},SM,SD,st.hld))'';','ok=0;');
    
	if (ok==0), fprintf('Image "%s" can not be resampled\n', st.vols{i}.fname);
	else,
                % get min/max threshold
                if strcmp(st.vols{i}.window,'auto')
                        mn = -Inf;
                        mx = Inf;
                else
                        mn = min(st.vols{i}.window);
                        mx = max(st.vols{i}.window);
                end;
                % threshold images
                imgs = max(imgs,mn); imgs = min(imgs,mx);
                % compute intensity mapping, if histeq is available
                if license('test','image_toolbox') == 0
                    st.vols{i}.mapping = 'linear';
                end;
                switch st.vols{i}.mapping,
                 case 'linear',
                 case 'histeq',
                  % scale images to a range between 0 and 1
                  imgs1=(imgs-min(imgs(:)))/(max(imgs(:)-min(imgs(:)))+eps);
                  img  = histeq([imgt1(:); imgc1(:); imgs1(:)],1024);
                  imgs = reshape(img(numel(imgt1)+numel(imgc1)+[1:numel(imgs1)]),size(imgs1));
                  mn = 0;
                  mx = 1;
                 case 'quadhisteq',
                  % scale images to a range between 0 and 1
                  imgs1=(imgs-min(imgs(:)))/(max(imgs(:)-min(imgs(:)))+eps);
                  img  = histeq([imgt1(:).^2; imgc1(:).^2; imgs1(:).^2],1024);
                  imgs = reshape(img(numel(imgt1)+numel(imgc1)+[1:numel(imgs1)]),size(imgs1));
                  mn = 0;
                  mx = 1;
                 case 'loghisteq',
                  warning off % messy - but it may avoid extra queries
                  imgs = log(imgs-min(imgs(:)));
                  warning on
                  imgs(~isfinite(imgs)) = 0;
                  % scale log images to a range between 0 and 1
                  imgs1=(imgs-min(imgs(:)))/(max(imgs(:)-min(imgs(:)))+eps);
                  img  = histeq([imgt1(:); imgc1(:); imgs1(:)],1024);
                  imgs = reshape(img(numel(imgt1)+numel(imgc1)+[1:numel(imgs1)]),size(imgs1));
                  mn = 0;
                  mx = 1;
                end;
                % recompute min/max for display
                if strcmp(st.vols{i}.window,'auto')
                    mx = -inf; mn = inf;
                end;
                
                if ~isempty(imgs),
			tmp = imgs(isfinite(imgs));
                        mx = max([mx max(max(tmp))]);
                        mn = min([mn min(min(tmp))]);
                end;
                if mx==mn, mx=mn+eps; end;

		if isfield(st.vols{i},'blobs'),
			if ~isfield(st.vols{i}.blobs{1},'colour'),
				% Add blobs for display using the split colourmap
				scal = 64/(mx-mn);
				dcoff = -mn*scal;
				imgs = imgs*scal+dcoff;

				if isfield(st.vols{i}.blobs{1},'max'),
					mx = st.vols{i}.blobs{1}.max;
				else,
					mx = max([eps maxval(st.vols{i}.blobs{1}.vol)]);
					st.vols{i}.blobs{1}.max = mx;
				end;
				if isfield(st.vols{i}.blobs{1},'min'),
					mn = st.vols{i}.blobs{1}.min;
				else,
					mn = min([0 minval(st.vols{i}.blobs{1}.vol)]);
					st.vols{i}.blobs{1}.min = mn;
				end;

				vol  = st.vols{i}.blobs{1}.vol;
				M    = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;

                tmps = spm_slice_vol(vol,inv(SM0*(st.Space\M)),SD,[0 NaN])';

				

				%tmpt_z = find(tmpt==0);tmpt(tmpt_z) = NaN;
				%tmpc_z = find(tmpc==0);tmpc(tmpc_z) = NaN;
				%tmps_z = find(tmps==0);tmps(tmps_z) = NaN;

				sc   = 64/(mx-mn);
				off  = 65.51-mn*sc;
				msk  = find(isfinite(tmps)); imgs(msk) = off+tmps(msk)*sc;

				cmap = get(st.fig,'Colormap');

                %figure(st.fig)
                if mn*mx < 0
                    setcolormap('gray-hot-cold')                    
                elseif mx > 0
                    setcolormap('gray-hot');
                else
                    setcolormap('gray-cold')
                end                
                %                redraw_colourbar(i,1,[mn mx],[1:64]'+64); 
			elseif isstruct(st.vols{i}.blobs{1}.colour),
				% Add blobs for display using a defined
                                % colourmap

				% colourmaps
				gryc = [0:63]'*ones(1,3)/63;
				actc = ...
				    st.vols{1}.blobs{1}.colour.cmap;
				actp = ...
				    st.vols{1}.blobs{1}.colour.prop;
				
				% scale grayscale image, not finite -> black
				imgs = scaletocmap(imgs,mn,mx,gryc,65);
				gryc = [gryc; 0 0 0];
				
				% get max for blob image
				vol = st.vols{i}.blobs{1}.vol;
				mat = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;
				if isfield(st.vols{i}.blobs{1},'max'),
					cmx = st.vols{i}.blobs{1}.max;
				else,
					cmx = max([eps maxval(st.vols{i}.blobs{1}.vol)]);
				end;
				if isfield(st.vols{i}.blobs{1},'min'),
					cmn = st.vols{i}.blobs{1}.min;
				else,
					cmn = -cmx;
				end;

				% get blob data
				vol  = st.vols{i}.blobs{1}.vol;
				M    = st.vols{i}.premul*st.vols{i}.blobs{1}.mat;
				tmps = spm_slice_vol(vol,inv(SM0*(st.Space\M)),SD,[0 NaN])';
				
				% actimg scaled round 0, black NaNs
				topc = size(actc,1)+1;
				tmps = scaletocmap(tmps,cmn,cmx,actc,topc);
				actc = [actc; 0 0 0];
				
				% combine gray and blob data to
				% truecolour

				imgs = reshape(actc(tmps(:),:)*actp+ ...
					       gryc(imgs(:),:)*(1-actp), ...
					       [size(imgs) 3]);
				
                                redraw_colourbar(i,1,[cmn cmx],[1:64]'+64); 
				
			else,
				% Add full colour blobs - several sets at once
				scal  = 1/(mx-mn);
				dcoff = -mn*scal;

				ws = zeros(size(imgs));

				imgs  = repmat(imgs*scal+dcoff,[1,1,3]);

				cimgs = zeros(size(imgs));

				for j=1:length(st.vols{i}.blobs), % get colours of all images first
					if isfield(st.vols{i}.blobs{j},'colour'),
						colour(j,:) = reshape(st.vols{i}.blobs{j}.colour, [1 3]);
					else,
						colour(j,:) = [1 0 0];
					end;
				end;
				%colour = colour/max(sum(colour));

				for j=1:length(st.vols{i}.blobs),
					if isfield(st.vols{i}.blobs{j},'max'),
						mx = st.vols{i}.blobs{j}.max;
					else,
						mx = max([eps max(st.vols{i}.blobs{j}.vol(:))]);
						st.vols{i}.blobs{j}.max = mx;
					end;
					if isfield(st.vols{i}.blobs{j},'min'),
						mn = st.vols{i}.blobs{j}.min;
					else,
						mn = min([0 min(st.vols{i}.blobs{j}.vol(:))]);
						st.vols{i}.blobs{j}.min = mn;
					end;

					vol  = st.vols{i}.blobs{j}.vol;
					M    = st.Space\st.vols{i}.premul*st.vols{i}.blobs{j}.mat;

                    tmps = spm_slice_vol(vol,inv(SM0*M),SD,[0 NaN])';
                    % check min/max of sampled image
                    % against mn/mx as given in st

                    tmps(tmps(:)<mn) = mn;

                    tmps(tmps(:)>mx) = mx;

					tmps = (tmps-mn)/(mx-mn);

					tmps(~isfinite(tmps)) = 0;

					cimgs = cimgs + cat(3,tmps*colour(j,1),tmps*colour(j,2),tmps*colour(j,3));

					ws = ws + tmps;
                                        cdata=permute(shiftdim([1/64:1/64:1]'* ...
                                                               colour(j,:),-1),[2 1 3]);
                                        redraw_colourbar(i,j,[mn mx],cdata);
				end;

				imgs = repmat(1-ws,[1 1 3]).*imgs+cimgs;

				imgs(imgs<0)=0; imgs(imgs>1)=1;
			end;
		else,
			scal = 64/(mx-mn);
			dcoff = -mn*scal;
			imgs = imgs*scal+dcoff;
		end;

% 		set(st.vols{i}.ax{1}.d,'HitTest','off', 'Cdata',imgt);
% 		set(st.vols{i}.ax{1}.lx,'HitTest','off',...
% 			'Xdata',[0 TD(1)]+0.5,'Ydata',[1 1]*(cent(2)-bb(1,2)+1));
% 		set(st.vols{i}.ax{1}.ly,'HitTest','off',...
% 			'Ydata',[0 TD(2)]+0.5,'Xdata',[1 1]*(cent(1)-bb(1,1)+1));
% 
% 		set(st.vols{i}.ax{2}.d,'HitTest','off', 'Cdata',imgc);
% 		set(st.vols{i}.ax{2}.lx,'HitTest','off',...
% 			'Xdata',[0 CD(1)]+0.5,'Ydata',[1 1]*(cent(3)-bb(1,3)+1));
% 		set(st.vols{i}.ax{2}.ly,'HitTest','off',...
% 			'Ydata',[0 CD(2)]+0.5,'Xdata',[1 1]*(cent(1)-bb(1,1)+1));
% 
% 		set(st.vols{i}.ax{3}.d,'HitTest','off','Cdata',imgs);
% 		if st.mode ==0,
% 			set(st.vols{i}.ax{3}.lx,'HitTest','off',...
% 				'Xdata',[0 SD(1)]+0.5,'Ydata',[1 1]*(cent(2)-bb(1,2)+1));
% 			set(st.vols{i}.ax{3}.ly,'HitTest','off',...
% 				'Ydata',[0 SD(2)]+0.5,'Xdata',[1 1]*(cent(3)-bb(1,3)+1));
% 		else,
% 			set(st.vols{i}.ax{3}.lx,'HitTest','off',...
% 				'Xdata',[0 SD(1)]+0.5,'Ydata',[1 1]*(cent(3)-bb(1,3)+1));
% 			set(st.vols{i}.ax{3}.ly,'HitTest','off',...
% 				'Ydata',[0 SD(2)]+0.5,'Xdata',[1 1]*(bb(2,2)+1-cent(2)));
% 		end;

	end;
end;

end



if(viewtype == 's')
    slicedata{kk} = flipdim(imgc,1);
elseif(viewtype == 't')
    slicedata{kk} = flipdim(flipdim(permute(imgt,[2,1,3]),1),2);
elseif(viewtype == 'c')
    slicedata{kk} = flipdim(imgs,1);
end            
pos{kk} = slice;
kk = kk+1;
end
if(isempty(sliceview.colormap))
    if mn*mx < 0
        colormp = 'gray-hot-cold';                    
    elseif mx > 0
        colormp = 'gray-hot';
    else
        colormp = 'gray-cold';
    end  
    sliceview.colormap = colormp;
else
    colormp = sliceview.colormap;
end

return;