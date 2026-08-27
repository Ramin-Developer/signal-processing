function Compare(f_n, Mag_Dir)
% Compare the results of the two methods by sketching the
% amplitudes and the dB-amplitudes in the same plot and
% finding the deviation between the amplitudes.

% Amplitudes:
plot(f_n, Mag_Dir(1, :), 'r');
legend('Direct Method');

xlabel('\it f [ Hz ]');
ylabel('\it Amplitude');
title('Amplitude of the frequency response');
grid;
pause;

% dB-amplitudes:
plot(f_n, Mag_Dir(2, :));
legend('Direct Method');

xlabel('\it f [ Hz ]');
ylabel('\it dB-Amplitude');
title('dB-Amplitude of the frequency response');
grid;
