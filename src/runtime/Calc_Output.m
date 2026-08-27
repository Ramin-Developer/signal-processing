function [x, y, Status] = Calc_Output(t, FirstPeriod)
% **********************************************************************
% Main program to filter input data by applying the method of Bilinear *
% transformation. Status variable may have the following values:       *
% 0 for OK, 1 for warning and 2 for Alarm.                             *
% **********************************************************************

persistent filterState;
[x, y, Status, filterState] = Calc_OutputWithState(t, filterState, FirstPeriod);
