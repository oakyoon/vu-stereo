function adj_frames = DefaultAdjFrames(pxpd)
	% default pxpd: 400¡¿300 mm (1280¡¿960 px) screen at 650 mm distance 
	if ~exist('pxpd', 'var') || isempty(pxpd)
		pxpd = (650 * tand(.5) * 2) * (1280 / 400);
	end
	adj_frames = DotFrames_Grid(pxpd);
end