function Res = FreqEval(N, f, Coeff)
% Given the decimal coefficients as A = Coeff(1, 1:N+1) and
% B = Coeff(2, 1:N+1), evaluate the frequency response at 
% the points given by the normalized frequency variable f.

Len = length( f );
w = 2*pi*f;
Res = zeros(1, Len);
A = Coeff(1, 1:N+1);
B = Coeff(2, 1:N+1);

% Construct the exponentials:
Exponent = zeros(N+1, Len);
Exponent(1, :) = ones(1, Len);

for k = 1:1:N
    for m = 1:1:Len
        Exponent(k + 1, m) = Exponent(k, m) * exp(-j * w(m) );
    end;
end;
% Construct the magnitude of system function:
num = A * Exponent;
den = B * Exponent;
Res = num ./ (1 - den);
