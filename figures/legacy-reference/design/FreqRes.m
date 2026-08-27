function [Mag, Phase] = FreqRes(N, f_n, Coeff)
% Given the decimal coefficients as A = Coeff(1, 1:N+1) and
% B = Coeff(2, 1:N+1), calculate the phase and the magnitude
% (amplitude and dB-amplitude) of the frequency response given by:
%        N                                  N
% H(z) = Sum( A(k+1)*exp^(-k*j*w) ) / (1 - Sum( B(k+1)*z^(-k*j*w) )),
%        k=0                               k = 0
% where w = 2*pi*f.

Len_f = length( f_n );
Mag = zeros(Len_f, 2);
Phase = zeros(Len_f, 1);
num = Coeff(1, :);
den = [1 -Coeff(2, 2:end)];
[H, Phase] = freqz(num, den, Len_f);
Mag(:, 1) = abs( H );
Mag(:, 2) = -20*log10( Mag(:, 1) );
