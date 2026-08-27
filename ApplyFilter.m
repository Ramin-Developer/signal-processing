function [y, Status] = ApplyFilter(Func, N, Coeff, x, LastInSignal, LastOutSignal, ...
                       LogFile, FirstPeriod)
% Construct the filter output given the filter coefficients and order in Coeff and N.
% If (FirstPeriod == 1) we assume periodicity in the time domain to extend the input 
% signal. Iterations are made to satisfy the convergence (at most 10 times).
% For the output values two different initializations are used:
% 1) Mean value of the input for low-pass and band-stop.
% 2) 0 for high-pass and band-pass profile.
% If (FirstPeriod == 0), then the first N values of the input and output signal are
% read from the last input and output signal.

A = Coeff(1, :);
B = Coeff(2, :);
Lx = length(x);     % Initial length of the input.

if (FirstPeriod == 1)
    [y, Status] = ApplyFirst(Func, N, A, B, x, LogFile);
else
    [y, Status] = ApplyNext(Func, N, A, B, x, LastInSignal, LastOutSignal, LogFile);
end;

% Write the input and output signal into the text files:
h_in   = fopen(LastInSignal,  'wt');         % Open the input file for overwriting.
h_out  = fopen(LastOutSignal, 'wt');         % Open the output file for overwriting.
SzIn =  fprintf(h_in,  '%-16.12g\n', x);     % Write the new input signal to the file.
SzOut = fprintf(h_out,  '%-16.12g\n', y);    % Write the new output signal to the file.
SavedRes = fclose('all');
