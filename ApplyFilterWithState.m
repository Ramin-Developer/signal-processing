function [y, Status, state] = ApplyFilterWithState(Func, N, Coeff, x, state, FirstPeriod)
% Apply a filter using explicit in-memory state instead of state files.

if ~isscalar(N) || N < 1 || N ~= floor(N)
    error('SignalProcessing:InvalidFilterOrder', ...
        'Filter order N must be a positive integer.');
end;
if size(Coeff, 1) < 2 || size(Coeff, 2) < N + 1
    error('SignalProcessing:InvalidFilterCoefficients', ...
        'Coefficient matrix must contain two rows and at least N + 1 columns.');
end;
ValidateFilterStability(Coeff, N);
if ~isvector(x) || size(x, 2) ~= 1 || length(x) < N
    error('SignalProcessing:InvalidInputSignal', ...
        'Input signal must be a column vector with at least N samples.');
end;
if ~isscalar(FirstPeriod) || (FirstPeriod ~= 0 && FirstPeriod ~= 1)
    error('SignalProcessing:InvalidFilterPeriod', ...
        'FirstPeriod must be 0 or 1.');
end;

A = Coeff(1, :);
B = Coeff(2, :);
if FirstPeriod == 1
    [y, Status] = ApplyFirst(Func, N, A, B, x);
else
    if ~isstruct(state) || ~isfield(state, 'inputSignal') || ...
            ~isfield(state, 'outputSignal') || ~isfield(state, 'status') || ...
            ~isvector(state.inputSignal) || ~isvector(state.outputSignal) || ...
            length(state.inputSignal) < N || length(state.outputSignal) < N
        error('SignalProcessing:InvalidFilterState', ...
            'State must contain at least N input and output samples and a status.');
    end;
    x_t = [state.inputSignal(end - N + 1:end); x];
    y_t = [state.outputSignal(end - N + 1:end); zeros(length(x), 1)];
    y_t = ApplyDifferenceEquation(A, B, x_t, y_t, N);
    y = y_t(N + 1:end);
    Status = 0;
    if state.status == 1
        Status = 1;
    end;
end;

state = struct('inputSignal', x, 'outputSignal', y, 'status', Status);
end