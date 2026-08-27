function Made = MakeInputFile(InputFile, Choice, RandomSeed)

cfg = SignalConfig();
Len = cfg.defaultSignalLength;
Ts = 1/Len;
t = 0:Ts:1 - Ts;
x = zeros(Len, 1);
mid = fix(Len/2);
testConfig = cfg;
testConfig.testFilterFunction = cfg.legacyInputFilterFunction;
testConfig.testFilterType = cfg.legacyInputFilterType;
[Func, Type, f_lim, A_lim, sineSignal] = MakeTestFile(t', testConfig);
FirstPeriod = cfg.legacyInputFirstPeriod;

if nargin < 2
    Choice = input('Choice : ');
end;
if ~isnumeric(Choice) || ~isscalar(Choice) || Choice ~= floor(Choice) || ...
        Choice < 0 || Choice > 3
    error('SignalProcessing:InvalidInputSignalChoice', ...
        'Choice must be an integer from 0 through 3.');
end;
if nargin >= 3 && (~isnumeric(RandomSeed) || ~isscalar(RandomSeed) || ...
        ~isfinite(RandomSeed) || RandomSeed ~= floor(RandomSeed) || RandomSeed < 0)
    error('SignalProcessing:InvalidRandomSeed', ...
        'RandomSeed must be a nonnegative integer.');
end;

if Choice == 0
    x(mid) = 1;
elseif Choice == 1
    x(mid:end) = 1;
elseif Choice == 2
    x = sineSignal;
else
    if nargin >= 3
        previousRandomState = rng;
        cleanupRandomState = onCleanup(@() rng(previousRandomState));
        rng(RandomSeed);
    end;
    x = rand(Len, 1);
end;

h_input = fopen(InputFile, 'wt');
if h_input == -1
    error('SignalProcessing:InputFileOpenFailed', 'Unable to open the input file for writing.');
end;
fprintf(h_input, '%-16.12g\n', Func);
fprintf(h_input, '%-16.12g\n', Type);
fprintf(h_input, '%-16.12g\t', f_lim);
fprintf(h_input, '\n');
fprintf(h_input, '%-16.12g\t', A_lim);
fprintf(h_input, '\n');
fprintf(h_input, '%-16.12g\n', FirstPeriod);
fprintf(h_input, '%-16.12g\n', x);
Made = fclose(h_input);
