function [analysis_stack] = analyze_cell(contrast_level)

[f, p] = uigetfile('.txt', 'Select the file describing the runs you want to analyze');

fid = fopen([p f]);
header = textscan(fid, '%s', 1);
columns = textscan(fid, '%[0123456789]: %s %s %s %s');
fclose(fid);

title = header{1}{1};
data = cell(5,1);
for i=1:length(columns)
    for j=1:length(columns)
        data{i}{j} = columns{j}{i};
    end
end

file_path=cell(1,8);
file_path{2} = p;
file_path{4} = p;
file_path{6} = p;
file_path{8} = p;

for i=1:length(data)
    if strcmp(data{i}{1},contrast_level)
        file_path{1} = [title data{i}{2} '.tif'];
        file_path{3} = [title data{i}{3} '.tif'];
        file_path{5} = [title data{i}{4} '.tif'];
        file_path{7} = [title data{i}{5} '.tif'];
    end
end

analysis_stack = dlr_analyse_visStim(file_path{1}, ...
                    file_path{2}, ...
                    file_path{3}, ...
                    file_path{4}, ...
                    file_path{5}, ...
                    file_path{6}, ...
                    file_path{7}, ...
                    file_path{8})
    