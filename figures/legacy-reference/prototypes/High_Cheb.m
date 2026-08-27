
clear;
Order = [4 5];
L_Order = length( Order );
Omega_p = 2.0;
Omega_s = 2.2;
Omega = 0.01:0.05:10;
L_Omega = length( Omega );

H_lp = zeros(L_Order, L_Omega);
H_hp = zeros(L_Order, L_Omega);
Eps = 0.8;
for k = 1:L_Order
    N = Order( k );
    T2 = cos( N*acos(Omega_s / Omega_p) ) ./ cos( N*acos(Omega_s ./ Omega) );
    H_lp(k, :) = 1 ./ ( 1 + (Eps*T2 ).^2 );
end;
H_hp = 1 - H_lp;
plot(Omega, H_hp(1, :), 'r', Omega, H_hp(2, :), 'g+');
legend('N = 4', 'N = 5', 0);
xlabel('\Omega');
ylabel('( H_a( j \Omega) )^2');
grid;

print -depsc -tiff -r300 High_Cheb.eps