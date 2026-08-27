function Mag_Back = Backward(N, Len_f, Coeff_Back, Scale)
% Send an impule into the system and calculate the magnitude
% response using the integer coefficients of the Backward Method.

A = [Coeff_Back(1, 1:N+1)]';
B = [Coeff_Back(2, 1:N+1)]';

Lx = 2*Len_f + 1;
x = zeros(Lx, 1);
Mid = Len_f + 1;
x( Mid ) = 1;
Mag_Back = zeros(Len_f, 2);
h = zeros(Lx, 1);

for n = Len_f + 1:1:Lx
    hTemp = h(n:-1:n - N);
    xTemp = x(n:-1:n - N);
    h1 = sum( A .* xTemp ) / Scale;
    h2 = sum( B .* hTemp ) / Scale;
    h( n ) = h1 + h2;
end;

% Construct the amplitude and dB_amplitude of the Backward Method.
H = fft( h );
Mag_Back(:, 1) = abs( H( 1:1:Len_f ) );
Mag_Back(:, 2) = -20*log10( Mag_Back(:, 1) );
