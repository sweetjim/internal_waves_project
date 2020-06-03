function [ncpath,wspath,info] = getRunInfo(i,experiment_path,selected_runs)
    % Loading in the relevant .nc files
    filepath = strcat(cd,'\batch3\',experiment_path{i},'\run',...
        num2str(selected_runs(i)),'\');
    
    ncfile = strcat('run',num2str(selected_runs(i)),'tracked.nc');
    workspacefile = strcat('run',num2str(selected_runs(i)),'_workspace.mat');
    
    ncpath = strcat(filepath,ncfile);
    wspath = strcat(filepath,workspacefile);
    
    % Reading the anomaly variable over one tidal period
    % Get infomation about 'anom'
    info = ncinfo(ncpath,'anom');
end