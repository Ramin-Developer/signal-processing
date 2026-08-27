
clear;
clf;
NoOfSets = 6;
Len = 1000;
Ts = 1/Len;
T = zeros(Len, NoOfSets);
X = zeros(Len, NoOfSets);
Y = zeros(Len, NoOfSets);
for Count = 1:1:NoOfSets
    if (Count == 1)
        FirstSet = 1;
    else
        FirstSet = 0;
    end;
    Time(:, Count) = [(Count - 1):Ts:Count - Ts]';
    [X(:, Count), Y(:, Count), Status] = Calc_Output(Time(:, Count), FirstSet);
end;

% Present the results:
plot(Time(:, 1), X(:, 1), 'g', Time(:, 1), Y(:, 1), 'r');
hold;
grid;
legend('Input Signal', 'Output Signal');
xlabel('Time axis \it{sec}');
title('Plot of the input and output signals');
for Count = 2:NoOfSets
    plot(Time(:, Count), X(:, Count), 'g', Time(:, Count), Y(:, Count), 'r');
end;