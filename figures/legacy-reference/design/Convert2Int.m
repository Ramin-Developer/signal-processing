function [Coeff_Back, Scale] = Convert2Int(Coeff_Dir, N, Max_int)
% Convert all coefficients to integers, round and return them as
% "Coeff_Back" with the highest precision available.
% "Scale" is the factor that the coefficients are multiplied by.

Coeff_Back = zeros( size(Coeff_Dir) );
Min_Prec = 6;
Max_Prec = 12;
Pot = -Max_Prec:1:-Min_Prec;
Delta = 10.^Pot;
Len = length( Delta );
Abs_A = abs( Coeff_Dir( 1, 1:1:N+1 ) );
Abs_B = abs( Coeff_Dir( 2, 2:1:N+1 ) );
ind = 1;
Scale = 0;

for k = 1:1:Len
    % Find Min_Coeff, maximum of the smallest coeeficient and Delta.
    Min_A = max( min( Abs_A ), Delta( k ) );
    Min_B = max( min( Abs_B ), Delta( k ) );
    Min_Coeff = min( Min_A, Min_B );

    % Find the largest coefficient obtained by dividing all decimal
    % coefficients by Min_Coeff:
    Max_Ar = max( Abs_A / Min_Coeff );
    Max_Br = max( Abs_B / Min_Coeff );
    Max_Coeff = max( Max_Ar, Max_Br );

    % Check if Max_Coeff is inside the integer range:
    Scale = floor( Max_int / (Max_Coeff * Min_Coeff ) );
    if Scale >= 1000
        ind = k;
        break;
    else
        ind = ind + 1;
    end;
end;

% Construct the new coefficients:
if Scale > 0
    Coeff_Back = floor( Coeff_Dir * Scale );
end;
