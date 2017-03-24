function normmap = normalize_map(varargin)
%NORMALIZE_MAP Normalizes elements in a matrix to a range between 0 and 1.
%
%   NORMMAP = NORMALIZE_MAP(PIXELMAP [,MINVAL] [,MAXVAL]) returns a matrix with
%   the same size as PIXELMAP, whose element ranges between 0 and 1. MINVAL will
%   be scaled to 0 and MAXVAL to 1.
%
%   Arguments:
%      PIXELMAP - an image matrix.
%      MINVAL   - will be scaled to 0, min(PIXELMAP) if empty or not provided.
%      MAXVAL   - will be scaled to 1, max(PIXELMAP) if empty or not provided.

	pixelmap = pretina_arg(varargin, 1, mfilename, 'pixelmap', [],               {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan'});
	minval   = pretina_arg(varargin, 2, mfilename, 'minval',   min(pixelmap(:)), {'numeric'}, {'scalar', 'real', 'finite', 'nonnan'});
	maxval   = pretina_arg(varargin, 3, mfilename, 'maxval',   max(pixelmap(:)), {'numeric'}, {'scalar', 'real', 'finite', 'nonnan', '>', minval});

	normmap = ((pixelmap - minval) / (maxval - minval));
end