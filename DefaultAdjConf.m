function adj_conf = DefaultAdjConf(frame_images, which_eye)
	if ~exist('frame_images', 'var') || isempty(frame_images)
		frame_images = DefaultAdjFrames();
	end
	if ~exist('which_eye', 'var') || isempty(which_eye)
		which_eye = randi(2) - 1;
	end
	datadir = StereoDataDir();

	KbName('UnifyKeyNames');
	adj_conf = struct( ...
		'UpKey',        KbName('UpArrow'), ...
		'DownKey',      KbName('DownArrow'), ...
		'LeftKey',      KbName('LeftArrow'), ...
		'RightKey',     KbName('RightArrow'), ...
		'SwitchKey',    KbName('space'), ...
		'EscapeKey',    KbName('ESCAPE'), ...
		'KeyDelay1',    0.400, ...
		'KeyDelay2',    0.025, ...
		'SwitchLimits', Inf, ...
		'FlickerAfter', 2, ...
		'WhichEye',     which_eye, ...
		'BgColor',      [128, 128, 128], ...
		'Image1',       frame_images{1}, ...
		'Image2',       frame_images{2}, ...
		'FlickerCycle', 1.500, ...
		'FlickerSpan',  0.150, ...
		'DataDir',      datadir, ...
		'Instruction',  [ '                  < Stereo Frames Adjustment >\n\n\n', ...
		                  'ARROW keys move the flickering frame in one eye.\n\n', ...
		                  'SPACE key switches the moving frame between the eyes.\n\n', ...
			 			  'ESC key will finish this adjustment procedure.' ], ...
		'TextColor',    [0 0 0], ...
		'TextFont',     'Arial', ...
		'TextSize',     (  15 * ~ispc) + (  13 * ispc), ...
		'TextOffsetX',  (-175 * ~ispc) + (-200 * ispc), ...
		'TextOffsetY',  round(size(frame_images{1}, 1) * .5) ...
		);
end