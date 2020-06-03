%% Further processing routines

%% Use EnergyFlux
% Loading in one tidal cycle from the 'getTidalFrames' entries. Here the
% 'processingRoutine' will be re-run but now each density perturbation will
% be saved to the multidimensional array 'anom(z,x,t)'. A coordinate array
% will also be generated 'xzgrid'

if tracking
    startdim            = tideStart;
    endim               = tideEnd;
    EnergyFluxRoutine   = true;
    run processingRoutine
end


%% Transform into frequency space
    
%% 
