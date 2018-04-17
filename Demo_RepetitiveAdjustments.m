try
	sbj_id   = 'demo';
	pxpd     = 30;  % 30 pixels per degree
	bg_color = [128, 128, 128];
	demo_dir = fileparts(mfilename('fullpath'));

	% initialize ptb3 window
	KbName('UnifyKeyNames');
	clear KbWait;
	ListenChar(2);
	[wptr, rect] = Screen('OpenWindow', 0, bg_color, [0 0 1024 768]);
	Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	Screen('Preference', 'TextAntiAliasing', 2);
	Screen('Preference', 'TextRenderer',     1);
	HideCursor();

	% ADJUSTMENT CONF. & VARS.
	frame_images = DefaultAdjFrames(pxpd);
	adj_conf     = DefaultAdjConf(frame_images);
	[scx, scy] = RectCenter(rect);
	cxcy = round([scx * 0.5, scy; scx * 1.5, scy]);
	% instruction
	adj_conf.Instruction =  [ ...
		'                  < Stereo Frames Adjustment >\n\n\n', ...
		'ARROW keys move the flickering frame in one eye.\n\n', ...
		'SPACE key switches the moving frame between the eyes.\n\n', ...
		'This procedure will be repeated six times.\n\n' ...
		];
	ShowAdjustmentInstruction(wptr, adj_conf, cxcy);
	% ADJUSTMENT STARTS
	for r = 1:3
		cxcy_jitter = round((rand(2, 2) - .5) * 2 * pxpd);  % jitter
		if r == 1
			adj_conf.SwitchLimits = 4;
		else
			adj_conf.FlickerAfter = 0;
			adj_conf.SwitchLimits = 2;
		end
		tmp_info(r) = AdjustStereoFramesImpl(wptr, adj_conf, cxcy + cxcy_jitter); %#ok<SAGROW>
	end
	lcx = round(mean(arrayfun(@(x) x.lcx, tmp_info)));
	lcy = round(mean(arrayfun(@(x) x.lcy, tmp_info)));
	rcx = round(mean(arrayfun(@(x) x.rcx, tmp_info)));
	rcy = round(mean(arrayfun(@(x) x.rcy, tmp_info)));
	% ADJUSTMENT ENDS

	% simple rivalry images at the adjusted coords.
	% load images & make textures
	image1 = imread(fullfile(demo_dir, 'demo-rivalry-image1.png'));
	image2 = imread(fullfile(demo_dir, 'demo-rivalry-image2.png'));
	texture1 = Screen('MakeTexture', wptr, image1);
	texture2 = Screen('MakeTexture', wptr, image2);
	% center image rects using adjusted coords.
	image1_rect = CenterRectOnPoint( ...
		RectOfMatrix(image1), lcx, lcy);
	image2_rect = CenterRectOnPoint( ...
		RectOfMatrix(image2), rcx, rcy);
	% show textures & wait for key press
	Screen('DrawTexture', wptr, texture1, [], image1_rect);  % left eye
	Screen('DrawTexture', wptr, texture2, [], image2_rect);  % right eye
	Screen('Flip', wptr);
	RestrictKeysForKbCheck([KbName('space'), KbName('ESCAPE')]);
	KbWait([], 3);
	RestrictKeysForKbCheck([]);

	% close ptb3 window
	Screen('CloseAll');
	ListenChar(1);
catch e
	% close ptb3 window and rethow error
	Screen('CloseAll');
	ListenChar(1);
	rethrow(e);
end