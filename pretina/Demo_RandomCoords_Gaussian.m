%DEMO_RANDOMCOORDS_GAUSSIAN Shows how to arrange Gaussian envelopes (Gaussian
%dot, Gabor, etc.) to random locations within a circular window.
%
%   See <a href="matlab:edit Demo_RandomCoords_Gaussian;">source code</a> for details.
%
%   See also RANDOM_COORDS, DEMO_RANDOMCOORDS_CIRCLES, DEMO_RANDOMCOORDS_RECTS,
%   DEMO_RANDOMCOORDS_POLYGONS.

n_envelopes = 50;								% number of envelopes: 50
sd_envelopes = ones(n_envelopes, 1) * 5;		% S.D. of Gaussian: 5 px

% circular window (350 by 350 px circle)
mask = mk_shape(map_radial(400), 175);
subplot(1, 2, 1);
imshow(mask);

% random coordinates of envelope centers
%   1st column of Gaussian params.: sd * margin coefs.
%   2nd column of Gaussian params.: aspect ratio (1 if not provided)
%   3rd column of Gaussian params.: tilt angle (0 if not provided)
margin_coefs = 2;
[coords, voidmap, n] = random_coords(mask, ...
	sd_envelopes * margin_coefs, ...  % Gaussian params.
	@postfunc_gaussian ...
	);
% areas are more likely to be occupied if their values are smaller in void map
subplot(1, 2, 2);
imshow(voidmap);

% show number of envelopes arranged successfully
fprintf('%d envelopes arranged:\n', n);
% show envelope centers
disp(coords);
