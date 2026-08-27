function Min = MinGT0( Mat )

Min = 1e307;
Rows = size(Mat, 1);
Cols = size(Mat, 2);

for i = 1:1:Rows
    for j = 1:1:Cols
        if 0 < Mat(i, j) & Mat(i, j) < Min
            Min = Mat(i, j);
        end;
    end;
end;