function y = ApplyDifferenceEquation(A, B, x, y, N)
% Apply the Nth-order filter recurrence to the supplied signal segment.

for n = N + 1:length(x)
    for k = 0:N
        y(n) = y(n) + A(k + 1) * x(n - k) + B(k + 1) * y(n - k);
    end;
end;