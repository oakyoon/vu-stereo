function adj_frames = DefaultAdjFrames(pxpd)
	% check stereo data dir. for adj. frame images
	image_files = {
		fullfile(StereoDataDir, 'AdjFrame1.png');
		fullfile(StereoDataDir, 'AdjFrame2.png');
		};
	if all(cellfun(@exist, image_files) == 2)
		init_pretina();
		adj_frames = cellfun(@(f) { ptb.imread_alpha(f) }, image_files);
		% make sure that images have the same size
		if (ndims(adj_frames{1}) ~= ndims(adj_frames{2})) || ...
				~all(size(adj_frames{1}) == size(adj_frames{2}))
			error('frame images do not have the same size');
		end
	% fall back to default dot frames
	else
		% default pxpd: 400¡¿300 mm (1280¡¿960 px) screen at 650 mm distance 
		if ~exist('pxpd', 'var') || isempty(pxpd)
			pxpd = (650 * tand(.5) * 2) * (1280 / 400);
		end
		adj_frames = DotFrames_Grid(pxpd);
	end
end