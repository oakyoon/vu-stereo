function [wptr, rect] = OpenMirroredWindow(varargin)
	PsychImaging('PrepareConfiguration');
	PsychImaging('AddTask', 'AllViews', 'FlipHorizontal');
	[wptr,rect] = PsychImaging('OpenWindow', varargin{:});
end