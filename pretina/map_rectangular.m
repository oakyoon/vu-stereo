function pixelmap = map_rectangular(varargin)
%MAP_RECTANGULAR Rectangular equivalent of MAP_RADIAL.
%
%   PIXELMAP = MAP_RECTANGULAR(ROWS [,COLS] [,RATIO] [,TILT]) returns a
%   ROWS-by-COLS matrix, whose value increases from the center with a
%   rectangular pattern. The increments in the y-axis are determined by RATIO.
%   The x- and y- axes will be tilted by TILT degrees.
%
%   Arguments:
%      ROWS  - number of rows of the output matrix.
%      COLS  - number of columns, the same as ROWS if empty or not provided.
%      RATIO - aspect ratio of increments, 1 if empty or not provided.
%      TILT  - tilt angle of the x- and y- axes, 0 if empty or not provided.
%
%   See also MAP_RADIAL, MAP_POLYGONAL.

	rows  = pretina_arg(varargin, 1, mfilename, 'rows',  [],   {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	cols  = pretina_arg(varargin, 2, mfilename, 'cols',  rows, {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	ratio = pretina_arg(varargin, 3, mfilename, 'ratio', 1,    {'numeric'}, {'scalar', 'real', 'finite', 'nonnan', 'positive'});
	tilt  = pretina_arg(varargin, 4, mfilename, 'tilt',  0,    {'numeric'}, {'scalar', 'real', 'finite', 'nonnan'});

	[bx, by] = base_xy(cols, rows, tilt);
	pixelmap = max(abs(bx), abs(by) * ratio);
end