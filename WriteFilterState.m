function WriteFilterState(inputPath, outputPath, inputSignal, outputSignal)
% Persist the signal history required to filter the next period.

inputHandle = fopen(inputPath, 'wt');
outputHandle = fopen(outputPath, 'wt');
fprintf(inputHandle, '%-16.12g\n', inputSignal);
fprintf(outputHandle, '%-16.12g\n', outputSignal);
fclose(inputHandle);
fclose(outputHandle);