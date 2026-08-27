function [N, Coeff_Dir, Coeff_Back, Scale] = FilterDesign0
% *****************************************************************
% Main program to design a normalized digital filter by applying  *
% Bilinear transformation method. Function of the filter may be   *
% low-pass, high-pass, band-pass or band-stop, while type of the  *
% filter is either Butterworth or Chebyshev-1.                    *                                           *
% *****************************************************************

% Read and initialize the input parameters:
[Func, Type, Max_int, f_lim, A_lim] = ReadInput;

% Deduce design parameters for the digital filter:
[N_max, N, Len_f, f_n, alpha, w_c, Eps] = ...
         DesignParam(Func, Type, f_lim, A_lim);

% Decimal filter coefficients by the Direct or Exact Method:
Coeff_Dir = Coefficients(Func, Type, N_max, N, alpha, w_c, Eps);

% Convert the coefficients to integers:
[Coeff_Back, Scale] = ConvertToInt(Coeff_Dir, N, Max_int);

% Save both coefficient types and the Scale:
SavedCoeff = WriteCoeff2File(Coeff_Dir, Coeff_Back, Scale);

% Write results of both methods to text files:
SavedRes = WriteRes2File(N, f_n, Coeff_Dir, Coeff_Back, Scale);
