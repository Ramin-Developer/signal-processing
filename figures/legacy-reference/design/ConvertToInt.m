function [Coeff_Back, Scale] = ConvertToInt(Coeff_Dir, N, Max_int)
% Convert all coefficients to integers, round and return them as
% "Coeff_Back" with the highest precision available.
% "Scale" is the factor that the coefficients are multiplied by.

Coeff_Back = zeros( size(Coeff_Dir) );
Abs_A = abs( Coeff_Dir( 1, 1:1:N+1 ) );
Abs_B = abs( Coeff_Dir( 2, 2:1:N+1 ) );

% Find Min_Coeff, maximum of the smallest coeeficient and Delta.
Min_A = MinGT0( Abs_A );
Min_B = MinGT0( Abs_B );
Min_Coeff = min( Min_A, Min_B );

% Find the largest coefficient obtained by dividing all decimal
% coefficients by Min_Coeff:
Max_Ar = max( Abs_A / Min_Coeff );
Max_Br = max( Abs_B / Min_Coeff );
Max_Coeff = max( Max_Ar, Max_Br );
if Max_Coeff < Max_int
    Scale = round( Max_int / ( Min_Coeff * Max_Coeff ) );
    Coeff_Back = round( Coeff_Dir * Scale );
else
    Scale = 0;
end;
