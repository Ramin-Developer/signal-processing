function [Func, Type, f_lim, A_lim, x] = MakeTestFile(t, cfg)

if nargin < 2
    cfg = SignalConfig();
end;
if ~isnumeric(t) || ~isvector(t) || any(~isfinite(t))
    error('SignalProcessing:InvalidTestTime', ...
        'Time input must be a finite numeric vector.');
end;
t = t(:);
Len = length(t);
x = zeros(Len, 1);
Func = cfg.testFilterFunction;
Type = cfg.testFilterType;
if ~isnumeric(Func) || ~isscalar(Func) || ~isfinite(Func) || ...
    Func ~= floor(Func) || Func < 0 || Func > 3
    error('SignalProcessing:InvalidTestConfiguration', ...
        'testFilterFunction must be an integer from 0 through 3.');
end;
if ~isnumeric(Type) || ~isscalar(Type) || ~isfinite(Type) || ...
    Type ~= floor(Type) || Type < 0 || Type > 1
    error('SignalProcessing:InvalidTestConfiguration', ...
        'testFilterType must be 0 or 1.');
end;

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
expectedLimitCount = 2 + 2 * (Func > 1);
if ~isnumeric(f_lim) || ~isvector(f_lim) || any(~isfinite(f_lim)) || ...
        numel(f_lim) ~= expectedLimitCount || ~isnumeric(A_lim) || ...
        ~isvector(A_lim) || any(~isfinite(A_lim)) || ...
        numel(A_lim) ~= expectedLimitCount
    error('SignalProcessing:InvalidTestConfiguration', ...
        'Selected test filter limits must be finite numeric vectors of matching length.');
end;

% Generate the input signal based on the value of Choice:
Omega = cfg.signalOmega;
Amp   = cfg.signalAmplitude;
if ~isnumeric(Omega) || ~isvector(Omega) || any(~isfinite(Omega)) || ...
        ~isnumeric(Amp) || ~isvector(Amp) || any(~isfinite(Amp)) || ...
        numel(Omega) ~= numel(Amp)
    error('SignalProcessing:InvalidTestConfiguration', ...
        'signalOmega and signalAmplitude must be finite numeric vectors of matching length.');
end;
for k = 1:1:length(Omega)
    x = x + Amp(k) * sin( Omega(k)*t );
end;
