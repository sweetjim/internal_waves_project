%% Processing routine
close;
if ~pathname
    return
end
% Time the processing routine
tic;

% Conditional preamble
if ~longTransit
    message2 = questdlg('Track hill?', ...
        'Image processing', ...
        'Yes','No','Cancel');
    % Handle response
    switch message2
        case 'Yes'
            tracking    = true;
            temp        = true;
            cropsize    = 0.6;  % Define the relative size of the frame to be cropped
            clear xi xf midpt 
            si = [];
            call        = 'Writing tracked frames';            
        case 'No'
            tracking = false;
            call        = 'Writing non-tracked frames';
    end
    
    message3 = questdlg('Use MATLAB videowriter or NCView?', ...
            'Image processing', ...
            'MATLAB','NCView','Cancel');
        
            switch message3
                case 'MATLAB'
                    showPlot = true;
                case 'NCView'
                    showPlot = false;
            end
            
    if isempty(message2)
        return
    end
    
    prompt      = {'Number of hills:'};
    dlgtitle    = 'Input';
    dims        = [1 35];
    definput    = {'2'};
    hillnum     = inputdlg(prompt,dlgtitle,dims,definput);

    switch hillnum{1}
        case '2'
            hillsize    = 320;
            sep         = data(numexp,14);
        case '1' 
            hillsize    = 160;
    end
else
    tracking    = false;
    call        = 'Writing long transit frames';
end

%% Foreground cropping and intensity conversion loop
for im=startdim:endim
    if im==1
        % Create a waitbar to indicate progress
        f = waitbar(0,'1','Name',...
            call,...
            'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
        setappdata(f,'canceling',0);
        tic;
    end
    
    run getDensity

%%      Plotting 
    switch tracking
        case true
            run trackingRoutine
            if startTracking
                
                % Break if the frame exceeds the original image's frame
                if xmin(in)+wide>size(den,2)
                   break 
                end
               
                % Plotting (with filtering and cropping)
                if showPlot % MATLAB output
                    imshow(imcrop(medfilt2(flipud(den),[mfilt nfilt]),newcrop),...
                    imref2d(size(imcrop(den,newcrop)),...
                    [0 newxticks],...
                    [-depth 0]),...
                    'DisplayRange',[vmin vmax]);

                    cmocean('balance');
                    title(strcat(expname,', Run: ',num2str(numexp),...
                    ', - [N,\omega,u,ut,d] = [',...
                    num2str(N,2),',',num2str(omega,2),',',...
                    num2str(u,2),',',num2str(ut,2),',',...
                    num2str(sep,2),']'));
                    xlabel('x (m)');
                    ylabel('Depth (m)');
                    cbar = colorbar;
                    cbar.Label.String = ('\Delta \rho (kg/m^3)');

                    % Figure handling and frame saving
                    fig = figure(1);
                    fig.PaperPosition = newcrop;
                    imageframes(in) = getframe(fig); 
                    
                else % NCVIEW output
                    if in == 1
                       disp('Hill tracking initiated') 
                    end
                    run getDensityFile
                end
                
                in = in+1;
            end
            
           
        case false
            % Generate the relevant image frames or slices for short or long
            % transits.
            
            if ~longTransit                
                % Plotting (with filtering and cropping)
                if showPlot
                    imshow(medfilt2(flipud(den),[mfilt nfilt]),...
                    imref2d(size(den),...
                    [0 width],...
                    [-depth 0]),...
                    'DisplayRange',[vmin vmax]);

                    cmocean('balance');
                    title(strcat(expname,', Run: ',num2str(numexp),...
                    ', - [N,\omega,u,ut,d] = [',...
                    num2str(N,2),',',num2str(omega,2),',',...
                    num2str(u,2),',',num2str(ut,2),',',...
                    num2str(sep,2),']'));
                    ylabel('Depth (m)');
                    cbar = colorbar;
                    cbar.Label.String = ('\Delta \rho (kg/m^3)');

                    % Save the displayed figure to an array for later video writing
                    imageframes(im) = getframe(gcf); 
                end
                
                % Save each density file into a multidimensional array to a seperate
                % workspace
                run getDensityFile
    
            elseif longTransit
            % If long transit has been selected, take the mean density anomaly
            % along the horizontal axis of the picture and save each horizontal 
            % slice to the ith index of the array 'strat'.  

%             % Scale the image down by 50% for speed
%             den = interp2(den,-2);  

            % Preallocate 'strat'
            if im==1
               strat = zeros(size(den,1),endim);  
            end

            for y=1:size(den,1)
                strat(y,im) = mean(den(y,:));
                if strat(y,im)>4000
                    strat(y,im) = nan;
                end
            end
            
            timeStamp = endim;
            interval  = 1; %minutes
            end
    end
    
    if EnergyFluxRoutine
        if im==startdim
           anom = zeros(size(den,1),size(den,2),endim-startdim);
        end
       anom(:,:,im) = den;
    end
    
    % Check for clicked Cancel button
    if getappdata(f,'canceling')
        delete(f)
        return
    end


    % Update progress bar
    waitbar(im/endim,f,...
        {strcat(sprintf('%d',round(im/endim*100)),...
        '% ') }) 

    if im==1
       time = toc*endim/60;
       disp(['Estimated processing time:' num2str(time) ' minutes']);
    end
end

%% Tracking subroutine
if tracking
    if ~EnergyFluxRoutine
        run getTidalFrames
    end
end

%% Closing routine
computationTime = toc/60;
disp(['Processing time: ' num2str(computationTime) ' minutes'])
% Delete the waitbar
delete(f)

