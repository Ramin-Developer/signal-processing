function [Mag, Phase] = FreqRes(N, f_n, Coeff)
% Given the decimal coefficients as A = Coeff(1, 1:N+1) and
% B = Coeff(2, 1:N+1), calculate the phase and the magnitude
% (amplitude and dB-amplitude) of the frequency response given by:
%        N                                  N
% H(z) = Sum( A(k+1)*exp^(-k*j*w) ) / (1 - Sum( B(k+1)*z^(-k*j*w) )),
%        k=0                               k = 0
% where w = 2*pi*f.

Len_f = length( f_n );
H = FreqEval(N, f_n, Coeff);

Real_H = real( H );
Imag_H = imag( H );
Mag(1, :) = abs( H );
Mag(2, :) = 20*log10( Mag(1, :) );
Phase = atan( Imag_H ./ Real_H );
for k = 1:1:Len_f
    if ( Real_H( k ) <= 0 & Imag_H( k ) <= 0 )
        Phase( k ) = Phase( k ) - pi;
    elseif ( Real_H( k ) < 0 & Imag_H( k ) > 0 )
        Phase( k ) = Phase( k ) + pi;
    end;
end;
Phase = (180 / pi) * Phase;
