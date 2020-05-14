%% Visual routine

% 
dt      = 0.125;
wide    = input(sprintf('Enter a frame width (between %.2f and %.2f) in meters: ',...
    r*wratio,w*wratio));
frame_wide      = floor(wide/wratio);
anom_ta_array   = zeros(frame_wide,min_z,length(selected_runs));

for i=1:length(selected_runs)
    
    %% 
    
%     clear tideStart tideEnd
%     load(wspath,'tideStart','tideEnd')
%     
%     % Define arbitrary tidal start and stop times if they don't exist
%     if ~exist('tideStart')||~exist('tideEnd')
%         tideStart = 200;
%         tideEnd = 230;
%         disp("Variables 'tideStart' and 'tideEnd' do not exist")
%     end
    
      
    %%  Integrate through the anomaly field
    % Find the cut off distance on the last frame
%     anom_end = ncread(ncpath,'anom',[1 1 anom_info.Size(3)],...
%         [anom_info.Size(1) anom_info.Size(2) 1]);
%     
%     % Define constants ONLY for similar runs (USER DEFINED)
%     if i==1
%         % Get the distance between the hill and the edge of the frame from
%         % the last time slice (cut-off point) for the largest hill
%         % seperation run and define a fixed frame width.
%         [he1,he2,he3,he4] = getNans(anom_end);
%         
%         if isempty(he3)
%             he4 = he2;
%         end
%             
%         r = anom_info.Size(1)-he4;
%         
%         if r>800
%            r = 800; 
%         end
%         
%         wide = he4-he1+2*r;
%         
%         anom_ta_array = zeros(anom_info.Size(2),wide,...
%             length(selected_runs));
%     end

    % Pre-allocate the time-average
    anom_ta = zeros(frame_wide,min_z);
        
    % Define times
    tideStart   = 1;
    tideEnd     = min_t;
    
    delT = (tideEnd-tideStart)*dt;
    tideEnd = tideEnd+(delT/dt*2);
    
    f = waitbar(0,'1','Name','Integrating',...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(f,'canceling',0);
    
    for j=tideStart:tideEnd
        try
            % Anomaly field at time slice 'j'
            anom = ncread(ncpath,'anom',[1 1 j],[info.Size(1) info.Size(2) 1]);

            % Hill nan positions (hill-slices)
            [hs1,hs2,hs3,hs4] = getNans(anom);
            xmin = hs1 - r;

            % Load in the cropped image
            anom = ncread(ncpath,'anom',[xmin 1 j],[wide min_z 1]);

            % Calulcate the integral at time t = 'j'
            time_slice = dt*anom.^2;
            anom_ta = anom_ta + time_slice;

            % Check for waitbar cancelation
            if getappdata(f,'canceling')
                delete(f)
                return
            end
            % Update waitbar and message
            waitbar((j-tideStart)/(tideEnd-tideStart),f,sprintf('%d/%d',...
                j-tideStart,tideEnd-tideStart))
        catch ME
           disp(ME.identifier)
           delete(f)
           break
        end
    end
    
    
    % Evaluate the integral and save to the array
    anom_ta = (anom_ta/delT);
    anom_ta_array(:,:,i) = anom_ta;
    delete(f)
    
    %% Plotting
    
    N       = data(selected_runs(i),8);
    omega   = 2*pi/data(selected_runs(i),9);
    u       = data(selected_runs(i),4)*0.0359;
    ut      = data(selected_runs(i),3)*0.0359;
    d       = data(selected_runs(i),14);
    
    title_name = sprintf('Run: %i, [N,\omega,u,ut,d] = [%.2f,%.2f,%.2f,%.2f,%.2f]',...
        selected_runs(i),N,omega,u,ut,d);
    
    getPlot(medfilt2(anom_ta,[10 10]),width,depth,title_name,clabel)

    %% 
    
    % Save time-average image file
    
    if ~isempty(runs_prompt{1})
        start = num2str(selected_runs(1));
        stop = num2str(selected_runs(end));
        extension = strcat(start,'to',stop);
    elseif ~isempty(runs_prompt{2})
        if length(selected_runs)>1
            extension = join(split(num2str(selected_runs),' '),'_');
        else
            extension = num2str(selected_runs);
        end
    end    
    workspace_name = strcat(savingpath,'timeAverages_run',extension,'.mat');
    
    if i==1
      save(workspace_name,'anom_ta') 
    else
      save(workspace_name,'-append','anom_ta')  
    end
    
    
end



function [h1,h2,h3,h4] = getNans(image)
h1 = find( isnan(image(:,80)),1);
h2 = find(~isnan(image(h1:end,80)),1)+h1;
h3 = find( isnan(image(h2:end,80)),1)+h2;
h4 = find(~isnan(image(h3:end,80)),1)+h3;
end

function getPlot(image,width,depth,title_name,clabel)
    imshow(image,...
        imref2d(size(image),[0 width],[depth 0]),...
        'DisplayRange',[0 1]);
    cmocean('tempo')
    axis square
    title(title_name)
    xlabel('X position (m)')
    ylabel('Depth (m)')
    cbar = colorbar;
    cbar.Label.String = clabel;
end