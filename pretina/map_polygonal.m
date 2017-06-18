function pixelmap = map_polygonal(varargin)
%MAP_POLYGONAL Generates a map of polygonally increasing values.
%
%   PIXELMAP = MAP_POLYGONAL(ROWS [,COLS] [,SIDES] [,TILT]) returns a ROWS-by-
%   COLS matrix, whose value increases from the center with a polygonal pattern.
%   The number of sides of the polygon pattern is determined by SIDES, and the
%   polygon pattern will be tilted by TILT degrees.
%
%   Arguments:
%      ROWS  - number of rows of the output matrix.
%      COLS  - number of columns, the same as ROWS if empty or not provided.
%      SIDES - number of sides of the polygon, 3 if empty or not provided.
%      TILT  - tilt angle of the polygon, 0 if empty or not provided.
%
%   See also MAP_RADIAL, MAP_RECTANGULAR.

	rows  = pretina_arg(varargin, 1, mfilename, 'rows',  [],   {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	cols  = pretina_arg(varargin, 2, mfilename, 'cols',  rows, {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	sides = pretina_arg(varargin, 3, mfilename, 'sides', 3,    {'numeric'}, {'scalar', 'integer', 'finite', 'nonnan', '>', 2});
	tilt  = pretina_arg(varargin, 4, mfilename, 'tilt',  0,    {'numeric'}, {'scalar', 'real', 'finite', 'nonnan'});

	angles = linspace(0, 360, sides + 1);
	angles = angles(angles < 360) + tilt;
	pixelmap = zeros(rows, cols, length(angles));
	for i = 1:length(angles)
		[~, pixelmap(:, :, i)] = base_xy(cols, rows, angles(i));
	end
	pixelmap = max(pixelmap, [], 3);
end