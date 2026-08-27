function WriteFilterStatus(logPath, status)
% Persist the status for the next filter period.

logHandle = fopen(logPath, 'wt');
if logHandle == -1
    error('SignalProcessing:StatusFileOpenFailed', ...
        'Unable to open the filter status file.');
end;
fprintf(logHandle, '%-16.12g\n', status);
fclose(logHandle);