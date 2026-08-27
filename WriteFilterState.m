function WriteFilterState(inputPath, outputPath, inputSignal, outputSignal)
% Persist the signal history required to filter the next period.

inputHandle = fopen(inputPath, 'wt');
outputHandle = fopen(outputPath, 'wt');
if inputHandle == -1 || outputHandle == -1
	if inputHandle ~= -1
		fclose(inputHandle);
	end;
	if outputHandle ~= -1
		fclose(outputHandle);
	end;
	error('SignalProcessing:StateFileOpenFailed', ...
		'Unable to open the persisted filter state files for writing.');
end;
fprintf(inputHandle, '%-16.12g\n', inputSignal);
fprintf(outputHandle, '%-16.12g\n', outputSignal);
fclose(inputHandle);
fclose(outputHandle);