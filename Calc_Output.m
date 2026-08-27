function [x, y, Status] = Calc_Output(t, FirstPeriod)
% **********************************************************************
% Main program to filter input data by applying the method of Bilinear *
% transformation. Status variable may have the following values:       *
% 0 for OK, 1 for warning and 2 for Alarm.                             *
% **********************************************************************

% Initialize the constants and variables of the problem:
[InputFile, LastInSignal, LastOutSignal, LogFile, N_max, f_n, Alpha] = Initialize;

% Make the input file:
[Func, Type, f_lim, A_lim, x] = MakeTestFile(t);

% Deduce design parameters for the digital filter:
[N, w_c, Eps] = DesignParam(Func, Type, f_lim, A_lim, N_max, Alpha, LogFile);

% Decimal filter coefficients by the Direct or Exact Method:
Coeff = CalculateCoeff(Func, Type, N_max, N, Alpha, w_c, Eps);

% Calculate filter output by iterating the difference Eq.:
[y, Status] = ApplyFilter(Func, N, Coeff, x, LastInSignal, LastOutSignal, ...
              LogFile, FirstPeriod);
