%% Develop routine

if ~longTransit
    close(gcf) 
    f = makeWaitBar('Writing frames');
    
%     endim       = 2220;
%     startdim    = 1640;

    frame_step  = 1;
    frame_wide  = floor(size(bgimage_crop,2)*0.75);
    frame_high  = 850;
    
    if size(bgimage_crop,1)<frame_high
        fprintf('The vertical length of the image has been reduced from %i to %i.\n',...
            frame_high,size(bgimage_crop,1));
        frame_high = size(bgimage_crop,1);
    end
    fprintf('Image dimensions %i by %i.\n',frame_wide, frame_high);

    last_hif    = [0 0 0];
    hillCond    = false;
    startCond   = false;
    endCond     = false;
    preallocate = true;
    start_pos   = 500;
    
    clear left_edge right_edge
  
    for im=startdim:frame_step:endim
        
        run getDensity
        image = den;
        [hLL,hLR,hRL,hRR]   = getNans(image,'axis',2,'slice',80,'sample',10);
        mdpt_pos            = floor(0.5*(hRR+hLL));
        frame_left          = mdpt_pos-floor(frame_wide/2);
        
        if ~hillCond
            hif = countCrosses(isnan(image(80,:)));
            if sum(last_hif)+hif==32
                hillCond=true;
                continue
            else
                hillCond = false;
            end
            
            if sum(last_hif)+hif==24
                last_hif(3) = hif;
            else
                hillCond = false;
            end
            
            if last_hif(1)+hif==16
                last_hif(2)=hif;
            else
                hillCond = false;
            end
            
            if hif==8
                last_hif(1) = hif;
            else
                last_hif = [0 0 0];
                hillCond = false;
            end
        end
        
        if ~startCond
            if hillCond&&~isempty(hRL)&&~isempty(hRR)&&hLL>start_pos&&hLR>start_pos+100
                startCond = true;
            end
        end
        
        if startCond && frame_left>0
            if preallocate
                fprintf('Tracking initiated at: %i\n',im)
                start   = im;
                k       = 1;
                
                time_tracked    = length(start:frame_step:endim);
                h_pos           = zeros(4,time_tracked);
                left_edge       = zeros(1,time_tracked);
                right_edge      = zeros(1,time_tracked);
                flag_index      = zeros(1,time_tracked);
                preallocate     = false;
                
                ncpath = strcat(extractBefore(savingpath,'_workspace.mat'),...
                'tracked.nc');
    
                if isfile(ncpath)
                    delete(ncpath)
                end
                writeNC(ncpath,'xlength',frame_wide,'ylength',frame_high,...
                    'create',true,'raw',false);
            end
            
            if isempty(hLL)||isempty(hLR)||isempty(hRL)||isempty(hRR)
               h_pos(:,k) = h_pos(:,k-1);
               flag_index(k) = k;
            end
            
            h_pos(:,k)      = [hLL,hLR,hRL,hRR];
            mdpt_pos        = floor(0.5*(h_pos(4,k)+h_pos(1,k)));
            left_edge(k)    = mdpt_pos-floor(frame_wide/2);
            right_edge(k)   = mdpt_pos+floor(frame_wide/2);
            
            
            if left_edge(k)>0
                
                if right_edge(k)>size(bgimage_crop,2)
                    fprintf('Tracking finished at: %i\n',im)
                    timeEnd = k;
                    break
                end

                image = image(1:frame_high,left_edge(k):left_edge(k)+frame_wide-1);
                raw_image = density(1:frame_high,left_edge(k):left_edge(k)+frame_wide-1);
                writeNC(ncpath,'write',true,'raw',false);
            end
            timeEnd = k;
            k = k+1;
        end
        
        try
           updateWaitBar(f,im/endim,sprintf('%i/ %i',...
              im,endim))
        catch 
           disp('Cancelling\n')
           break
        end
        
%         
    end
    delete(f)
    
    %% Plotting
    
    wratio      = width/size(bgimage_crop,2);
    h_pos       = h_pos(:,1:timeEnd-1);
    mdpt_pos    = 0.5*(h_pos(4,:)+h_pos(1,:));
    dt          = data(numexp,17);
    t           = (1:timeEnd-1)*dt*frame_step;
    tidal_cycles = omega*max(t)/pi/2;
        
    
    
    % Define a function to find the zero crossing indexes
    zerocross   = @(v) find(v(:).*circshift(v(:), [-1 0]) <= 0);
    zcindex     = zerocross(gradient(h_pos(1,:)));
    
    % Get the image indexes
    tideStart   = zcindex(1);
    tideEnd     = zcindex(floor(tidal_cycles)*2-1);
    cycles      = floor(tidal_cycles);
    
    plot(...
        t(tideStart:tideEnd),h_pos(1,tideStart:tideEnd)*wratio,...
        t(tideStart:tideEnd),h_pos(4,tideStart:tideEnd)*wratio,...
        t(tideStart:tideEnd),mdpt_pos(1,tideStart:tideEnd)*wratio,...
        t(tideStart:tideEnd),(h_pos(1,tideStart:tideEnd)-start_pos)*wratio,...
        t(tideStart:tideEnd),(h_pos(4,tideStart:tideEnd)+start_pos)*wratio,...
        t(tideStart:tideEnd),left_edge(tideStart:tideEnd)*wratio,'k',...
        t(tideStart:tideEnd),right_edge(tideStart:tideEnd)*wratio,'k')
            
            xlabel('Time (s)')
            ylabel('Position (m)')
            ylim([0 3088*wratio])
            xlim([0 max(t)])
            
else
    % If long transit has been selected, take the mean density anomaly
    % along the horizontal axis of the picture and save each horizontal 
    % slice to the ith index of the array 'strat'.  

    f = makeWaitBar('Writing frames');
    strat = zeros(size(den,1),endim); 
    for im=1:endim
        run getDensity
        strat(:,im) = mean(den,2);

        timeStamp = endim;
        interval  = data(numexp,17)/60; %minutes
        try
           updateWaitBar(f,im/endim,sprintf('%i/ %i',...
              im,endim))
        catch 
           disp('Cancelling\n')
           break
        end
     end
    delete(f)
    run getLongTermAnomaly
end
%% Saving 
    save(savingpath)
    
%% Functions
function [h1,h2,h3,h4] = getNans(image,varargin)

 p = inputParser;
    default_axis = 1;   
    default_slice = 80;
    default_sample = 1;
    addParameter(p,'axis',default_axis,@isnumeric);
    addParameter(p,'slice',default_slice,@isnumeric);
    addParameter(p,'sample',default_sample,@isnumeric);
    parse(p,varargin{:})
    
    axis    = p.Results.axis;
    slice   = p.Results.slice;
    sample  = p.Results.sample;
    
    switch axis
        case 1
            h1 = max(find( isnan(image(:,slice)),sample));
            h2 = max(find(~isnan(image(h1:end,slice)),sample)+h1);
            h3 = max(find( isnan(image(h2:end,slice)),sample)+h2);
            h4 = max(find(~isnan(image(h3:end,slice)),sample)+h3);
        case 2
            h1 = max(find( isnan(image(slice,:)),sample));
            h2 = max(find(~isnan(image(slice,h1:end)),sample)+h1);
            h3 = max(find( isnan(image(slice,h2:end)),sample)+h2);
            h4 = max(find(~isnan(image(slice,h3:end)),sample)+h3);
    end
end