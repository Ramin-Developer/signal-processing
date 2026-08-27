function [Deviation] = Compare(f_n, Mag_Dir, Mag_Back)
% Compare the results of the two methods by sketching the
% amplitudes and the dB-amplitudes in the same plot and
% finding the deviation between the amplitudes.

% Amplitudes:
plot(f_n, Mag_Dir(:, 1), 'r', f_n, Mag_Back(:, 1), 'm.-.');
legend('Direct Method', 'Backward Method', 0);

xlabel('\it f [ Hz ]');
ylabel('\it Amplitude');
title('Amplitude of the frequency response');
grid;
pause;

% dB-amplitudes:
plot(f_n, Mag_Dir(:, 2), 'r', f_n, Mag_Back(:, 2), 'm.-.');
legend('Direct Method', 'Backward Method', 0);

xlabel('\it f [ Hz ]');
ylabel('\it dB-Amplitude');
title('dB-Amplitude of the frequency response');
grid;
pause;

% The error in dB-amplitude:
Diff = abs( Mag_Dir(:, 1) - Mag_Back(:, 1) );
plot(f_n, Diff, 'r');
xlabel('\it f [ Hz ]');
ylabel('\it Amplitude');
title('Error between the Direct and the Backward methods');
grid;
Deviation = norm(Diff, 2);
