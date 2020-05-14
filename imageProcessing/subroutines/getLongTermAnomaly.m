%% Long term density anomaly routine

% Locate the last transit frame
lastTransit = find(isnan(strat(1,:))>0,1,'last');

% % Delete all the frames with the topography visible
temporal = strat;
strat(:,any(isnan(strat(yslice,:)),1)) = [];

% nanindex = find(isnan(strat(yslice,:))>0,length(strat),'first');
% 
% count = 1;
% 
% for i=2:length(nanindex)-1
%     if nanindex(i+1)-nanindex(i)>2
%         dex(count)  = i;
%         count       = count+1;
%     end
% end
% 
% dex(any(dex==0))=[];
% samplebehind = nanindex(dex)-10;



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


title(strcat(expname,', Run: ',num2str(numexp),...
        ', - [N,\omega,u,ut,d] = [',...
        num2str(N,2),',',num2str(omega,2),',',...
        num2str(u,2),',',num2str(ut,2),',',...
        num2str(sep,2),'] - ',...
        'Time:',num2str(interval*timeStamp),' min'));

% Saving the figure
savefig(strcat(extractBefore(savingpath,'workspace.mat'),'temporal.fig'));