%% Visual routine
[anom_ta_array,max_cycles]= preAllocate(endim,experiment_path,selected_runs);

for i=1:endim      
    %%  Integrate through the anomaly field
    [ncpath,wspath,info] = getRunInfo(i,experiment_path,selected_runs);
    frame_wide = size(anom_ta_array,2);
    frame_high = size(anom_ta_array,1);
    
    % Pre-allocate the time-average
    anom_ta = zeros(frame_wide,frame_high);
    
    load(wspath,'tideStart','tideEnd','width','depth',...
        'zcindex','cycles')
    % Define times
    dt          = data(selected_runs(i),17);
    delT        = (tideEnd-tideStart)*dt;
    tideEnd     = zcindex(floor(tidal_cycles)*2-1);
    
    f = makeWaitBar(sprintf('Integrating Run: %i',selected_runs(i)));
    
    
    
    for j=tideStart:tideEnd
            % Anomaly field at time slice 'j'
%             anom = ncread(ncpath,'anom',[1 1 j],[info.Size(1) info.Size(2) 1]);

            % Hill nan positions (hill-slices)
%             [hs1,hs2,hs3,hs4] = getNans(anom);
%             xmin = hs1 - r;

            % Load in the cropped image
            anom = ncread(ncpath,'anom',[1 1 j],[frame_wide frame_high 1]);

            % Calulcate the integral at time t = 'j'
            time_slice = dt*anom.^2;
            anom_ta = anom_ta + time_slice;
            
            updateWaitBar(f,(j-tideStart)/(tideEnd-tideStart),...
                sprintf('%d/%d',j-tideStart,tideEnd-tideStart))
    end
    delete(f)
    
    % Evaluate the integral and save to the array
    anom_ta = (anom_ta/delT);
    anom_ta_array(:,:,i) = anom_ta';
    
end

%% Plotting

figure(3)
clf;
f = makeWaitBar('Making plots');
for i=1:endim
    N       = data(selected_runs(i),8);
    omega   = 2*pi/data(selected_runs(i),9);
    u       = data(selected_runs(i),4)*0.0359;
    ut      = data(selected_runs(i),3)*0.0359;
    d       = data(selected_runs(i),14);
    
    title_name = sprintf('Run: %i, (N,omega,u,ut,d) = (%.2f(1/s),%.2f(1/s),%.2f(mm/s),%.2f(mm/s),%.2f(cm))',...
        selected_runs(i),N,omega,u*1e3,ut*1e3,d);
    
    image = interp2(medfilt2(anom_ta_array(:,:,i),[10 10]),0);
    getSubPlot(endim,i,log10(image'),width,depth,title_name,...
        'm',1,...
        'clabel','log_{10}(|\Delta\rho|^2\cdot s)',...
        'oceanmap','tempo',...
        'DisplayRange',[-2 2])
    updateWaitBar(f,i/endim,sprintf('%i/%i',i,endim))
end
delete(f)
%% Workspace saving
% Save time-average image file

if ~isempty(runs_prompt{1})
    start = num2str(selected_runs(1));
    stop = num2str(selected_runs(end));
    extension = strcat(start,'to',stop);
elseif ~isempty(runs_prompt{2})
    if endim>1
        extension = join(split(num2str(selected_runs),' '),'_');
    else
        extension = num2str(selected_runs);
    end
end    
workspace_name = strcat(savingpath,'timeAverages_run',extension,'.mat');

save(workspace_name,'anom_ta_array') 

saveas(gcf,strcat(savingpath,'timeAverages_run',extension,'.png'))

%% Functions
function [array,cycles] = preAllocate(endim,experiment_path,selected_runs)
frame_wide = 4000;
frame_high = 1000;
cycles = 20;
for i=1:endim
    [~,wspath,info] = getRunInfo(i,experiment_path,selected_runs);
    if info.Size(2)<frame_high
       frame_high = info.Size(1);
    end
    if info.Size(1)<frame_wide
       frame_wide = info.Size(2); 
    end
    load(wspath,'tidal_cycles')
    if tidal_cycles<cycles
        cycles = tidal_cycles;
    end
end
array   = zeros(frame_wide,frame_high,endim);
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