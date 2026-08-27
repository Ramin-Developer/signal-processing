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
