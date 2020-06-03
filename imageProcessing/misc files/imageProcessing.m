    %%  Image Processing for visualizing dynamics of internal tides
    %   Modified version of Yvan Dossman's and Callum Shaw's scripts.
    %   The Australian National University, Research School of Earth Sciences
    %   Climate and Fluid Physics Group
    %   James Sweetman, February, 2020  
    
    clearvars
    %% Preamble paths
    
    addpath(genpath(cd))
                
    %% Batch processesing
    
    run batchRoutine
    
    %%  Loading experimental data
    % Prompts deciding whether the immediate last run is to be selected and
    % if the user would like to automate the cropping and file selection
    % procedure is asked. Variables stored within the excel file
    % 'records.xlsx' will be read-in.
    if ~batching
    run dataRoutine
    
    %% Background image (Ixo) 
    % The initial state background image will be loaded in and, using the 
    % Beer-Lambert law; relating tracer concentration to light
    % absorption (Dossmann et al. 2016), the density profile may be
    % extracted.
    
    run backgroundRoutine
 
    %% Foreground images (Ix)
    % Load in the transit images
    
    run foregroundRoutine
%     clear imageframes
    
    %% Perform the image processessing
    % Subtraction of the transiting images intensity profile from the
    % initial image is used to form a density anomaly profile. This is
    % iterated for all selected transit images and saved as a movie frame
    % with figure details added
    
%     run processingRoutine
    run developRoutine
    
    end
    %% Further processing
    
    
%     run extraRoutine
    
    %% Video processing
    % Each saved movie frame is passed through MATLAB's video writer.
    
%     run outputRoutine
    
    %% Save workspace
    
%     clear imageframes
    savingpath = char(strcat(exppath,'\run',num2str(numexp),'_workspace.mat'));
 