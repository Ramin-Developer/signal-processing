% This script implements a band-pass filter in two different methods:
% First by applying the digital frequency transformation to a low-pass filter.
% Seccond by cascading a high-pass and a low-pass filter.
% Then we plot the result and compare them.

clear;
RegLen = 64;
RegNo = 1;
[Func, Type, Max_int, f_lim, A_lim] = FileInput;
if Func == 2 | Func == 3
    f1 = [f_lim(1) f_lim(2)];
    A1 = [A_lim(1) A_lim(2)];
    f2 = [f_lim(3) f_lim(4)];
    A2 = [A_lim(3) A_lim(4)];
end;

if Func == 2
    [N_b, Coeff_b, f_n, Mag_b] = ...
        FilterDesign0(2, Type, f_lim, A_lim, RegLen, RegNo);
    [N1, Coeff1, f_n, Mag1] = ...
         FilterDesign0(1, Type, f1, A1, RegLen, RegNo);
    [N2, Coeff2, f_n, Mag2] = ...
         FilterDesign0(0, Type, f2, A2, RegLen, RegNo);
 elseif Func == 3
    [N_b, Coeff_b, f_n, Mag_b] = ...
        FilterDesign0(3, Type, f_lim, A_lim, RegLen, RegNo);
    [N1, Coeff1, f_n, Mag1] = ...
         FilterDesign0(0, Type, f1, A1, RegLen, RegNo);
    [N2, Coeff2, f_n, Mag2] = ...
         FilterDesign0(1, Type, f2, A2, RegLen, RegNo);
 end;

Num1 = Coeff1(1, 1:N1+1);
Num2 = Coeff2(1, 1:N2+1);
Den1 = Coeff1(2, 1:N1+1);
Den2 = Coeff2(2, 1:N2+1);

% Cascading the high-pass and the low-pass filters:
N_cas = N1 + N2;
Num_cas = zeros(1, N_cas + 1);
Den_cas = zeros(1, N_cas + 1);
Num_cas = conv(Num1, Num2);
Den_cas(3:N_cas + 1)  = -conv( Den1(2:N1 + 1), Den2(2:N2 + 1) );
Den_cas(2:N1 + 1) = Den_cas(2:N1 + 1) + Den1(2:N1 + 1);
Den_cas(2:N2  + 1) = Den_cas(2:N2 + 1) + Den2(2:N2 + 1);
Coeff_cas = [Num_cas; Den_cas];

% Calculate the system function obtained by cascading a high-pass
% and a low-pass filter:
[Mag_cas, Phase_cas] = SysFunc(N_cas, f_n, Coeff_cas);
plot(f_n, Mag_cas(1, :), f_n, Mag_b(1, :));
legend('Cascade Solution', 'Bamd-Pass Solution');
grid;
xlabel('\it f [Hz]');
ylabel('Amplitude');
pause;
plot(f_n, Mag_cas(2, :), f_n, Mag_b(2, :));
legend('Cascade Solution', 'Bamd-Pass Solution');
grid;
xlabel('\it f [Hz]');
ylabel('dB-Amplitude');
