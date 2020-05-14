%% Get tidal frames subroutine

% Saving images from start and end of single tidal cycle from center
    figure(1)
    clf;
    hold on;
    
    space = linspace(0,length(xf),length(xf))+si;
    plot(space,xf,'k',space,...
        xi,'--k',space,midpt,'r');

    xlabel('Frame no.');
    ylabel('X position (pixels)');
    title('Trajectory of topography');


    % Find the first tidal cycle after 'midpt' passes the center of the
    % image
    midstart    = find(midpt>floor(size(den,2)/2),1,'first');
    % Take the gradient of the 'midpt' track to find peaks and troughs of
    % tidal cycle. Sample through a couple cycles (~500 pts) and then
    % normalize.
    smoothed    = normalize(smooth(gradient(midpt),10));
    smoothed    = smoothed/max(smoothed);

    % Define a function to find the zero crossing indexes
    zerocross   = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
    zcindex     = zerocross(smoothed);

    % Get the image indexes
    tideStart   = zcindex(1);
    tideEnd     = zcindex(3);

    names       = {'tidalStart' 'tidalEnd'};

    plot(space(tideStart),midpt(tideStart),'squarer',...
        space(tideEnd),midpt(tideEnd),'squarek');

    legend({'x_f' 'x_i' 'midpt' 'tideStart' 'tideEnd'},...
        'Location','southeast');

    hold off;
    for k=1:2
            figure(2)
            
            if k==1
                im = tideStart+si;
            elseif k==2
                im = tideEnd+si;
            end

            run getDensity

            % Define the cropping rectangle
            newcrop     = [1 1 size(den,2)-1 size(den,1)];

            % Define new x-axis limits
            newxticks = size(imcrop(den,newcrop),2)/size(den,2)*width;

            % Plot the density anomalies in different figures
            figure(k+1)
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
            
            if k==1
                den_tidestart = den;
            elseif k==2
                den_tideend = den;
            end
            
            % Save the figures
            savefig(strcat(extractBefore(savingpath,'workspace.mat'),...
            names{k},'.fig'));
    end 
    
    % Save the raw density anomaly files
    save(savingpath,'-append','den_tidestart','den_tideend')
    
   
    
    