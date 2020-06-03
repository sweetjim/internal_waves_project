%% Experimental data routine

%% Initial prompts:
% 1: Process last run or select another
% 2: Choose experiment number, run number, batch number
% 3: Automate file handling procedure
    if ~batching
        message1 = questdlg('Process latest run?', ...
            'Image processing', ...
            'Yes','Select new run','Cancel');
        switch message1
            case 'Yes'
                disp('Selecting latest run')
                lastRun = true;
            case 'Select new run'
                disp('Selecting run')
                lastRun = false;
        end

        if isempty(message1)
           return 
        end

        data = xlsread('records.xlsx','records');

        if ~lastRun
            prompt = {'Experiment number/name:','Run number:','Batch number:'};
            dlgtitle = 'Input';
            dims = [1 35];
            definput = {'','',''};
            answer = inputdlg(prompt,dlgtitle,dims,definput);

            expname = strcat('Expt',answer{1});
            numexp  = str2double(answer{2});
            batch   = strcat('\batch',num2str(answer{3}),'\');

            if answer{3}==2
                data = xlsread('records.xlsx','records'); 
            end

        else
            name    = readcell('records.xlsx','sheet','records');
            expname = name(end,1);
            numexp  = name{end,2};
            batch   = strcat('\batch',num2str(3),'\');
            disp(['Processing experiment: ' expname ', run: ' num2str(numexp),...
                ' from batch: 3'])
        end
    end
    
%     automate_message = questdlg('Automate cropping and file selection (selects all)?', ...
%         'Image processing', ...
%         'Yes','No','Cancel');
    automate_message = 'Yes';
    switch automate_message
        case 'Yes'
            automate = true;
            disp('Automating process')
        case 'No'
            automate = false;
            disp('Using manual process')
    end
    
    if isempty(automate_message)
       return 
    end
    
    % Directory paths
    if ~batching
        exppath     = strcat(cd,batch,expname,'\run',num2str(numexp));
        savingpath  = char(strcat(exppath,'\run',num2str(numexp),'_workspace.mat'));
    else
        exppath     = strcat(cd,'\',batch,expname,'\run',num2str(numexp));
        savingpath  = char(strcat(exppath,'\run',num2str(numexp),'_workspace.mat'));
    end
        
    %% Get parameters from xls table
    if isfile(savingpath)
%         load_prompt = questdlg('Load the existing workspace file?','Yes',...
%                 'No');
        load_prompt = 'Yes';
            switch load_prompt
                case 'Yes'
                    if batching
                    exppath_new     = exppath;
                    savingpath_new  = savingpath;
                    automate_new    = automate;
                    runs_new        = runs;
                    end
                    
                    if isfile(savingpath)
                        load(savingpath)
                        if batching
                        exppath     = exppath_new;
                        savingpath  = savingpath_new;
                        automate    = automate_new;
                        runs        = runs_new;
                        end

                        name = readcell('records.xlsx','sheet','records');
                        data = xlsread('records.xlsx','records');


                        clear imageframes
                        skip2processing = true;
                    else
                       disp('No workspace file detected. Creating a new workspace.')
                       skip2processing = false;
                    end
                    
                case 'No'
                    clear imageframes
                    skip2processing = false;
            end
            if isempty(message1)
                return
            end
    end
    
        
    if ~skip2processing%strcmp(answer,'No')%||~isfile(savingpath)
        
        seper   = data(numexp,14);      % Hill seperation           (cm)
        salt    = data(numexp,11);      % Total salt content        (kg)
        N       = data(numexp,8);       % Buoyancy frequency        (rad / s)
        u       = data(numexp,4);       % Mean flow amplitude       (rev / s)
        ut      = data(numexp,3);       % Tidal amplitude           (rev / s)
        omega   = 2*pi/data(numexp,9);  % Tidal frequency           (rad / s)
        width   = data(numexp,15);      % Fluid width               (m)
        rhobot  = data(numexp,7);       % Initial bottom density    (kg / m3)
        rhotop  = data(numexp,6);       % Initial top density       (kg / m3)   
        depth   = data(numexp,2);       % Fluid depth               (m)
        sep     = data(numexp,14);      % Hill seperation           (m)
        
        %% Other parameters
        % Ridge dimensions
        h       = 4e-2;                     % Ridge height           (m)
        l_small = 5e-2;                     % Narrow e-folding width (m)
        l_mid   = 16e-2;                    % Wide e-folding width   (m)
    
        f       = 0;                        % Coriolis frequency     (rad / s)
        U       = data(numexp,4)*0.0359;    % Mean flow velocity     (m / s)
        Ut      = data(numexp,3)*0.0359;    % Tidal amplitude        (m / s)
        ex      = Ut/(omega*l_small/2);     % Excursion number
        Re      = Ut/N/h;                   % Reynolds number
        Cbar    = 1;                        % Proportionality constant
        C       = Cbar*rhotop*Ut^2*h^2*sqrt(N^2-omega^2);
                                            % Barotropic to internal tide
                                            % energy (W)
        alpha   = atan(sqrt(omega^2-f^2)/(N^2-omega^2));        
                                            % Tidal wave propogation angle (degrees) 
        FrhU    = (U)/(N*h);                % Vertical Froude number for mean flow
        FrLU    = (U)/(N*l_small);         	% Lateral Froude number for mean flow
        FrhUt   = (Ut)/(N*h);               % Vertical Froude number for tidal flow
        FrLUt   = (Ut)/(N*l_small);         % Lateral Froude number for tidal flow
    end