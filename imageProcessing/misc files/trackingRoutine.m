%% Tracking subroutine

% Tracking of topography
if temp
    if im==startdim        
        yslice      = 80; 
        sample_in   = 10;   % Define the number of indexes in find-searches to be sampled
        space       = linspace(0,endim,endim);
        xitemp      = zeros(1,endim);
        xftemp      = zeros(1,endim);
        mtemp       = zeros(1,endim);
    end
    xitemp(im)  = max(find(isnan(den(yslice,:))>0,sample_in,'first'));  % Trailing hill position
    xftemp(im)  = min(find(isnan(den(yslice,:))>0,sample_in,'last'));   % Leading hill position
    
    rtemp       = floor(size(den,2)*cropsize/2);            % Define a constant frame width equal to half the frame
    mtemp(im)   = floor((xftemp(im)+xitemp(im))/2);         % Define the midpoint

    % Triggering new crop conditions
    
    cond1   = sum(isnan(den(yslice,:)))>hillsize;           % When the number of nans exceeds two hills
    cond2   = xitemp(im)-rtemp>1;                           % When the radius enters the frame
    cond3   = mtemp(im)-rtemp>1;                            % When the xmin cropping rectangle enters the image
    cond4   = mtemp(im)+rtemp<size(den,2);                  % When the width cropping rectangle exits the image

    allcond = cond1++cond2+cond3+cond4 == 4;
    
    if isempty(allcond)
       allcond = false; 
    end
end

if allcond                      % Starting conditions
    startTracking   = true;
    temp            = false;    % Stop temp section
    if isempty(si)
        si = im;                % Define start index
        in = 1;
    end
else
    startTracking   = false;
end

if startTracking
    xi(in)      = max(find(isnan(den(yslice,:))>0,sample_in,'first'));
    xf(in)      = min(find(isnan(den(yslice,:))>0,sample_in,'last'));
    midpt(in)   = floor((xf(in)+xi(in))/2); 

    % Define a constant radius 'r' from the midpoint of the two
    % hills and a cropping width that encompasses both.
    if in==1
        r       = rtemp;%floor((xf(in)-xi(in))/4); 
        wide    = r*2; 
    end
    % crop rect: [xmin ymin width height] 

    % Define the cropping rectangle
    xmin(in)    = midpt(in)-r;
    newcrop     = [xmin(in) 1 wide size(den,2)];

    % Define new x-axis limits
    newxticks = size(imcrop(den,newcrop),2)/size(den,2)*width;
end
