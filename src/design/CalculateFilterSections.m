function sections = CalculateFilterSections(Func, Type, N, Alpha, w_c, Eps)
% Calculate normalized low-order sections for numerically stable cascading.

if Func == 0 || Func == 1
    lowPassOrder = N;
    sectionOrder = 2;
else
    lowPassOrder = N / 2;
    sectionOrder = 4;
end;

sectionCount = lowPassOrder / 2;
sections = cell(sectionCount, 1);
knownFrequency = w_c(1) / (2 * pi);
knownResponse = 1;
for sectionIndex = 1:sectionCount
    [numerator, feedback] = Calc2DCoeff(Func, Type, sectionIndex - 1, ...
        lowPassOrder, Alpha, w_c, Eps);
    feedback(1) = 0;
    sections{sectionIndex} = [numerator(1:sectionOrder + 1); ...
        feedback(1:sectionOrder + 1)];
    knownResponse = knownResponse * FreqEval(sectionOrder, knownFrequency, ...
        sections{sectionIndex});
end;

if Type == 0
    desiredMagnitude = 2^(-0.5);
else
    desiredMagnitude = (1 + Eps^2)^(-0.5);
end;
sections{1}(1, :) = sections{1}(1, :) * (desiredMagnitude / abs(knownResponse));
end