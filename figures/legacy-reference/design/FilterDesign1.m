% *****************************************************************
% Main program to design a normalized digital filter by applying  *
% The Bi-linear Transformation Method. Function of the filter may *
% be low-pass, high-pass, band-pass or band-stop, while type of   *
% the filter is either Butterworth or Chebyshev-1.                *
% *****************************************************************

% Read and check the input parameters:
[Func, Type, Max_int, f_lim, A_lim] = FileInput;

% Deduce design parameters for the digital filter.
[N_max, N, Len_f, f_n, alpha, w_c, Eps] = ...
         DesignParam(Func, Type, f_lim, A_lim);

% Caculate decimal filter coefficients by Direct or Exact Method:
Coeff_Dir = Coefficients(Func, Type, N_max, N, alpha, w_c, Eps);

% Convert the coefficients to integers:
[Coeff_Back, Scale] = ConvertToInt(Coeff_Dir, N, Max_int);

% Write both coefficient types and the Scale into text files:
SavedCoeff = WriteCoeff2File(Coeff_Dir, Coeff_Back, Scale);

% Amplitude of the Direct Method:
[Mag_Dir, Phase] = FreqRes(N, f_n, Coeff_Dir);

% Check if the design specifications are satisfied:
Amp_lim = -20*log10( abs( FreqEval(N, f_lim, Coeff_Dir) ) )

% Calculate the amplitude by using the integer coefficients:
if Scale > 0
    Mag_Back = Backward(N, Len_f, Coeff_Back, Scale);
end;

% Compare the results of the two methods:
if Scale > 0
    [Deviation] = Compare(f_n, Mag_Dir, Mag_Back)
else
    Display(f_n, Mag_Dir);
end;