% Configure MATLAB paths when this repository is the current folder.

repositoryRoot = fileparts(mfilename('fullpath'));
addpath(fullfile(repositoryRoot, 'src', 'design'));
addpath(fullfile(repositoryRoot, 'src', 'runtime'));
addpath(fullfile(repositoryRoot, 'src', 'support'));
addpath(fullfile(repositoryRoot, 'tests'));