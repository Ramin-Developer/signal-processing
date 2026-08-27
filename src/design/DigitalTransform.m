function [a, b] = DigitalTransform(Func, w_c, X, Y)
% Given X and Y as coefficients of a low-pass digital filter with
% 1 as cut-off frequency, apply the following transformations:
% a) Func == 0:     Low-pass to low-pass
% b) Func == 1:     Low-pass to high-pass
% c) Func == 2:     Low-pass to band-pass
% d) Func == 3:     Low-pass to band-stop.

X0 = X(1);
X1 = X(2);
X2 = X(3);
Y1 = Y(2);
Y2 = Y(3);

% Define the parameters in the digital frequency transformations:
if ( Func == 0 )
    beta = sin(0.5 - 0.5 * w_c) / sin(0.5 + 0.5 * w_c);
    beta2 = beta^2;
elseif ( Func == 1 )
    beta = -cos(0.5 + 0.5 * w_c) / cos(0.5 - 0.5 * w_c);
    beta2 = beta^2;
end;
if ( Func == 2 | Func == 3 )
    w1 = w_c( 1 );
    w2 = w_c( 2 );    
    eta = cos(0.5*w2 + 0.5*w1) / cos(0.5*w2 - 0.5*w1);
    if ( Func == 2 )
        ksi = cot(0.5*w2 - 0.5*w1) * tan( 0.5 );
        beta = (ksi - 1) / (ksi + 1);
        delta = -2*eta*ksi / (ksi + 1);
    end;
    if ( Func == 3 )
        ksi = tan(0.5*w2 - 0.5*w1) * tan( 0.5 );
        beta = (1 - ksi) / (1 + ksi);
        delta = -2*eta / (1 + ksi);
    end;
end;

% Low-pass to low-pass or low-pass to high-pass:
if ( Func == 0 | Func == 1 )
    D = 1 + beta*Y1 - beta2*Y2;
    A0 = (X0 - X1*beta + beta2*X2) / D;
    A1 = (X1 - 2*beta*X0 + beta2*X1 - 2*beta*X2) / D;
    A2 = (beta2*X0 - beta*X1 + X2) / D;
    B1 = (2*beta + Y1 + beta2*Y1 - 2*beta*Y2) / D;
    B2 = (-beta2 - Y1 * beta + Y2) / D;
    A3 = 0;
    A4 = 0;
    B3 = 0;
    B4 = 0;
    if ( Func == 1 )
        % Adjustment of coefficients in a high-pass filter:
        A1 = -A1;
        B1 = -B1;
    end;
end;

% Low-pass to band-pass or low-pass to band-stop:
if ( Func == 2 | Func == 3 )
    beta2 = beta^2;
    t1 = (1 + beta)*delta;
    t2 = 1 + beta2 + delta^2;
    t3 = 2*beta + delta^2;
    t4 = 2*beta*delta;
    if ( Func == 2 )
        D = 1 + beta*Y1 - beta2*Y2;
        A0 = (X0 - beta*X1 + beta2*X2) / D;
        A1 = (2*delta*X0 - t1*X1 + t4*X2) / D;
        A2 = (t3*(X0 + X2) - t2*X1) / D;
        A3 = (t4*X0 - t1*X1 + 2*delta*X2) / D;
        A4 = (beta2*X0 - beta*X1 + X2) / D;
        B1 = -(2*delta + t1*Y1 - t4*Y2) / D;
        B2 = -(t3*(1 - Y2) + t2*Y1) / D;
        B3 = -(t4 + t1*Y1 - 2*delta*Y2) / D;
        B4 = -(beta2 + beta*Y1 - Y2) / D;
    end;
    if ( Func == 3 )
        D = 1 - beta*Y1 - beta2*Y2;
        A0 = (X0 + beta*X1 + beta2*X2) / D;
        A1 = (2*delta*X0 + t1*X1 + t4*X2) / D;
        A2 = (t3*(X0 + X2) + t2*X1) / D;
        A3 = (t4*X0 + t1*X1 + 2*delta*X2) / D;
        A4 = (beta2*X0 + beta*X1 + X2) / D;
        B1 = -(2*delta - t1*Y1 - t4*Y2) / D;
        B2 = -(t3*(1 - Y2) - t2*Y1) / D;
        B3 = -(t4 - t1*Y1 - 2*delta*Y2) / D;
        B4 = -(beta2 - beta*Y1 - Y2) / D;
    end;
end;

% Establish the coefficient vectors:
a = [A0 A1 A2 A3 A4];
b = [1  B1 B2 B3 B4];
