%% Foreground routine 
    if isempty(message1)
       return 
    end
    
    % Define the lowest bound for the image's density anomaly
    % and clip the large density anomalies (like the ridge)
    cutoff      = 8; 
    
    % Set the colourmap and colorbar vertical limits
    vmin        = -3;
    vmax        = -vmin;
    
    % Set the median filtering neighbourhood parameters
    mfilt       = 3;
    nfilt       = 2;
    
    % Vertically reverse the image
    flipImage   = 1;
    
    % Preallocate the long transit density stratification profile and 
    % define the relevant image paths
    
    longTransit = data(numexp,16);
    
    
    if longTransit
       path2fgimages    = char(strcat(exppath,'\longtransit'));
       header           = 'Choose long transit images';
    elseif ~longTransit
       path2fgimages    = char(strcat(exppath,'\transit'));
       header           = 'Choose short transit images';
    end 
    
    if ~automate
        [foreground,pathname] = uigetfile(fullfile(path2fgimages,'*.tiff'),...
            header,'MultiSelect','on');
        % Get the last image index
        endim   = size(foreground,2);
    else
        foreground  = dir(fullfile(path2fgimages,'*.tiff'));
        pathname    = path2fgimages;
        endim       = length(foreground);
    end
    
    startdim = 1;
    EnergyFluxRoutine = false;
    
    if ~pathname
       return 
    end
    
    
    
   

    
    
    
