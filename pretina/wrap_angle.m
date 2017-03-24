function wrappedmat = wrap_angle(varargin)
%WRAP_ANGLE Wraps angles into the range between -180 and 180 degrees.
%
%   WRAPPEDMAT = WRAP_ANGLE(ANGLES) returns a matrix with the same size as
%   ANGLES, whose element ranges between -180 and 180 degrees.
%
%   Arguments:
%      ANGLES - matrix containing angles.
%
%   See also XY2ANGLE.

	angles = pretina_arg(varargin, 1, mfilename, 'angles', [], {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan'});
	wrappedmat = mod(angles + 180, 360) - 180;
end