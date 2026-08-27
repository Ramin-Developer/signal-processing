function Coeff = CalculateCoeff(Func, Type, N_max, N, Alpha, w_c, Eps)
% Calculate the coefficients of a normalized digital N-th order
% system function with cut-off frequency w_c given by:
%   H( z ) = ( a0 + a1*z^(-1) + ... + a(N)*z^(-N) ) / ...
%            ( 1  - b1*z^(-1) - ... - b(N)*z^(-N) ).
% The filter order N must be an even integer,  2 <= N <= N_max.
% "Alpha" is the constant in the bilinear transformation.

Start = 5;
% Obtain the order of a corresponding low-pass filter, N_lp:
if (Func == 0 | Func == 1)
    N_lp = N;
elseif Func == 2 | Func == 3
    N_lp = N/2;
end;

Coeff = zeros(2, N_max + 1);
A = zeros(1, N_max+Start);
B = zeros(1, N_max+Start);
A( Start ) = 1;
B( Start ) = 1;

Status = 0;
for k = 1:1:N_lp/2
    [a, b] = Calc2DCoeff(Func, Type, k-1, N_lp, Alpha, w_c, Eps);
    Atemp = A;
    Btemp = B;
    for i = Start:1:N_max + Start
        A( i ) =  a(1) * Atemp(i) + a(2) * Atemp(i - 1) ...
                + a(3) * Atemp(i - 2) + a(4) * Atemp(i - 3) ...
                + a(5) * Atemp(i - 4);
        B( i ) =  b(1) * Btemp(i) - b(2) * Btemp(i - 1) ...
                - b(3) * Btemp(i - 2) - b(4) * Btemp(i - 3) ...
                - b(5) * Btemp(i - 4);
    end;
end;
B( Start ) = 0;
Coeff(1, :) =  A(Start:1:N_max + Start);
Coeff(2, :) = -B(Start:1:N_max + Start);

% Find the normilizing factor and scale the coefficients accordingly:
NormFactor = Normilize(Func, Type, N, w_c, Eps, Coeff);
Coeff(1, :) = Coeff(1, :) * NormFactor;