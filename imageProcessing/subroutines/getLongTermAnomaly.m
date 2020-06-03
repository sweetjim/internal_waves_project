%% Long term density anomaly routine

% Locate the last transit frame
lastTransit = find(isnan(strat(1,:))>0,1,'last');

% % Delete all the frames with the topography visible
temporal = strat;
% strat(:,any(isnan(strat(yslice,:)),1)) = [];

% Plotting
imshow((strat),...
    imref2d(size(strat),[0 size(strat,2)],[0 depth]),...
    'DisplayRange',[vmin vmax]); 

xticks('auto');
axis('square')
cmocean('balance');
cbar = colorbar;
cbar.Label.String = ('\Delta \rho (kg/m^3)');

xlabel ('Time (min)');
ylabel ('Depth (m)'); 

title(sprintf(...
    'Run: %i - (N: %.2f, omega: %.2f, u: %.2f, ut: %.2f)',...
    numexp,N,omega,u,ut))

% title(strcat(expname,', Run: ',num2str(numexp),...
%         ', - [N,\omega,u,ut,d] = [',...
%         num2str(N,2),',',num2str(omega,2),',',...
%         num2str(u,2),',',num2str(ut,2),',',...
%         num2str(sep,2),'] - ',...
%         'Time:',num2str(interval*timeStamp),' min'));

% Saving the figure
save(savingpath,'temporal','strat','-append')
savefig(strcat(extractBefore(savingpath,'workspace.mat'),'temporal.fig'));