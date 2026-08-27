function [N_max, N, Len_f, f_n, alpha, w_c, Eps] = ...
         DesignParam(Func, Type, f_lim, A_lim)
% Given the filter function, type, limiting frequencies and attenuations
% in "Func", "Type", "f_lim" and "A_lim", respectively, obtain the
% filter order and cut-off frequency for a Butterworth and the filter
% order, cut-off frequency and Epsilon for a Chebyshev-1 filter.
% The filter order satisfies 2 <= N <= N_max, "alpha" is the constant
% in the Bilinear Transformation and "Len_f" is the length of the
% digital frequency vector.

N_max = 20;

% Construct a frequency vector of length Len_f from Start to End:
Len_f = 2001;
Start = 0;
End = 0.5;
delta = (End - Start) / (Len_f - 1);
f_n = [Start:delta:End]';
w_lim = 2*pi*f_lim;

% With this choice of alpha, the Bilinear Transformation maps
% Omega = 1 to w = 1:
alpha = 1 / tan(0.5);

% Transform limiting frequencies and db_amplitudes to a LP filter:
if Func == 1
    w_lim = pi - [w_lim(2)      w_lim(1)];
    A_lim = [A_lim(2)           A_lim(1)];
elseif Func == 2
    w_lim = [pi - w_lim(2)     pi - w_lim(1)
             w_lim( 3 )        w_lim( 4 )];
    A_lim = [A_lim(2)          A_lim(1)
             A_lim(3)          A_lim(4)]; 
elseif Func == 3
    w_lim = [w_lim(1)          w_lim(2)
             pi - w_lim(4)     pi - w_lim(3)];
    A_lim = [A_lim(1)          A_lim(2)
             A_lim(4)          A_lim(3)];
end;

% Calculate the filter parameters: 
[N, w_c, Eps] = DecideParam(Func, Type, N_max, alpha, w_lim, A_lim);

% Write the filter order into the text file 'Output.log'.
% If N > N_max set both the Scale and Status variables also equal to 0
% and exit the program with an error message.
h_Output  = fopen('Output.log', 'wt');
Sz_Output = fprintf(h_Output,  '%-16.12g\n', N);
if N > N_max
    Sz_Output = fprintf(h_Output,  '%-16.12g\n', 0);
    Sz_Output = fprintf(h_Output,  '%-16.12g\n', 0);
end;
Closed  = fclose(h_Output);

if N > N_max
    error(' Sorry, order of the filter is larger than N_max! ');
end;
