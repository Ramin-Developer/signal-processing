function SavedCoeff = WriteCoeff2File(Coeff_Dir, Coeff_Back, Scale);
% Write the results of both methods into text files
% 'Coefficient_Direct.txt' and 'Coefficient_Backward.txt'.

% Write the decimal coefficients into the text file: 
h_C  = fopen('Coefficient_Direct.txt', 'wt');
Sz_C = fprintf(h_C,  '%-16.12g\t %-16.12g\n', Coeff_Dir);

% Write the Scale and Staus into the text file:
h_Output  = fopen('Output.log', 'at');
Sz_Output = fprintf(h_Output,  '%-16.12g\n', Scale);

% If the conversion of decimal coefficients to integers are performed 
% successfully, write also the integer coefficients into the file:
if (Scale == 0)
    Sz_Output = fprintf(h_Output,  '%-16.12g\n', 1);
    disp('Just the decimal coefficients are saved!');
else
    Sz_Output = fprintf(h_Output,  '%-16.12g\n', 2);
    h_Cr = fopen('Coefficient_Backward.txt', 'wt');
    Sz_Cr = fprintf(h_Cr, '%-16.12g\t %-16.12g\n', Coeff_Back);
    disp('Both types of coefficients are saved!');
end;

SavedCoeff = fclose('all');
