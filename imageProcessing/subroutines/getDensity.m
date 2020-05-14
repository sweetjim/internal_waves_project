%% getDensity subroutine

    % Read in each foreground image, then crop to the background
    % image's defined size, then convert to an intensity profile
    
    if ~automate
        fimage      = imread(strcat(pathname,foreground{im}));
    else
        fimage      = imread(strcat(pathname,'\',foreground(im).name));
    end
    
    
    fimage_crop = imcrop(fimage,rect);
    log_front   = log(im2double(fimage_crop));

    % Remove any infintities 
    for i=1:size(log_front)
        if isinf(log_front(i))
            log_front(i) = nan;
        end
    end

    density = rhobot+beta.*(-log_front+intensityAverage(ztoprho));
    den     = density-rho;

    % Horizontally reverse the image if the transit direction is R2L
    if data(numexp,12)==1
                   den = fliplr(den);
    end

    % Clip the strong intensities 
    for i=1:size(den,1)
        for j=1:size(den,2)
            if (den(i,j)>cutoff)%&&(~isnan(den(i,j)))
               den(i,j) = nan; 
            end
        end
    end