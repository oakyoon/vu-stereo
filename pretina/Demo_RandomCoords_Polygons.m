%DEMO_RANDOMCOORDS_POLYGONS Shows how to arrange polygons with varying number of
%sides, and tilts to random locations within a complex window.
%
%   See <a href="matlab:edit Demo_RandomCoords_Polygons;">source code</a> for details.
%
%   See also RANDOM_COORDS, DEMO_RANDOMCOORDS_CIRCLES, DEMO_RANDOMCOORDS_RECTS,
%   DEMO_RANDOMCOORDS_GAUSSIAN.

n_polygons = 65;                             % number of polygons: 65
r_polygons = ones(n_polygons, 1) * 10;       % half widths of polygons: 10 px
sides = 3 + floor(rand(n_polygons, 1) * 4);  % number of sides of polygons: 3 - 6
tilt = rand(n_polygons, 1) * 360;            % tilt angle of polygons: 0 - 360 degs.

% stim. window (400 by 400 px rectangle with a triangular hole at the center)
mask = ones(400) .* (1 - mk_shape(map_polygonal(400), 50));
subplot(1, 2, 1);
imshow(mask);

% random coordinates of polygon centers
%   1st column of polygon params.: half width + margin
%   2nd column of polygon params.: numbeer of sides (3 if not provided)
%   3rd column of polygon params.: tilt angle (0 if not provided)
margin_polygons = 5;
[coords, voidmap, n] = random_coords(mask, ...
	[r_polygons + margin_polygons, sides, tilt], ...  % polygon params.
	@postfunc_polygon, @prefunc_polygon ...
	);
% occupied areas (inculding margin) are marked with 0 in void map
subplot(1, 2, 2);
imshow(voidmap);

% show number of polygons arranged successfully
fprintf('%d polygons arranged:\n', n);
% show polygon centers & params.
disp([coords, r_polygons, sides, tilt]);
