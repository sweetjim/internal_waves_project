if ~pathname
    return
end

if showPlot
%% Output routine
    % Create an .avi video file in the experiment's run directory.
    if ~longTransit
        run getMovie
    % Create a temporal plot of the long transit images    
    elseif longTransit
        run getLongTermAnomaly
    end
end