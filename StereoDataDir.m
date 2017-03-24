function dir = StereoDataDir()
	if exist('stereo-data', 'dir')
		dir = 'stereo-data';
	else
		dir = fullfile(fileparts(mfilename('fullpath')), 'stereo-data');
	end
end