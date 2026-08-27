function SavedRes = WriteRes2File(N, f_n, Coeff_Dir, Coeff_Back, Scale)

Len_f            = length( f_n );
[Mag_Dir, Phase] = FreqRes(N, f_n, Coeff_Dir);
Resp_Dir         = [f_n; Mag_Dir];

% Write results of both methods into text files:
h_Dir  = fopen('Response_Direct.txt', 'wt');
Sz_Res = fprintf(h_Dir,  '%-16.12g\t %-16.12g\t %-16.12g\n', Resp_Dir);

% If the decimal coefficients are converted to integers successfully
% write also the integer coefficients into the file:
if Scale > 0
    [Mag_Back] = Backward(N, Len_f, Coeff_Back, Scale);
    Resp_Back  = [f_n; Mag_Back];
    Residual   = [f_n; abs( Mag_Dir - Mag_Back ) ];
    h_Back     = fopen('Response_Backward.txt', 'wt');
    Sz_Back    = fprintf(h_Back, '%-16.12g\t %-16.12g\t %-16.12g\n', ...
                         Resp_Back);
    h_Resid    = fopen('Residual.txt', 'wt');
    Sz_Resid   = fprintf(h_Resid, '%-16.12g\t %-16.12g\t %-16.12g\n', ...
                         Residual);
end;

SavedRes = fclose('all');
