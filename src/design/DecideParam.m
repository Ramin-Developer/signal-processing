function [N, w_c, Eps] = ...
         DecideParam(Func, Type, N_max, Alpha, w_lim, A_lim)
% Given the type, limiting frequencies and attenuations in "Type",
% "f_lim" and "A_lim", for a low-pass filter, obtain the design
% parameters for a filter with function "Func" in the output
% variables N, w_c, Eps.

if Func == 0 | Func == 1
    Len = 1;
elseif Func == 2 | Func == 3
    Len = 2;
end;
N = zeros(Len, 1);
Eps = zeros(Len, 1);
w_c = zeros(Len, 1);

% Prewarping the digital frequencies:
Omega_lim = Alpha * tan( w_lim/2 );

% Constants for a low-pass filter:
C_lim = 10.^( A_lim/10 ) - 1;
den = Omega_lim(:, 2) ./ Omega_lim(:, 1);

% Calculate the Filter order:
if Type == 0
    N = 0.5 * log10( C_lim(:, 2) ./ C_lim(:, 1) ) ./ log10( den );
elseif Type == 1
    Eps = sqrt( C_lim(:, 1) );
    N = acosh( sqrt( C_lim(:, 2) ) ./ Eps ) ./ acosh( den );
end;

% Filter order must be an even integer 2 <= N <= N_max:
N = ceil( max( N ) );
if ( mod(N, 2) ~= 0 )
    N = N + 1;
end;

% Calculate the digital cut-off frequencies:
if Type == 0
    Omega_c = Omega_lim(:, 1) .* C_lim(:, 1) .^ ( -1 ./ (2*N) );
    w_c = 2 * atan(Omega_c / Alpha);
elseif Type == 1
    % For a Chebyshev-1 filter the cut-off frequency is equal to w_p:
    w_c = w_lim(:, 1);
end;

% Decide N and Eps for a band-pass or band-stop filter:
if (Func == 2 | Func == 3)
    N = 2*N;
end;
Eps = min( Eps );

% Transform the cut-off frequencies for the actual filter:
if Func == 1
    w_c = pi - w_c;    
elseif Func == 2
    w_c = [pi - w_c( 1 )       w_c(2)];    
elseif Func == 3
    w_c = [w_c( 1 )            pi - w_c( 2 )];    
end;
