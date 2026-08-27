function [Func, Type, Max_int, f_lim, A_lim] = FileInput
% Load the file "inputParam.txt" and check if the input data are correct:
% 1) Func, function of the filter:
%       0 for Low-Pass, 1 for High-Pass,
%       2 for band-pass, 3 for band-stop.
% 2) Type, type of the filter:
%       0 for Butterworth, 1 for Chebyshev.
% 3) Frequency limits 2, or 4 parameters:
%   0 < f_lim(1) < f_lim(2) < 0.5,                       Func = 0, 1
%   0 < f_lim(1) < f_lim(2) < f_lim(3) < f_lim(4) < 0.5, Func = 2, 3.
% 4) dB amplitudes at the points specified by f_lim, 2 or 4 parameters:
%   0 < A_lim(1) <= Lim_Ap < Lim_As <= A_lim(2),         Func = 0, 2 
%   0 < A_lim(4) <= Lim_Ap < Lim_As <= A_lim(3),         Func = 2
%   0 < A_lim(2) <= Lim_Ap < Lim_As <= A_lim(1),         Func = 1, 3
%   0 < A_lim(3) <= Lim_Ap < Lim_As <= A_lim(4),         Func = 3.
% 5) RegLen, number of bits in a register,  8, 16, 32, 64 or 128
% 6) RegNo, number of registers in a word, 1, 2, 4 or 8.
% Furthermore it returns the maximum representable integer.

Lim_Ap = 1;
Lim_As = 7;
Max_Word = 128*2 - 1;

h = fopen('InputParam.txt', 'rt');
Func = fgetl( h );
status = fclose( h );
if ( Func ~= '0' & Func ~= '1' & Func ~= '2' & Func ~= '3' )
    error('Func must be 0, 1, 2 or 3!');
end;

h = fopen('InputParam.txt', 'rt');
if ( Func == '0' | Func == '1' )
    [Inp, Count] = fscanf(h, '%g', [8, 1]);
elseif Func == '2' | Func == '3'
    [Inp, Count] = fscanf(h, '%g', [12, 1]);
end;
status = fclose( h );

Func = Inp( 1 );
Type  = Inp( 2 );
if Type ~= 0 & Type ~= 1
    error('Type must be 0 or 1!');
end;

if Func == 0 | Func == 1
    f_lim = [Inp( 3 ) Inp( 4 )];
    A_lim = [Inp( 5 ) Inp( 6 )];
    RegLen = Inp( 7 );
    RegNo  = Inp( 8 );
elseif Func == 2 | Func == 3
    f_lim = [Inp( 3 ) Inp( 4 ) Inp( 5 ) Inp( 6 )];
    A_lim = [Inp( 7 ) Inp( 8 ) Inp( 9 ) Inp( 10 )];
    RegLen = Inp( 11 );
    RegNo  = Inp( 12 );
end;

% Check if the input data are in the range:
Len_Freq = length( f_lim );
Len_Amp  = length( A_lim );

if (Func == 0 | Func == 1 ) & (Len_Freq ~= 2 | Len_Amp ~= 2 )
    error('Length of critical frequencies and amplitudes must be 2.');
end;
if (Func == 2 | Func == 3 ) & (Len_Freq ~= 4 | Len_Amp ~= 4 )
    error('Length of critical frequencies and amplitudes must be 4.');
end;

% Check if f_lim values are in the range:
for k = 1:1:Len_Freq
    if 0 >= f_lim( k ) | f_lim( k ) >= 0.5
        error('Allowed Limiting frequency range: 0 < f_lim(i) < 0.5!');
    end;
end;
for k = 1:1:Len_Freq-1
    for m = k+1:1:Len_Freq
        if f_lim( k ) >= f_lim( m )
            error('Limiting frequencies must be ordered ascendingly!');
        end;
    end;
end;

% Check if attenuations are positive: 
for k = 1:1:Len_Amp-1
    if 0 >= A_lim( k )
        error('Limiting dB-amplitudes must be positive numbers!');
    end;
end;

% Check if A_lim values are in the range for Func == 0:
if (Func == 0 & A_lim(1) > Lim_Ap )
    error('Allowed range of pass-band attenuation: 0 < A_lim(1) <= 1!');
end;
if ( Func == 0 & A_lim(2) < Lim_As )
    error('Allowed range of stop-band attenuation: 7 <= A_lim(2)!');
end;

% Check if A_lim values are in the range for Func == 1:
if ( Func == 1 & A_lim(2) > Lim_Ap )
    error('Allowed range of pass-band attenuation: 0 < A_lim(2) <= 1!');
end;
if ( Func == 1 & A_lim(1) < Lim_As )
    error('Allowed range of stop-band attenuation: 7 <= A_lim(2)!');
end;

% Check if A_lim are in the range for Func == 2:
if ( Func == 2 & ( A_lim(2) > Lim_Ap | A_lim(3) > Lim_Ap ) )
    error('Allowed pass-band attenuation: 0 < A_lim(i), for i = 2, 3!');
end;
if ( Func == 2 & ( A_lim(1) < Lim_As | A_lim(4) < Lim_As ) )
    error('Allowed stop-band attenuation: 7 <= A_lim(i), for i = 1, 4!');
end;

% Check if A_lim are in the range for Func == 3:
if ( Func == 3 & ( A_lim(1) > Lim_Ap | A_lim(4) > Lim_Ap ) )
    error('Allowed pass-band attenuation: 0 < A_lim(i), for i = 1, 4!');
end;
if (Func == 3 & (A_lim(2) < Lim_As | A_lim(3) < Lim_As) )
    error('Allowed stop-band attenuation: 7 <= A_lim(i), for i = 2, 3!');
end;

% Check if RegLen and RegNo are in the range:
if RegLen~=8 & RegLen~=16 & RegLen~=32 & RegLen~=64 & RegLen~=128
    error('RegLen must be 8, 16 or 32, 64 or 128!');
end;
if RegNo ~= 1 & RegNo ~= 2 & RegNo ~= 4 & RegNo ~= 8 & RegLen ~= 16
    error('RegNo must be 1, 2, 8 or 16!');
end;

% Calculate and return Max_int
Pot = RegLen * RegNo - 1;
if Pot > Max_Word
    Pot = Max_Word;
end;
Max_int = 2^Pot - 1;
