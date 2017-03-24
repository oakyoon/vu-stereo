function anglemat = xy2angle(varargin)
%XY2ANGLE Converts x- and y-values into angles measured from the vertical
%meridian.
%
%   ANGLEMAT = XY2ANGLE(BX ,BY) returns a matrix with the same size as BX and
%   BY, whose element is an angle measured from the vertical meridian.
%
%   Arguments:
%      BX - matrix containing x-values in the monitor coordinate.
%      BY - matrix containing y-values in the monitor coordinate.
%
%   See also ANGLE2XY, WRAP_ANGLE, BASE_XY.

	bx = pretina_arg(varargin, 1, mfilename, 'bx', [], {'numeric'}, {'real', 'finite', 'nonnan'});
	by = pretina_arg(varargin, 2, mfilename, 'by', [], {'numeric'}, {'real', 'finite', 'nonnan', 'size', size(bx)});

	anglemat = mod(atan2(by, bx) / pi * 180 + 90, 360);
end