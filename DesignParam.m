function [N, w_c, Eps] = DesignParam(Func, Type, f_lim, A_lim, ...
                         N_max, Alpha, LogFile)
% Given the filter function, type, limiting frequencies and attenuations
% in "Func", "Type", "f_lim" and "A_lim", respectively, obtain the
% filter order and cut-off frequency for a Butterworth and the filter
% order, cut-off frequency and Epsilon for a Chebyshev-1 filter.
% The filter order satisfies 2 <= N <= N_max, "Alpha" is the constant
% in the Bilinear Transformation and "Len_f" is the length of the
% digital frequency vector. If N >= N_max, an error status of value 2 is
% written to the LogFile and the program terminates with an error message. 

try
    ValidateFilterSpecification(Func, Type, f_lim, A_lim);
catch exception
    WriteFilterStatus(LogFile, 2);
    rethrow(exception);
end;

w_lim = 2*pi*f_lim;

% Transform limiting frequencies and db_amplitudes to a LP filter:
if (Func == 1)
    w_lim = pi - [w_lim(2)      w_lim(1)];
    A_lim = [A_lim(2)           A_lim(1)];
elseif (Func == 2)
    w_lim = [pi - w_lim(2)     pi - w_lim(1); w_lim( 3 )        w_lim( 4 )];
    A_lim = [A_lim(2)          A_lim(1);      A_lim(3)          A_lim(4)]; 
elseif (Func == 3)
    w_lim = [w_lim(1)          w_lim(2);      pi - w_lim(4)     pi - w_lim(3)];
    A_lim = [A_lim(1)          A_lim(2);      A_lim(4)          A_lim(3)];
end;

% Calculate the filter parameters: 
[N, w_c, Eps] = DecideParam(Func, Type, N_max, Alpha, w_lim, A_lim);

if N > N_max
    WriteFilterStatus(LogFile, 2);
    error('SignalProcessing:FilterOrderExceeded', ...
        'The required filter order is larger than N_max.');
end;
