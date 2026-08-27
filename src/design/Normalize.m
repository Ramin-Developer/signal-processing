function normalizationFactor = Normalize(Func, Type, N, w_c, Eps, Coeff)
% Calculate the normalization factor for the digital filter coefficients.

knownFrequency = w_c(1) / (2 * pi);
knownMagnitude = abs(FreqEval(N, knownFrequency, Coeff));

if Type == 0
    desiredMagnitude = 2^(-0.5);
elseif Type == 1
    desiredMagnitude = (1 + Eps^2)^(-0.5);
end;

normalizationFactor = desiredMagnitude / knownMagnitude;