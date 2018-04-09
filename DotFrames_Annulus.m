function images = DotFrames_Annulus(varargin)
	init_pretina();
	pxpd        = pretina_arg(varargin, 1, mfilename, 'pxpd',        [],                   {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_size    = pretina_arg(varargin, 2, mfilename, 'dot_size',    0.2,                  {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_spacing = pretina_arg(varargin, 3, mfilename, 'dot_spacing', 12,                   {'numeric'}, {'scalar', 'finite', 'positive'});
	annulus_r   = pretina_arg(varargin, 4, mfilename, 'annulus_r',   2.25,                 {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_colors  = pretina_arg(varargin, 5, mfilename, 'dot_colors',  [0 0 0; 255 255 255], {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan', 'size', [NaN 3]});
	cross_r     = pretina_arg(varargin, 6, mfilename, 'cross_r',     0.15,                 {'numeric'}, {'scalar', 'finite', 'positive'});
	cross_t     = pretina_arg(varargin, 7, mfilename, 'cross_t',     0.025,                {'numeric'}, {'scalar', 'finite', 'positive'});
	cross_color = pretina_arg(varargin, 8, mfilename, 'cross_color', [0 255 0],            {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan', 'size', [1 3]});

	dot_size   = dot_size  * pxpd;
	annulus_r  = annulus_r * pxpd;
	frame_size = round(annulus_r * (2 + pi / 90 * dot_spacing));
	frame_cxcy = frame_size * .5 + .5;
	cross_r    = cross_r * pxpd;
	cross_t    = cross_t * pxpd;

	% dots
	image_base = zeros([frame_size([1 1]), 3]);
	alpha_dots = zeros(frame_size);
	dot_angles = (0:dot_spacing:(360 - dot_spacing))';
	for dd = 1:length(dot_angles)
		[xx, yy] = angle2xy(dot_angles(dd), annulus_r);
		[mx, my] = meshgrid(1:frame_size);
		mecc = xy2ecc(mx - xx - frame_cxcy, my - yy - frame_cxcy);
		dmat = mk_shape(mecc, dot_size);
		alpha_dots = apply_alpha(alpha_dots, ones(frame_size), dmat);
		dot_color  = dot_colors(mod(dd - 1, size(dot_colors, 1)) + 1, :);
		image_base = apply_alpha(image_base, ...
			rgb2map(dot_color, frame_size), ...
			double(dmat > 0));
	end
	% cross at the center
	alpha_half_cross = ...
		mk_shape(map_symmetric(frame_size, [], 45), cross_t) .* ...
		mk_shape(map_symmetric(frame_size, [], 135), cross_r);
	alpha_cross = apply_alpha(alpha_half_cross, ...
		ones(frame_size), alpha_half_cross(:, end:-1:1));
	% combined
	alpha_combined = apply_alpha(alpha_dots, ones(frame_size), alpha_cross);

	% images
	image1_base = apply_alpha(image_base, ...
		rgb2map(dot_colors(1, :), frame_size), ...
		double(alpha_cross > 0));
	image2_base = apply_alpha(image_base, ...
		rgb2map(cross_color, frame_size), ...
		double(alpha_cross > 0));
	images = {
		cat(3, image1_base, alpha_combined * 255);
		cat(3, image2_base, alpha_combined * 255);
		};
end