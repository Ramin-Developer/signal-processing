function [x, y, Status] = Calc_Output(t, FirstPeriod)
% **********************************************************************
% Main program to filter input data by applying the method of Bilinear *
% transformation. Status variable may have the following values:       *
% 0 for OK, 1 for warning and 2 for Alarm.                             *
% **********************************************************************

% Initialize the constants and variables of the problem:
persistent filterState;
[InputFile, LastInSignal, LastOutSignal, LogFile, N_max, f_n, Alpha] = Initialize;

% Make the input file:
[Func, Type, f_lim, A_lim, x] = MakeTestFile(t);

% Deduce design parameters for the digital filter:
[N, w_c, Eps] = DesignParam(Func, Type, f_lim, A_lim, N_max, Alpha, LogFile);

% Calculate stable low-order sections instead of one high-order polynomial:
sections = CalculateFilterSections(Func, Type, N, Alpha, w_c, Eps);
if FirstPeriod == 1
    filterState = struct();
elseif isempty(filterState)
    error('SignalProcessing:MissingFilterSectionState', ...
        'FirstPeriod must be 1 before continuing a cascaded filter session.');
end;

% Calculate the cascaded filter output and preserve legacy artifacts:
[y, Status, filterState] = ApplyFilterSections(Func, sections, x, filterState, FirstPeriod);
WriteFilterState(LastInSignal, LastOutSignal, x, y);
WriteFilterStatus(LogFile, Status);
