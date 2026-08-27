function [x, y, Status, state] = Calc_OutputWithState(t, state, FirstPeriod)
% Run the cascaded filter pipeline with caller-owned section state.

[InputFile, LastInSignal, LastOutSignal, LogFile, N_max, f_n, Alpha] = Initialize;
[Func, Type, f_lim, A_lim, x] = MakeTestFile(t);
[N, w_c, Eps] = DesignParam(Func, Type, f_lim, A_lim, N_max, Alpha, LogFile);
sections = CalculateFilterSections(Func, Type, N, Alpha, w_c, Eps);

if FirstPeriod == 1
    state = struct();
elseif isempty(state)
    error('SignalProcessing:MissingFilterSectionState', ...
        'FirstPeriod must be 1 before continuing a cascaded filter session.');
end;

try
    [y, Status, state] = ApplyFilterSections(Func, sections, x, state, FirstPeriod);
catch exception
    WriteFilterStatus(LogFile, 2);
    rethrow(exception);
end;
WriteFilterState(LastInSignal, LastOutSignal, x, y);
WriteFilterStatus(LogFile, Status);
end