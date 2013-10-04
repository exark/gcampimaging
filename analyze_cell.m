function analyze_cell

[f, p] = uigetfile('.txt', 'Select the file describing the runs you want to analyze')

fid = fopen([p f]);
header = textscan(fid, '%s', 1);
columns = textscan(fid, '%[0123456789]: %s %s %s %s');
fclose(fid);

title=header{1}{1}
data = cell(5,1);
for i=1:length(columns)
    for j=1:length(columns)
        data{i}{j} = columns{j}{i};
    end
end

for i=1:length(data)
    for j=1:length(data)
        if j==1
            disp(data{i}{j})
        else
            disp([title data{i}{j}])
        end
    end
end
    