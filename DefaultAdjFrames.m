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
		% default pxpd: 390 x 292.5 mm (1024x768 px) screen at 740 mm distance
		if ~exist('pxpd', 'var') || isempty(pxpd)
			pxpd = (740 * tand(.5) * 2) * (1024 / 390);
		end
		adj_frames = DotFrames_Grid(pxpd);
	end
end