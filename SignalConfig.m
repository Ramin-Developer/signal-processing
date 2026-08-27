function cfg = SignalConfig()
% Centralized configuration for the MATLAB signal-processing scripts.
% Keeping these values in one place reduces magic numbers and makes refactors safer.

cfg = struct();

cfg.filterOrderMax = 20;
cfg.alpha = 1 / tan(0.5);
cfg.frequencyVectorLength = 2001;
cfg.frequencyStart = 0;
cfg.frequencyEnd = 0.5;
cfg.defaultSignalSets = 6;
cfg.defaultSignalLength = 1000;
cfg.coefficientStartIndex = 5;
cfg.minPeriodicSignalLength = 1000;
cfg.maxIterations = 10;
cfg.signalOmega = [1 50 100] * pi;
cfg.signalAmplitude = [1 0.05 0.05];
cfg.testFilterFunction = 0;
cfg.testFilterType = 0;
cfg.lowPassFrequencyLimits = [0.01 0.02];
cfg.lowPassAttenuationLimits = [0.1 20];
cfg.highPassFrequencyLimits = [0.01 0.024];
cfg.highPassAttenuationLimits = [20 0.1];
cfg.bandPassFrequencyLimits = [0.01 0.02 0.03 0.049];
cfg.bandPassAttenuationLimits = [20 0.5 0.5 20];
cfg.bandStopFrequencyLimits = [0.01 0.02 0.03 0.049];
cfg.bandStopAttenuationLimits = [0.01 20 20 0.01];
cfg.inputFilePath = 'InputFile.txt';
cfg.lastInputSignalPath = 'LastInSignal.txt';
cfg.lastOutputSignalPath = 'LastOutSignal.txt';
cfg.logFilePath = 'LogFile.txt';
