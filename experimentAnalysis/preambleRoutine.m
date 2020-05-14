%% Preamble routine

name = readcell('records.xlsx','sheet','records');
data = xlsread('records.xlsx','records');

temporal_prompt = questdlg('What would you like to process?', ...
    'Experiment analysis', ...
    'Short-term transits','Long-term transits','Cancel');

switch temporal_prompt
    case 'Short-term transits'
        disp('Short-term transits selected.')
        temporal_transits = false;
    case 'Long-term transits'
        disp('Long-term transits selected.')
        temporal_transits = true;
end

prompt = {'Range of runs:','Specific runs:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'',''};
runs_prompt = inputdlg(prompt,dlgtitle,dims,definput);

if isempty(runs_prompt)
    disp('Stopping script')
    return
end

if ~isnan(find(runs_prompt{1},1))
    range_runs = split(runs_prompt{1},'-');
    range_runs = [str2double(range_runs{1}):str2double(range_runs{2})];
    runs = range_runs;
elseif ~isnan(find(runs_prompt{2},1))
    specific_runs = str2double(split(runs_prompt{2},','));
    runs = specific_runs;
end

if ~isempty(runs_prompt{1})&&~isempty(runs_prompt{2})
    runs = union(range_runs,specific_runs);
end

if temporal_transits
    if ~isempty(runs_prompt{1})
        % Find the 1's
        selected_runs = find(data(runs,16),length(runs));
    else
        selected_runs = runs;
    end
else
    if ~isempty(runs_prompt{1})
        % Find the 0's
        selected_runs = find(~data(runs,16),length(runs))+runs(1)-1;
    else
        selected_runs = runs;
        if data(runs,16)==1
            disp('You have selected a long-term transit run.')
            return
        end
    end
end

experiment_path = {(name{selected_runs+1,1})};

% Define saving path
savingpath = strcat(cd,'experimentAnalysis\timeAverages\');
