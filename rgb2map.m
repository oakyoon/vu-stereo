function rgbmap = rgb2map(varargin)
%RGB2MAP Generates a 3-layer map from a given RGB value.
%
%   RGBMAP = RGB2MAP(RGB ,ROWS [,COLS]) returns a ROWS-by-COLS-by-3 matrix,
%   whose element is assigend R, G, or B from the given RGB value depending on
%   its layer.
%
%   Arguments:
%      RGB  - 3-column vector containing R, G, and B values.
%      ROWS - number of rows of the output matrix.
%      COLS - number of columns, the same as ROWS if empty or not provided.

	rgb  = pretina_arg(varargin, 1,  mfilename, 'rgb',  [],   {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan', 'size', [1 3]});
	rows = pretina_arg(varargin, 2,  mfilename, 'rows', [],   {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	cols = pretina_arg(varargin, 3,  mfilename, 'cols', rows, {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});

	rgbmap = repmat(reshape(rgb, [1 1 3]), [rows, cols, 1]);
end