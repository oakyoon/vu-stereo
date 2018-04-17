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

	% ADJUSTMENT STARTS
	adj_info = AdjustStereoFrames(wptr, sbj_id, pxpd);
	% ADJUSTMENT ENDS

	% simple rivalry images at the adjusted coords.
	% load images & make textures
	image1 = imread(fullfile(demo_dir, 'demo-rivalry-image1.png'));
	image2 = imread(fullfile(demo_dir, 'demo-rivalry-image2.png'));
	texture1 = Screen('MakeTexture', wptr, image1);
	texture2 = Screen('MakeTexture', wptr, image2);
	% center image rects using adjusted coords.
	image1_rect = CenterRectOnPoint( ...
		RectOfMatrix(image1), ...
		adj_info.lcx, adj_info.lcy);
	image2_rect = CenterRectOnPoint( ...
		RectOfMatrix(image2), ...
		adj_info.rcx, adj_info.rcy);
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