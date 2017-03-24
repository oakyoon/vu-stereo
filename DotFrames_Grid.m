function images = DotFrames_Grid(varargin)
	init_pretina();
	pxpd        = pretina_arg(varargin, 1, mfilename, 'pxpd',        [],        {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_size    = pretina_arg(varargin, 2, mfilename, 'dot_size',    0.1,       {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_spacing = pretina_arg(varargin, 3, mfilename, 'dot_spacing', 1.5,       {'numeric'}, {'scalar', 'finite', 'positive'});
	dot_rows    = pretina_arg(varargin, 4, mfilename, 'dot_rows',    5,         {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	dot_cols    = pretina_arg(varargin, 5, mfilename, 'dot_cols',    dot_rows,  {'numeric'}, {'scalar', 'integer', 'finite', 'positive'});
	dot_color   = pretina_arg(varargin, 6, mfilename, 'dot_color',   [0 0 0],   {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan', 'size', [1 3]});
	cross_r     = pretina_arg(varargin, 7, mfilename, 'cross_r',     0.15,      {'numeric'}, {'scalar', 'finite', 'positive'});
	cross_t     = pretina_arg(varargin, 8, mfilename, 'cross_t',     0.025,     {'numeric'}, {'scalar', 'finite', 'positive'});
	cross_color = pretina_arg(varargin, 9, mfilename, 'cross_color', [0 255 0], {'numeric'}, {'nonempty', 'real', 'finite', 'nonnan', 'size', [1 3]});

	dot_size    = dot_size * pxpd;
	dot_spacing = round(dot_spacing * pxpd);
	frame_size  = ([dot_rows, dot_cols] + 1) * dot_spacing;
	cross_r     = cross_r * pxpd;
	cross_t     = cross_t * pxpd;

	% dots
	alpha_dots = zeros(frame_size);
	for xx = 1:dot_cols
		for yy = 1:dot_rows
			if (xx ~= (dot_cols * .5 + .5)) || (yy ~= (dot_rows * .5 + .5))
				[mx, my] = meshgrid(1:frame_size);
				mecc = xy2ecc(mx - (xx * dot_spacing), my - (yy * dot_spacing));
				dmat = mk_shape(mecc, dot_size);
				alpha_dots = apply_alpha(alpha_dots, ones(frame_size), dmat);
			end
		end
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
	image1_base = rgb2map(dot_color, frame_size(1), frame_size(2));
	image2_base = apply_alpha( ...
		rgb2map(dot_color,   frame_size(1), frame_size(2)), ...
		rgb2map(cross_color, frame_size(1), frame_size(2)), ...
		mk_shape(map_radial(frame_size(1), frame_size(2)), ceil(cross_r + 2)) ...
		);
	images = {
		cat(3, image1_base, alpha_combined * 255);
		cat(3, image2_base, alpha_combined * 255);
		};
end