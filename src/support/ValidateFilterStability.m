function ValidateFilterStability(Coeff, N)
% Validate that a direct-form filter can be safely evaluated by the recurrence.

A = Coeff(1, 1:N + 1);
B = Coeff(2, 1:N + 1);
if ~isnumeric(Coeff) || ~isreal(Coeff) || any(~isfinite(A)) || any(~isfinite(B))
    error('SignalProcessing:InvalidFilterCoefficients', ...
        'Filter coefficients must be finite real values.');
end;
if B(1) ~= 0
    error('SignalProcessing:InvalidFilterCoefficients', ...
        'The zero-delay feedback coefficient must be zero.');
end;

filterPoles = roots([1 -B(2:end)]);
if any(abs(filterPoles) >= 1)
    error('SignalProcessing:UnstableFilter', ...
        'Filter poles must be strictly inside the unit circle.');
end;
end