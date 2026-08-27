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
assert(isfield(cfg, 'lastInputSignalPath'), 'SignalConfig missing lastInputSignalPath.');
assert(isfield(cfg, 'lastOutputSignalPath'), 'SignalConfig missing lastOutputSignalPath.');
assert(isfield(cfg, 'testFilterFunction'), 'SignalConfig missing testFilterFunction.');
assert(isfield(cfg, 'lowPassFrequencyLimits'), 'SignalConfig missing lowPassFrequencyLimits.');
assert(cfg.filterOrderMax > 0, 'filterOrderMax should be positive.');

[InputFile, LastInSignal, LastOutSignal, LogFile, N_max, f_n, Alpha] = Initialize();
assert(ischar(InputFile), 'Initialize should return a filename string.');
assert(strcmp(LastInSignal, cfg.lastInputSignalPath), 'Unexpected input state path.');
assert(strcmp(LastOutSignal, cfg.lastOutputSignalPath), 'Unexpected output state path.');
assert(strcmp(LogFile, cfg.logFilePath), 'Unexpected log path.');
assert(isnumeric(f_n), 'Initialize should return a numeric frequency vector.');
assert(length(f_n) > 1, 'Frequency vector should contain more than one point.');
assert(isnumeric(Alpha) && isscalar(Alpha), 'Alpha should be a scalar.');

sampleTime = (0:0.01:1)';
[Func, Type, f_lim, A_lim, x] = MakeTestFile(sampleTime);
assert(isnumeric(x), 'MakeTestFile should return numeric signal data.');
assert(length(x) == length(sampleTime), 'Signal length should match the input vector length.');
assert(isnumeric(f_lim), 'Filter limits should be numeric.');
assert(isnumeric(A_lim), 'Attenuation limits should be numeric.');
assert(isequal(f_lim, cfg.lowPassFrequencyLimits), 'Unexpected default filter limits.');
assert(isequal(A_lim, cfg.lowPassAttenuationLimits), 'Unexpected default attenuation limits.');

[~, ~, ~, ~, rowTimeSignal] = MakeTestFile(sampleTime');
assert(isequal(size(rowTimeSignal), size(sampleTime)), ...
	'Row time input should produce a column signal.');

invalidTestTimeErrorRaised = false;
try
	MakeTestFile([0 NaN]);
catch exception
	invalidTestTimeErrorRaised = strcmp(exception.identifier, 'SignalProcessing:InvalidTestTime');
end;
assert(invalidTestTimeErrorRaised, 'Invalid test time input should raise a clear error.');

invalidTestConfig = cfg;
invalidTestConfig.testFilterFunction = 4;
invalidTestConfigErrorRaised = false;
try
	MakeTestFile(sampleTime, invalidTestConfig);
catch exception
	invalidTestConfigErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:InvalidTestConfiguration');
end;
assert(invalidTestConfigErrorRaised, 'Invalid test configuration should raise a clear error.');

invalidTestConfig = cfg;
invalidTestConfig.testFilterFunction = 'a';
invalidTestConfigErrorRaised = false;
try
	MakeTestFile(sampleTime, invalidTestConfig);
catch exception
	invalidTestConfigErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:InvalidTestConfiguration');
end;
assert(invalidTestConfigErrorRaised, 'Nonnumeric test configuration should raise a clear error.');

invalidTestConfig = cfg;
invalidTestConfig.lowPassFrequencyLimits = 0.01;
invalidTestConfigErrorRaised = false;
try
	MakeTestFile(sampleTime, invalidTestConfig);
catch exception
	invalidTestConfigErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:InvalidTestConfiguration');
end;
assert(invalidTestConfigErrorRaised, 'Malformed test filter limits should raise a clear error.');

invalidTestConfig = cfg;
invalidTestConfig.signalAmplitude = cfg.signalAmplitude(1:2);
invalidTestConfigErrorRaised = false;
try
	MakeTestFile(sampleTime, invalidTestConfig);
catch exception
	invalidTestConfigErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:InvalidTestConfiguration');
end;
assert(invalidTestConfigErrorRaised, 'Mismatched waveform configuration should raise a clear error.');

w_lim = 2 * pi * f_lim(1:2);
A_lim_short = A_lim(1:2);
[N, w_c, Eps] = DecideParam(Func, Type, N_max, Alpha, w_lim, A_lim_short);
assert(isnumeric(N), 'DecideParam should return numeric order.');
assert(isnumeric(w_c), 'DecideParam should return numeric cutoff.');
assert(isnumeric(Eps), 'DecideParam should return numeric epsilon.');

invalidDesignLogPath = [tempname '.txt'];
invalidSpecificationErrorRaised = false;
try
	DesignParam(Func, Type, [f_lim(2) f_lim(1)], A_lim, N_max, Alpha, ...
		invalidDesignLogPath);
catch exception
	invalidSpecificationErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:InvalidFilterSpecification');
end;
assert(invalidSpecificationErrorRaised, 'Invalid filter limits should raise a clear error.');
assert(ReadFilterStatus(invalidDesignLogPath) == 2, ...
	'Invalid filter limits should persist an alarm status before design.');
delete(invalidDesignLogPath);

Coeff = CalculateCoeff(Func, Type, N_max, N, Alpha, w_c, Eps);
assert(size(Coeff, 1) == 2, 'Coefficient matrix should have 2 rows.');
assert(size(Coeff, 2) >= 2, 'Coefficient matrix should contain at least 2 coefficients.');
ValidateFilterStability(Coeff, N);

A = [1 0.25 0.1];
B = [1 -0.2 0.05];
testOrder = 2;
logPath = 'compatibility_log.txt';
[y, status] = ApplyFirst(Func, testOrder, A, B, x(1:10), logPath);
assert(isnumeric(y), 'ApplyFirst should return numeric output.');
assert(isscalar(status), 'ApplyFirst status should be scalar.');
delete(logPath);

slowConvergenceLogPath = [tempname '.txt'];
[~, slowConvergenceStatus] = ApplyFirst(1, 1, [1 0], [0 0.999], ...
	ones(cfg.minPeriodicSignalLength, 1), slowConvergenceLogPath);
assert(slowConvergenceStatus == 1, ...
	'Initialization that exceeds the iteration limit should return a warning.');
delete(slowConvergenceLogPath);

inputPath = [tempname '.txt'];
outputPath = [tempname '.txt'];
stateLogPath = [tempname '.txt'];
unstableFilterErrorRaised = false;
try
	ApplyFilter(Func, 1, [1 0; 0 1.01], x(1:2), inputPath, outputPath, ...
		stateLogPath, 1);
catch exception
	unstableFilterErrorRaised = strcmp(exception.identifier, 'SignalProcessing:UnstableFilter');
end;
assert(unstableFilterErrorRaised, 'Unstable coefficients should raise a clear error.');
assert(ReadFilterStatus(stateLogPath) == 2, ...
	'Unstable coefficients should persist an alarm status before filtering.');
[yFirst, statusFirst] = ApplyFilter(Func, N, Coeff, x, inputPath, outputPath, ...
	stateLogPath, 1);
[yNext, statusNext] = ApplyFilter(Func, N, Coeff, x, inputPath, outputPath, ...
	stateLogPath, 0);
assert(length(yFirst) == length(x), 'First-period output should match input length.');
assert(length(yNext) == length(x), 'Next-period output should match input length.');
assert(isscalar(statusFirst), 'First-period status should be scalar.');
assert(isscalar(statusNext), 'Next-period status should be scalar.');
assert(ReadFilterStatus(stateLogPath) == statusNext, 'Persisted status should match output.');
delete(inputPath);
delete(outputPath);
delete(stateLogPath);

shortInputPath = [tempname '.txt'];
shortOutputPath = [tempname '.txt'];
shortLogPath = [tempname '.txt'];
WriteFilterState(shortInputPath, shortOutputPath, 0, 0);
shortStateErrorRaised = false;
try
	ApplyNext(Func, testOrder, A, B, x(1:2), shortInputPath, shortOutputPath, shortLogPath);
catch exception
	shortStateErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:InsufficientFilterState');
end;
assert(shortStateErrorRaised, 'Short filter state should raise a clear error.');
delete(shortInputPath);
delete(shortOutputPath);

invalidStatusPath = [tempname '.txt'];
invalidStatusHandle = fopen(invalidStatusPath, 'wt');
fprintf(invalidStatusHandle, 'invalid');
fclose(invalidStatusHandle);
invalidStatusErrorRaised = false;
try
	ReadFilterStatus(invalidStatusPath);
catch exception
	invalidStatusErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:InvalidFilterStatus');
end;
assert(invalidStatusErrorRaised, 'Malformed status should raise a clear error.');
delete(invalidStatusPath);

invalidCoefficientsErrorRaised = false;
try
	ApplyFilter(Func, testOrder, [1 0; 1 0], x(1:2), inputPath, outputPath, ...
		stateLogPath, 1);
catch exception
	invalidCoefficientsErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:InvalidFilterCoefficients');
end;
assert(invalidCoefficientsErrorRaised, 'Malformed coefficients should raise a clear error.');

missingStateDirectory = tempname;
invalidStateWriteErrorRaised = false;
try
	WriteFilterState(fullfile(missingStateDirectory, 'input.txt'), ...
		fullfile(missingStateDirectory, 'output.txt'), 0, 0);
catch exception
	invalidStateWriteErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:StateFileOpenFailed');
end;
assert(invalidStateWriteErrorRaised, 'Invalid state paths should raise a clear error.');

designLogPath = [tempname '.txt'];
designOrderErrorRaised = false;
try
	DesignParam(Func, Type, f_lim, A_lim, 0, Alpha, designLogPath);
catch exception
	designOrderErrorRaised = strcmp(exception.identifier, ...
		'SignalProcessing:FilterOrderExceeded');
end;
assert(designOrderErrorRaised, 'Excessive filter order should raise a clear error.');
assert(ReadFilterStatus(designLogPath) == 2, 'Filter-order failure should persist alarm status.');
delete(designLogPath);

MATLAB_FILTER_DESIGN_STRESS_TESTS();

fprintf('All MATLAB 2017 compatibility checks passed.\n');
end
