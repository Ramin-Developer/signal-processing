function NormFactor = Normilize(Func, Type, N, w_c, Eps, Coeff)
% Obtain the normalizing factor by calculating the value of the system
% function at w_c. The magnitude response of a normalized Butterworth
% and Chebyshev-1 at this point is equal to:
% 1/sqrt(2) and 1/( sqrt(1 + Eps^2) ), respectively.

f_known = w_c( 1 ) / (2 * pi);
H_known = abs( FreqEval(N, f_known, Coeff) );

if (Type == 0)
    H_d = 2^(-0.5);
elseif (Type == 1)
    H_d = (1 + Eps^2)^(-0.5);
end;

% Normalizing factor;
NormFactor = H_d / H_known;