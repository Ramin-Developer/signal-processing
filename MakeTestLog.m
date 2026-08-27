function MakeTestLog(TestLog, Message)
% This is a help function for testing perposes under development.
% If "TestLog" file does not exist it generates the file and then
% writes the current date time as well as the string "Message".

h_test = fopen(TestLog, 'wt');
fprintf(h_test, '%s \t\t %s', datestr(now), Message);
fclose(h_test);