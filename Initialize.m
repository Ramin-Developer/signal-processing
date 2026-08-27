function [InputFile, LastInSignal, LastOutSignal, LogFile, N_max, f_n, Alpha] = Initialize
% Initialize the upstart variables and set the constants of the problem.

cfg = SignalConfig();

InputFile     = 'InputFile.txt';        % File containing all input parameters
LastOutSignal = 'LastOutSignal.txt';    % File containing last output signal
LastInSignal  = 'LastInSignal.txt';     % File containing last input signal
LogFile       = 'LogFile.txt';          % File containing status.

% Problem constants:
N_max = cfg.filterOrderMax;             % Maximum accepted order of filter.
Alpha = cfg.alpha;                      % Maps Omega = 1 to w = 1:

% Construct a frequency vector of length Len_f from Start to End:
Len_f = cfg.frequencyVectorLength;
Start = cfg.frequencyStart;
End = cfg.frequencyEnd;
delta = (End - Start) / (Len_f - 1);
f_n = Start:delta:End;
