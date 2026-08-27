function [a, b] = Calc2DCoeff(Func, Type, k, N, Alpha, w_c, Eps)
% For Func = 0,1 / 2,3 determines the coefficients of a 2nd / 4th
% order digital filter. Index 0 <= "k" <= N/2 - 1 denotes the
% ordered number of the root for a corresponding low-pass filter.
% "w_c" is the Cut-off Frequency, "Eps" is the parameter in the
% Chebyshev filter Design.

% Calculate real and imaginary parts of the root:    
theta = (2*k + 1)*pi / ( 2*N );
x = cos( theta );
y = sin( theta );

if (Type == 0)
    Re_part = -y;
    Im_part =  x;
elseif (Type == 1)
    gamma = ( ( 1 + sqrt( 1 + Eps^2 ) ) / Eps )^( 1/N );
    mu = 0.5 *( gamma - 1/gamma );
    ny = 0.5 *( gamma + 1/gamma );
    Re_part = -mu * y;
    Im_part =  ny * x;
end;

% Obtain the coefficients corresponding to a second order
% digital low-pass filter with cut-off frequency equal to 1:
M = Re_part^2 + Im_part^2;
D = Alpha^2 - 2 * Alpha * Re_part + M;
X0 = 1/D;
X1 = 2/D;
X2 = 1/D;
Y1 = 2*(Alpha^2 - M) / D;
Y2 = -(Alpha^2 + 2 * Alpha * Re_part + M) / D;
X = [X0 X1 X2];
Y = [0 Y1 Y2];

% Low-pass to the desired filter transformation:
[a, b] = DigitalTransform(Func, w_c, X, Y);