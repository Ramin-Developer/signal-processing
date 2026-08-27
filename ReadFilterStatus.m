function status = ReadFilterStatus(logPath)
% Read the status saved by the previous filter period.

logHandle = fopen(logPath, 'rt');
if logHandle == -1
    error('SignalProcessing:StatusFileOpenFailed', ...
        'Unable to open the filter status file.');
end;
status = fscanf(logHandle, '%g', 1);
fclose(logHandle);