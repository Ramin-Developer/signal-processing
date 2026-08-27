function [Func, Type, f_lim, A_lim, x] = MakeTestFile(t)

cfg = SignalConfig();
Len = length(t);
x = zeros(Len, 1);
Func = cfg.testFilterFunction;
Type = cfg.testFilterType;

% Make critical frequencies and attenuations:
if (Func == 0)
    f_lim = cfg.lowPassFrequencyLimits;
    A_lim = cfg.lowPassAttenuationLimits;
elseif (Func == 1)
    f_lim = cfg.highPassFrequencyLimits;
    A_lim = cfg.highPassAttenuationLimits;
elseif (Func == 2)
    f_lim = cfg.bandPassFrequencyLimits;
    A_lim = cfg.bandPassAttenuationLimits;
elseif (Func == 3)
    f_lim = cfg.bandStopFrequencyLimits;
    A_lim = cfg.bandStopAttenuationLimits;
end;

% Generate the input signal based on the value of Choice:
Omega = cfg.signalOmega;
Amp   = cfg.signalAmplitude;
for k = 1:1:length(Omega)
    x = x + Amp(k) * sin( Omega(k)*t );
end;
