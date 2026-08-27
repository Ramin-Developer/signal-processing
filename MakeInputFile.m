function Made = MakeInputFile(InputFile)

Len = 1000;
Ts = 1/Len;
t = 0:Ts:1 - Ts;
x = zeros(1, Len);
% t = 1:Ts:2 - Ts;
% t = 2:Ts:3 - Ts;
mid = fix(Len/2);
Func = 3;
Type = 1;
FirstPeriod = 0;

h_input = fopen(InputFile, 'wt');
Count =  fprintf(h_input,  '%-16.12g\n', Func);
Count =  fprintf(h_input,  '%-16.12g\n', Type);

% Write critical frequencies and attenuations to the file:
if (Func == 0)
    f_lim = [0.01   0.02];
    A_lim = [0.1       20];
    Count =  fprintf(h_input, '%-16.12g\t %-16.12g\n', f_lim);
    Count =  fprintf(h_input, '%-16.12g\t %-16.12g\n', A_lim);
elseif (Func == 1)
    f_lim = [0.01   0.024];
    A_lim = [20     0.1];
    Count =  fprintf(h_input, '%-16.12g\t %-16.12g\n', f_lim);
    Count =  fprintf(h_input, '%-16.12g\t %-16.12g\n', A_lim);
elseif (Func == 2)
    f_lim = [0.01   0.02   0.03   0.049];
    A_lim = [20     0.5    0.5      20];
    Count =  fprintf(h_input, '%-16.12g\t %-16.12g\t %-16.12g\t %-16.12g\n', f_lim);
    Count =  fprintf(h_input, '%-16.12g\t %-16.12g\t %-16.12g\t %-16.12g\n', A_lim);
elseif (Func == 3)
    f_lim = [0.01   0.02   0.03   0.049];
    A_lim = [0.01     20      20     0.01];
    Count =  fprintf(h_input, '%-16.12g\t %-16.12g\t %-16.12g\t %-16.12g\n', f_lim);
    Count =  fprintf(h_input, '%-16.12g\t %-16.12g\t %-16.12g\t %-16.12g\n', A_lim);    
end;

% Write the value of FirstPeriod:
Count =  fprintf(h_input, '%-16.12g\n', FirstPeriod);

% Generate the input signal based on the value of Choice:
Choice = 1000;
while (Choice ~= 0) && (Choice ~= 1) && (Choice ~= 2) && (Choice ~= 3)
    Choice = input('Choice : ');
    if (Choice == 0)
        % A Delta Dirac function:
        x(mid) = 1;
    elseif (Choice == 1)
    % A Step function:
    x(mid:end) = ones(Lx - mid + 1, 1);
    elseif (Choice == 2)
        % A sum of Sine functions:
        Omega = [1    50      100]*pi;
        Amp   = [1    0.05    0.05];
        for k = 1:1:length(Omega)
            x = x + Amp(k) * sin( Omega(k)*t );
        end;
    elseif (Choice == 3)
        % A white noise;
        x = rand(1, Len);
    else
        disp('Choice must be 0, 1, 2 or 3.');
    end;
end;

% Write t and x into the file:
Count =  fprintf(h_input,  '%-16.12g\n', x);
Made = fclose(h_input);
