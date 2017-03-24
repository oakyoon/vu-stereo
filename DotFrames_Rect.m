function images = DotFrames_Rect(varargin)
	init_pretina();
	pxpd        = pretina_arg(varargin, 1, mfilename, 'pxpd',        [],                   {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_size    = pretina_arg(varargin, 2, mfilename, 'dot_size',    0.2,                  {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_spacing = pretina_arg(varargin, 3, mfilename, 'dot_spacing', 0.5,                  {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_rows    = pretina_arg(varargin, 4, mfilename, 'dot_rows',    11,                   {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	dot_cols    = pretina_arg(varargin, 5, mfilename, 'dot_cols',    dot_rows,             {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	dot_colors  = pretina_arg(varargin, 6, mfilename, 'dot_colors',  [0 0 0; 255 255 255], {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan', 'size', [NaN 3]});
	cross_r     = pretina_arg(varargin, 7, mfilename, 'cross_r',     0.15,                 {'numeric'}, {'scalar', 'finite', 'positive'});
	cross_t     = pretina_arg(varargin, 8, mfilename, 'cross_t',     0.025,                {'numeric'}, {'scalar', 'finite', 'positive'});
	cross_color = pretina_arg(varargin, 9, mfilename, 'cross_color', [0 255 0],            {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan', 'size', [1 3]});

	dot_size    = dot_size * pxpd;
	dot_spacing = round(dot_spacing * pxpd);
	frame_size  = ([dot_rows, dot_cols] + 1) * dot_spacing;
	cross_r     = cross_r * pxpd;
	cross_t     = cross_t * pxpd;

	% dots
	image_base = zeros([frame_size, 3]);
	alpha_dots = zeros(frame_size);
	xxyy = [
		ones(dot_rows, 1), (1:dot_rows)';
		(2:(dot_cols - 1))', ones(dot_cols - 2, 1) * dot_rows;
		ones(dot_rows, 1) * dot_cols, (dot_rows:-1:1)';
		((dot_cols - 1):-1:2)', ones(dot_cols - 2, 1);
		];
	for dd = 1:size(xxyy, 1)
		xx = xxyy(dd, 1);
		yy = xxyy(dd, 2);
		[mx, my] = meshgrid(1:frame_size);
		mecc = xy2ecc(mx - (xx * dot_spacing), my - (yy * dot_spacing));
		dmat = mk_shape(mecc, dot_size);
		alpha_dots = apply_alpha(alpha_dots, ones(frame_size), dmat);
		dot_color  = dot_colors(mod(dd - 1, size(dot_colors, 1)) + 1, :);
		image_base = apply_alpha(image_base, ...
			rgb2map(dot_color, frame_size(1), frame_size(2)), ...
			double(dmat > 0));
	end
	% cross at the center
	alpha_half_cross = ...
		mk_shape(map_symmetric(frame_size(1), frame_size(2), 45), cross_t) .* ...
		mk_shape(map_symmetric(frame_size(1), frame_size(2), 135), cross_r);
	alpha_cross = apply_alpha(alpha_half_cross, ...
		ones(frame_size), alpha_half_cross(:, end:-1:1));
	% combined
	alpha_combined = apply_alpha(alpha_dots, ones(frame_size), alpha_cross);

	% images
	image1_base = apply_alpha(image_base, ...
		rgb2map(dot_colors(1, :), frame_size(1), frame_size(2)), ...
		double(alpha_cross > 0));
	image2_base = apply_alpha(image_base, ...
		rgb2map(cross_color, frame_size(1), frame_size(2)), ...
		double(alpha_cross > 0));
	images = {
		cat(3, image1_base, alpha_combined * 255);
		cat(3, image2_base, alpha_combined * 255);
		};
end