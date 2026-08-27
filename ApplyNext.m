function [y, Status] = ApplyNext(Func, N, A, B, x, LastInSignal, LastOutSignal, LogFile)

% Update the first N values of input and output signals from the last calculations:
Lx = length(x);
y = zeros(Lx, 1);
h_in  = fopen(LastInSignal,  'rt');
h_out = fopen(LastOutSignal, 'rt');
[x_last, Count] = fscanf(h_in,  '%g', inf);
[y_last, Count] = fscanf(h_out, '%g', inf);
fclose('all');

x_t = [x_last(end - N + 1:end);   x];
y_t = [y_last(end - N + 1:end);   y];
LenExt = Lx + N;

% Calcualate the new output and throw away the first N values:
for n = N + 1:1:LenExt
    for k = 0:1:N
        y_t(n) = y_t(n) + A(k + 1) * x_t(n - k) + B(k + 1) * y_t(n - k);
    end;
end;
y = y_t(N + 1:end);

h_log  = fopen(LogFile, 'rt');                    % Open the Log file for reading.
LastStatus = fscanf(h_log, '%g');
Count = fclose(h_log);
Status = 0;
if (LastStatus == 1)                              % If LastStatus is equal to warning
    Status = 1;                                   % set Status equal to warning.
end;

h_log  = fopen(LogFile, 'wt');                    % Open the Log file for overwriting.
Count = fprintf(h_log,  '%-16.12g\n', Status);    % Write the new status into the file.
Count = fclose(h_log);
