function ShowAdjustmentInstruction(wptr, adj_conf, cxcy)
	% prepare textures & vars.
	image_tex  = Screen('MakeTexture', wptr, adj_conf.Image1);
	which_eye  = adj_conf.WhichEye;
	frame_rect = CenterRectOnPoint(RectOfMatrix(adj_conf.Image1), ...
		cxcy(which_eye + 1, 1), cxcy(which_eye + 1, 2));
	% set text color, font, & size
	if isfield(adj_conf, 'TextColor')
		prevTextColor = Screen('TextColor', wptr, adj_conf.TextColor);
	end
	if isfield(adj_conf, 'TextFont')
		prevTextFont = Screen('TextFont', wptr, adj_conf.TextFont);
	end
	if isfield(adj_conf, 'TextSize')
		prevTextSize = Screen('TextSize', wptr, adj_conf.TextSize);
	end
	% show frame & instruction text
	Screen('DrawTexture', wptr, image_tex, [], frame_rect);
	DrawFormattedText(wptr, adj_conf.Instruction, ...
		cxcy(which_eye + 1, 1) + adj_conf.TextOffsetX, ...
		cxcy(which_eye + 1, 2) + adj_conf.TextOffsetY ...
		);
	Screen('Flip', wptr);
	% clear texture, reset text font & size 
	Screen('Close', image_tex);
	if exist('prevTextColor', 'var')
		Screen('TextColor', wptr, prevTextColor);
	end
	if exist('prevTextFont', 'var')
		Screen('TextFont', wptr, prevTextFont);
	end
	if exist('prevTextSize', 'var')
		Screen('TextSize', wptr, prevTextSize);
	end
	% wait for key press
	RestrictKeysForKbCheck([adj_conf.SwitchKey, adj_conf.EscapeKey]);
	KbWait([], 3);
	RestrictKeysForKbCheck([]);
end