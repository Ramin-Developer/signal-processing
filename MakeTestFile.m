function [Func, Type, f_lim, A_lim, x] = MakeTestFile(t)

Len = length(t);
Ts = 1/Len;
x = zeros(Len, 1);
Func = 0;
Type = 0;

% Make critical frequencies and attenuations:
if (Func == 0)
    f_lim = [0.01   0.02];
    A_lim = [0.1       20];
elseif (Func == 1)
    f_lim = [0.01   0.024];
    A_lim = [20     0.1];
elseif (Func == 2)
    f_lim = [0.01   0.02   0.03   0.049];
    A_lim = [20     0.5    0.5      20];
elseif (Func == 3)
    f_lim = [0.01   0.02   0.03   0.049];
    A_lim = [0.01     20      20     0.01];
end;

% Generate the input signal based on the value of Choice:
Omega = [1    50      100]*pi;
Amp   = [1    0.05    0.05];
for k = 1:1:length(Omega)
    x = x + Amp(k) * sin( Omega(k)*t );
end;
