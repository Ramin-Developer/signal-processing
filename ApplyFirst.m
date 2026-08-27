function [y, Status] = ApplyFirst(Func, N, A, B, x, LogFile)

Lx = length(x);     % Initial length of the input.
Aver_x = mean(x);
LenMin = 1000;

% Generate a periodic input signal as a result of discrete property of frequency domain.
if Lx >= LenMin
    M = 1;                      % Find first No. of periods of the input signal.
    LenExt = Lx + N;
    x_t = [x(end-N+1:end); x];
else
    M = fix( LenMin/Lx ) + 1;   % Find first No. of periods of the input signal.
    if mod(LenMin, Lx) == 0
        M = M - 1;
    end;
    x_t = zeros(M * Lx, 1);     % Construct the periodic vector
    for k = 1:M
        for j = 1:Lx
            x_t( (k - 1) * Lx + j ) = x(j);
        end;
    end;
    x_t = [x_t(end-N+1:end); x_t];
    LenExt = M * Lx + N;
end;

% Insert the initial values into the output signal and calculate the first iteration:
yOld = zeros(LenExt, 1);
if (Func == 0) || (Func == 3)
    yOld(1:N) = Aver_x;
end;
for n = N + 1:1:LenExt
    for k = 0:1:N
        yOld(n) = yOld(n) + A(k + 1) * x_t(n - k) + B(k + 1) * yOld(n - k);
    end;
end;

% Calculate the output values:
Status = 3;
Iter_no = 0;
while (Status ~= 0) && (Status ~= 1)
    Iter_no = Iter_no + 1;
    yNew = zeros(LenExt, 1);
    yNew(1:N) = yOld(LenExt - N + 1:end);
    for n = N + 1:1:LenExt
        for k = 0:1:N
            yNew(n) = yNew(n) + A(k + 1) * x_t(n - k) + B(k + 1) * yNew(n - k);
        end;
    end;
    % Convergence test:
    Max_yNew = max( abs(yNew) );
    Max_yOld = max( abs(yOld) );
    if Max_yNew > 10 * Max_yOld
        Status = 1;     % Status is set to Warning.
    elseif norm(yNew - yOld, 2) <= 0.01 || (Iter_no > 10)
        Status = 0;
    end;
    yOld = yNew;
end;

% Throw away the first part of the output vector an dwrite the results into
% the text file.
if M > 1
    y = yNew( (M - 1)*Lx + N + 1:end );
else
    y = yNew(N + 1:end);
end;

h_log  = fopen(LogFile, 'wt');          % Open the Log file for overwriting.
Count = fprintf(h_log, '%g', Status);
Count = fclose(h_log);
