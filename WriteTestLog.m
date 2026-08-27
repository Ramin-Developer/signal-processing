function WriteTestLog(TestLog, Message)
% This functions write the value of a text string "Message" to the textfile
% specified by TestLog. File will be opened (or created the first time) and
% messages appended to the end of the file.

h_test = fopen(TestLog, 'wt');
fprintf(h_test, datestr(now), '\t');
fprintf(h_test, Message);
fclose('all');