function [inputState, outputState] = ReadFilterState(inputPath, outputPath)
% Read the signal history required to continue filtering a later period.

inputHandle = fopen(inputPath, 'rt');
outputHandle = fopen(outputPath, 'rt');
[inputState, ~] = fscanf(inputHandle, '%g', inf);
[outputState, ~] = fscanf(outputHandle, '%g', inf);
fclose(inputHandle);
fclose(outputHandle);