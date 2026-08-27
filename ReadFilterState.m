function [inputState, outputState] = ReadFilterState(inputPath, outputPath)
% Read the signal history required to continue filtering a later period.

inputHandle = fopen(inputPath, 'rt');
outputHandle = fopen(outputPath, 'rt');
if inputHandle == -1 || outputHandle == -1
	if inputHandle ~= -1
		fclose(inputHandle);
	end;
	if outputHandle ~= -1
		fclose(outputHandle);
	end;
	error('SignalProcessing:StateFileOpenFailed', ...
		'Unable to open the persisted filter state files.');
end;
[inputState, ~] = fscanf(inputHandle, '%g', inf);
[outputState, ~] = fscanf(outputHandle, '%g', inf);
fclose(inputHandle);
fclose(outputHandle);