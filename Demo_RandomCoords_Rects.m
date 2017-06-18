%DEMO_RANDOMCOORDS_RECTS Shows how to arrange rectangles with varying sizes
%(half widths), aspect ratios, and tilts to random locations within a complex
%window.
%
%   See <a href="matlab:edit Demo_RandomCoords_Rects;">source code</a> for details.
%
%   See also RANDOM_COORDS, DEMO_RANDOMCOORDS_CIRCLES, 
%   DEMO_RANDOMCOORDS_POLYGONS, DEMO_RANDOMCOORDS_GAUSSIAN.

n_rects = 30;                          % number of rectangles: 30
r_rects = rand(n_rects, 1) * 10 + 15;  % half widths of rectangles: 10 - 25 px
ratio = rand(n_rects, 1) * 1.5 + 1;    % aspect ratios of rectangles: 1 - 2.5
tilt = rand(n_rects, 1) * 180;         % tilt angle of rectangles: 0 - 180 degs.

% stim. window (400 by 400 px rectangle with 150 x 150 px hole at the center)
mask = ones(400) .* (1 - mk_shape(map_radial(400), 75));
subplot(1, 2, 1);
imshow(mask);

% random coordinates of rectangle centers
%   1st column of rect. params.: half width + margin
%   2nd column of rect. params.: aspect ratio (1 if not provided)
%   3rd column of rect. params.: tilt angle (0 if not provided)
margin_rects = 5;
[coords, voidmap, n] = random_coords(mask, ...
	[r_rects + margin_rects, ratio, tilt], ...  % rect. params.
	@postfunc_rect, @prefunc_rect ...
	);
% occupied areas (inculding margin) are marked with 0 in void map
subplot(1, 2, 2);
imshow(voidmap);

% show number of rectangles arranged successfully
fprintf('%d rectangles arranged:\n', n);
% show rectangle centers & params.
disp([coords, r_rects, ratio, tilt]);
