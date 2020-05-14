%% Batching routine
% 
message1 = questdlg('Batch a selection of runs or a single run?', ...
    'Image processing', ...
    'Batch','Single','Cancel');
switch message1
    case 'Batch'
        disp('Batching selected.')
        batching = true;
    case 'Single'
        disp('Single run selected.')
        batching = false;
end

if isempty(message1)
   return 
end

if batching
    name = readcell('records.xlsx','sheet','records');
    data = xlsread('records.xlsx','records');
    
    prompt = {'Range of runs:','Specific runs:'};
    dlgtitle = 'Input';
    dims = [1 35];
    definput = {'',''};
    answer = inputdlg(prompt,dlgtitle,dims,definput);
    
    range_runs = split(answer{1},'-');
    range_runs = [str2double(range_runs{1}):str2double(range_runs{2})];
    
    specific_runs = str2double(split(answer{2},','));
   
    if ~isnan(range_runs) 
        runs = range_runs;
    elseif ~isnan(specific_runs)
        runs = specific_runs;
    else
        runs = union(range_runs,specific_runs);
    end
    %% 
    
    for k=1:length(runs)
        name = readcell('records.xlsx','sheet','records');
        data = xlsread('records.xlsx','records');
    
        expname = name(runs(k)+1,1);
        numexp  = name{runs(k)+1,2};
        
        if data(runs(k),16) == 1
            continue
        end
        
        batch   = strcat('batch',num2str(3),'\');
        disp(['Processing experiment: ' expname ', run: ' num2str(numexp),...
                ' from batch: 3'])
        run dataRoutine
        if isempty(automate_message)
           break
        end
        run backgroundRoutine
        run foregroundRoutine
        run processingRoutine
    end   
        
end