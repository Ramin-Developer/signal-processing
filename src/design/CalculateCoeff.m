function coefficients = CalculateCoeff(Func, Type, N_max, N, Alpha, w_c, Eps)
% Calculate the coefficients of a normalized digital N-th order
% system function with cut-off frequency w_c given by:
%   H( z ) = ( a0 + a1*z^(-1) + ... + a(N)*z^(-N) ) / ...
%            ( 1  - b1*z^(-1) - ... - b(N)*z^(-N) ).
% The filter order N must be an even integer,  2 <= N <= N_max.
% "Alpha" is the constant in the bilinear transformation.

cfg = SignalConfig();
coefficientStartIndex = cfg.coefficientStartIndex;
% Obtain the order of a corresponding low-pass filter:
if (Func == 0 | Func == 1)
    lowPassOrder = N;
elseif Func == 2 | Func == 3
    lowPassOrder = N/2;
end;

coefficients = zeros(2, N_max + 1);
numerator = zeros(1, N_max + coefficientStartIndex);
feedback = zeros(1, N_max + coefficientStartIndex);
numerator(coefficientStartIndex) = 1;
feedback(coefficientStartIndex) = 1;

for rootIndex = 1:lowPassOrder/2
    [sectionNumerator, sectionFeedback] = Calc2DCoeff(Func, Type, rootIndex - 1, ...
        lowPassOrder, Alpha, w_c, Eps);
    previousNumerator = numerator;
    previousFeedback = feedback;
    for coefficientIndex = coefficientStartIndex:N_max + coefficientStartIndex
        numerator(coefficientIndex) = sectionNumerator(1) * previousNumerator(coefficientIndex) ...
            + sectionNumerator(2) * previousNumerator(coefficientIndex - 1) ...
            + sectionNumerator(3) * previousNumerator(coefficientIndex - 2) ...
            + sectionNumerator(4) * previousNumerator(coefficientIndex - 3) ...
            + sectionNumerator(5) * previousNumerator(coefficientIndex - 4);
        feedback(coefficientIndex) = sectionFeedback(1) * previousFeedback(coefficientIndex) ...
            - sectionFeedback(2) * previousFeedback(coefficientIndex - 1) ...
            - sectionFeedback(3) * previousFeedback(coefficientIndex - 2) ...
            - sectionFeedback(4) * previousFeedback(coefficientIndex - 3) ...
            - sectionFeedback(5) * previousFeedback(coefficientIndex - 4);
    end;
end;
feedback(coefficientStartIndex) = 0;
coefficients(1, :) = numerator(coefficientStartIndex:N_max + coefficientStartIndex);
coefficients(2, :) = -feedback(coefficientStartIndex:N_max + coefficientStartIndex);

% Find the normalization factor and scale the coefficients accordingly:
normalizationFactor = Normalize(Func, Type, N, w_c, Eps, coefficients);
coefficients(1, :) = coefficients(1, :) * normalizationFactor;