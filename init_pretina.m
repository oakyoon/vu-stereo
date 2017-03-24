function init_pretina()
	if ~exist('pretina_version', 'file')
		addpath(fullfile(fileparts(mfilename('fullpath')), 'pretina'));
	end
end