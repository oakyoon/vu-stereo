%DEMO_RANDOMCOORDS_CIRCLES Shows how to arrange circles with varying radii to
%random locations within a circular window.
%
%   See <a href="matlab:edit Demo_RandomCoords_Circles;">source code</a> for details.
%
%   See also RANDOM_COORDS, DEMO_RANDOMCOORDS_RECTS, DEMO_RANDOMCOORDS_POLYGONS,
%   DEMO_RANDOMCOORDS_GAUSSIAN.

n_circles = 40;                           % number of circles: 40
r_circles = rand(n_circles, 1) * 25 + 5;  % radii of circles: 5 - 30 px

% circular window (400 by 400 px)
mask = mk_shape(map_radial(400), 200);
subplot(1, 2, 1);
imshow(mask);

% random coordinates of circle centers
%   1st column of oval params.: radius + margin
%   2nd column of oval params.: aspect ratio (1 if not provided)
%   3rd column of oval params.: tilt angle (0 if not provided)
margin_circle = 5;
[coords, voidmap, n] = random_coords(mask, ...
	r_circles + margin_circle, ...  % oval params.
	@postfunc_oval, @prefunc_oval ...
	);
% occupied areas (inculding margin) are marked with 0 in void map
subplot(1, 2, 2);
imshow(voidmap);

% show number of circles arranged successfully
fprintf('%d circles arranged:\n', n);
% show circle centers & radii
disp([coords, r_circles]);
