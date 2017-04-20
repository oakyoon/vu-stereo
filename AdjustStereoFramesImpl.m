function adj_info = AdjustStereoFramesImpl(wptr, adj_conf, cxcy)
	% prepare textures & vars.
	image_tex = [ ...
		Screen('MakeTexture', wptr, adj_conf.Image1), ...
		Screen('MakeTexture', wptr, adj_conf.Image2) ...
		];
	which_eye  = adj_conf.WhichEye;
	image_rect = RectOfMatrix(adj_conf.Image1);
	frame_rects = [ ...
		CenterRectOnPoint(image_rect, cxcy(1, 1), cxcy(1, 2));
		CenterRectOnPoint(image_rect, cxcy(2, 1), cxcy(2, 2));
		];

	% adjustment vars.
	keys = [
		adj_conf.UpKey,     adj_conf.KeyDelay1, adj_conf.KeyDelay2;
		adj_conf.DownKey,   adj_conf.KeyDelay1, adj_conf.KeyDelay2;
		adj_conf.LeftKey,   adj_conf.KeyDelay1, adj_conf.KeyDelay2;
		adj_conf.RightKey,  adj_conf.KeyDelay1, adj_conf.KeyDelay2;
		adj_conf.SwitchKey, Inf, Inf;
		adj_conf.EscapeKey' Inf, Inf;
		];
	key_moves = [
		 0 -1;
		 0  1;
		-1  0;
		 1  0;
		 ];
	key_limits = zeros(1, size(keys, 1));
	% first frame
	Screen('SelectStereoDrawBuffer', wptr, which_eye);
	Screen('DrawTexture', wptr, image_tex(1), [], frame_rects(which_eye + 1, :));
	base_flip = Screen('Flip', wptr);
	prev_flip = base_flip;
	% adjustment loop
	RestrictKeysForKbCheck(keys(:, 1)');
	adjusted = false;
	n_switch = 0;
	while ~adjusted
		Screen('SelectStereoDrawBuffer', wptr, which_eye);
		Screen('DrawTexture', wptr, image_tex(1), [], frame_rects(which_eye + 1, :));
		if (n_switch >= adj_conf.FlickerAfter) && ...
				(mod(prev_flip - base_flip, adj_conf.FlickerCycle) < adj_conf.FlickerSpan)
			Screen('SelectStereoDrawBuffer', wptr, 1 - which_eye);
			Screen('DrawTexture', wptr, image_tex(2), [], frame_rects(2 - which_eye, :));
		end
		Screen('AsyncFlipBegin', wptr);
		prev_flip = 0;
		while prev_flip == 0
			[~, keysecs, keycode] = KbCheck(-3);
			for k = 1:size(keys, 1)
				if keycode(keys(k, 1))
					if keysecs > key_limits(k)
						% escape key pressed
						if k == 6
							adjusted = true;
						% switch key pressed
						elseif k == 5
							base_flip = prev_flip;
							which_eye = 1 - which_eye;
							n_switch = n_switch + 1;
							if n_switch >= adj_conf.SwitchLimits
								adjusted = true;
							end
						% arrow keys pressed
						else
							cxcy(which_eye + 1, :) = ...
								cxcy(which_eye + 1, :) + key_moves(k, :);
							frame_rects(which_eye + 1, :) = ...
								CenterRectOnPoint(image_rect, ...
									cxcy(which_eye + 1, 1), ...
									cxcy(which_eye + 1, 2) ...
									);
						end
						% limits repetitive key inputs 
						key_limits(k) = keysecs + keys(k, 2 + (key_limits(k) > 0));
					end
				else
					% enables key inputs
					key_limits(k) = 0;
				end
			end
			prev_flip = Screen('AsyncFlipCheckEnd', wptr);
		end
	end
	KbReleaseWait();
	RestrictKeysForKbCheck([]);
	Screen('Close', image_tex);

	adj_info = struct( ...
		'cxcy', cxcy, ...
		'lcx',  cxcy(1, 1), ...
		'lcy',  cxcy(1, 2), ...
		'rcx',  cxcy(2, 1), ...
		'rcy',  cxcy(2, 2) ...
		);
end