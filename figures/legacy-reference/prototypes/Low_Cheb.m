
clear;
Order = [2 5 6];
L_Order = length( Order );
Omega_c = 2;
Omega = 0:0.05:4;
L_Omega = length( Omega );

H_a = zeros(L_Order, L_Omega);
Eps = 0.4;
for k = 1:L_Order
    N = Order( k );
    T = cos( N*acos(Omega/Omega_c) );
    H_a(k, :) = 1 ./ ( 1 + (Eps*T ).^2 );
end;

plot(Omega, H_a(1, :), 'r', Omega, H_a(2, :), 'b.-.', Omega, H_a(3, :), 'm--o');
legend('N = 2', 'N = 5', 'N = 6');
xlabel('\Omega');
ylabel('( H_a( j \Omega) )^2');
grid;

print -depsc -tiff -r300 Low_Cheb.eps