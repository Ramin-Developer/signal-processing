function MATLAB_R2017_COMPATIBILITY_TESTS()
% MATLAB R2017a compatibility smoke tests for the signal-processing project.
% These checks intentionally use only widely supported MATLAB syntax and
% runtime patterns so they remain safe for MATLAB 2017a.

fprintf('Running MATLAB 2017 compatibility checks...\n');

cfg = SignalConfig();
assert(isstruct(cfg), 'SignalConfig should return a struct.');
assert(isfield(cfg, 'filterOrderMax'), 'SignalConfig missing filterOrderMax.');
assert(isfield(cfg, 'alpha'), 'SignalConfig missing alpha.');
assert(isfield(cfg, 'signalOmega'), 'SignalConfig missing signalOmega.');
assert(cfg.filterOrderMax > 0, 'filterOrderMax should be positive.');

[InputFile, LastInSignal, LastOutSignal, LogFile, N_max, f_n, Alpha] = Initialize();
assert(ischar(InputFile), 'Initialize should return a filename string.');
assert(isnumeric(f_n), 'Initialize should return a numeric frequency vector.');
assert(length(f_n) > 1, 'Frequency vector should contain more than one point.');
assert(isnumeric(Alpha) && isscalar(Alpha), 'Alpha should be a scalar.');

sampleTime = (0:0.01:1)';
[Func, Type, f_lim, A_lim, x] = MakeTestFile(sampleTime);
assert(isnumeric(x), 'MakeTestFile should return numeric signal data.');
assert(length(x) == length(sampleTime), 'Signal length should match the input vector length.');
assert(isnumeric(f_lim), 'Filter limits should be numeric.');
assert(isnumeric(A_lim), 'Attenuation limits should be numeric.');

w_lim = 2 * pi * f_lim(1:2);
A_lim_short = A_lim(1:2);
[N, w_c, Eps] = DecideParam(Func, Type, N_max, Alpha, w_lim, A_lim_short);
assert(isnumeric(N), 'DecideParam should return numeric order.');
assert(isnumeric(w_c), 'DecideParam should return numeric cutoff.');
assert(isnumeric(Eps), 'DecideParam should return numeric epsilon.');

Coeff = CalculateCoeff(Func, Type, N_max, N, Alpha, w_c, Eps);
assert(size(Coeff, 1) == 2, 'Coefficient matrix should have 2 rows.');
assert(size(Coeff, 2) >= 2, 'Coefficient matrix should contain at least 2 coefficients.');

A = [1 0.25 0.1];
B = [1 -0.2 0.05];
logPath = 'compatibility_log.txt';
[y, status] = ApplyFirst(Func, N, A, B, x(1:10), logPath);
assert(isnumeric(y), 'ApplyFirst should return numeric output.');
assert(isscalar(status), 'ApplyFirst status should be scalar.');

inputPath = [tempname '.txt'];
outputPath = [tempname '.txt'];
stateLogPath = [tempname '.txt'];
[yFirst, statusFirst] = ApplyFilter(Func, N, Coeff, x, inputPath, outputPath, ...
	stateLogPath, 1);
[yNext, statusNext] = ApplyFilter(Func, N, Coeff, x, inputPath, outputPath, ...
	stateLogPath, 0);
assert(length(yFirst) == length(x), 'First-period output should match input length.');
assert(length(yNext) == length(x), 'Next-period output should match input length.');
assert(isscalar(statusFirst), 'First-period status should be scalar.');
assert(isscalar(statusNext), 'Next-period status should be scalar.');
delete(inputPath);
delete(outputPath);
delete(stateLogPath);

fprintf('All MATLAB 2017 compatibility checks passed.\n');
end
