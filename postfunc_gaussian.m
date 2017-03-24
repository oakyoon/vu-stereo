function voidmap = postfunc_gaussian(voidmap, params, mx, my)
%POSTFUNC_GAUSSIAN Marks a Gaussian envelope as occupied area in the VOIDMAP.
%
%   See also RANDOM_COORDS, DEMO_RANDOMCOORDS_GAUSSIAN.

	[sd, ratio, tilt] = pretina_params(params, [], 1, 0);

	[bx, by] = rotate_xy(mx, my, tilt);
	voidmap = voidmap .* (1 - mk_gaussian(xy2ecc(bx, by * ratio), sd));
end