function [wptr, rect, mirrored] = OpenStereoWindow(varargin)
	n_screens = max(length(Screen('Screens')) - 1, 1);
	% decides whether screen(s) should be mirror-reversed
	% if there exists only one screen (probably 4-mirror stereoscope)
	if n_screens == 1
		mirrored = false;
	% if a screen is specified
	elseif varargin{1} > 0
		mirrored = false;
	% check whether screens have the same resolution (2-mirror stereoscope) 
	else
		screen_rects = arrayfun(@(n) { Screen('Rect', n) }, 1:n_screens)';
		screen_diffs = diff(cell2mat(screen_rects), 1);
		mirrored = all(screen_diffs(:) == 0);
		if ~mirrored
			varargin{1} = max(Screen('Screens'));
		end
	end

	% default stereo mode is 4
	if length(varargin) < 6
		varargin{6} = 4;
	end

	% open ptb3 window
	if mirrored
		[wptr, rect] = OpenMirroredWindow(varargin{:});
	else
		[wptr, rect] = Screen('OpenWindow', varargin{:});
	end
end