%DEMO_IMAGE_ARROW Shows an example of complex image generation.
%
%   See <a href="matlab:edit Demo_Image_Arrow;">source code</a> for details.

image_size     = 400;
leading_r      = 80;
leading_angle  = 30;
trailing_r     = 20;
trailing_angle = 60;
tail_t         = 30;
tail_r         = 70;

% leading edges of an arrow head
leading_map = max( ...
	-map_linear(image_size, [], leading_angle), ...
	map_linear(image_size, [], -leading_angle) ...
	);
leading_shape = mk_shape(leading_map, ...
	leading_r * sind(leading_angle) ...
	);
subplot(2, 2, 1);
imshow(leading_shape);

% trailing edges of an arrow head
trailing_map = max( ...
	-map_linear(image_size, [], trailing_angle), ...
	map_linear(image_size, [], -trailing_angle) ...
	);
trailing_shape = mk_shape(trailing_map, ...
	trailing_r * sind(trailing_angle) ...
	);
subplot(2, 2, 2);
imshow(trailing_shape);

% combine leading and trailing edges to an arrow head
head_shape = leading_shape .* (1 - trailing_shape);
subplot(2, 2, 3);
imshow(head_shape);

% attach a tail to the arrow head
tail_shape = mk_shape(map_symmetric(image_size), tail_t / 2) ...
	.* mk_shape(map_linear(image_size, [], 90), tail_r) ...
	.* mk_shape(map_linear(image_size, [], 270), trailing_r + 5);
arrow_shape = max(head_shape, tail_shape);
subplot(2, 2, 4);
imshow(arrow_shape);
