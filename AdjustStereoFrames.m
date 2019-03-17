function adj_info = AdjustStereoFrames(wptr, sbj_id, adj_conf)
	% check input arguments
	if ~exist('wptr', 'var') || isempty(wptr)
		wptrs = Screen('Windows');
		wptr  = wptrs(1:min(1, end));
	end
	window_open = ~isempty(wptr);
	if ~exist('sbj_id', 'var') || isempty(sbj_id)
		if window_open
			sca;
			error('second argument (subject id string) required');
		else
			sbj_id = '';
			while isempty(sbj_id)
				sbj_id = strtrim(input('Enter subject id (e.g., SUB01): ', 's'));
			end
		end
	end
	% adj. conf. not provided
	if ~exist('adj_conf', 'var') || isempty(adj_conf)
		adj_conf = DefaultAdjConf();
	% images provided instead of adj. conf.
	elseif iscell(adj_conf)
		adj_conf = DefaultAdjConf(adj_conf);
	% pixel per degree provided instead of adj. conf.
	elseif isscalar(adj_conf) && ~isstruct(adj_conf)
		adj_conf = DefaultAdjConf(DefaultAdjFrames(adj_conf));
	end

	% load previous adjustment info (if there is)
	datafile = fullfile(adj_conf.DataDir, [sbj_id, '.mat']);
	if exist(datafile, 'file')
		load(datafile, 'adj_info');
		cxcy = adj_info.cxcy;
	end

	try
		% open window (if needed)
		if ~window_open
			clear PsychHID KbCheck KbWait;
			KbName('UnifyKeyNames');
			ListenChar(2);
			[wptr, rect] = Screen('OpenWindow', 0, adj_conf.BgColor);
			Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
			Screen('Preference', 'TextAntiAliasing', 2);
			Screen('Preference', 'TextRenderer',     1);
			HideCursor();
		else
			rect = Screen('Rect', wptr);
		end
		if ~exist('cxcy', 'var') || isempty(cxcy)
			[scx, scy] = RectCenter(rect);
			cxcy = round([scx * 0.5, scy; scx * 1.5, scy]);
		end

		% instruction
		if isfield(adj_conf, 'Instruction')
			ShowAdjustmentInstruction(wptr, adj_conf, cxcy);
		end

		% do adjustment
		adj_info = AdjustStereoFramesImpl(wptr, adj_conf, cxcy);
		% save data
		adj_info.date = datestr(now(), 'yyyy/mm/dd, HH:MM:SS');
		adj_info.rect = rect;
		save(datafile, 'adj_info', 'adj_conf');

		% close window (if needed)
		if ~window_open
			Screen('CloseAll');
			ListenChar(1);
		end
	catch e
		% close window (if needed)
		if ~window_open
			Screen('CloseAll');
			ListenChar(1);
		end
		% rethrow error
		rethrow(e);
	end
end