%% Conversion script
% For usage after 'imageProcessing.m'. It will convert density fields into
% any desired form listed: 
% 1. "Real-density" (removes vignetting);
% 2. Background potential energy;
% 3. Fourier space

%% 1. "Real density" 
% Loading in the "apparent density" variable from the workspace, the
% average horizontal density at each pixel depth is saved to the variable
% 'realrho'
realrho = zeros(size(rho));

for i =1:size(rho,1)
    realrho(i,:) = mean(rho(i,:));
end
% Generate a linear fit and calculate the R squared
% xx                  = linspace(0,size(realrho,1),size(realrho,1));
[p_real,s_real]     = polyfit(depth_array,realrho(:,1)',1);
fit_real            = depth_array*p_real(1)+p_real(2);
Rsquared_real       = 1 - (s_real.normr/norm(realrho(:,1)' - mean(realrho(:,1)')))^2;

clf;
subplot(2,1,1)
    imshow(realrho);
    xlabel('\rho (kg/m^3)');ylabel('z (m)');
    imshow(realrho,imref2d(size(rho),[0 width],[0 depth]),...
            'DisplayRange',[rhotop rhobot]);
    cmocean('thermal');
    cbar = colorbar;
    cbar.Label.String = ('\Delta \rho (kg/m^3)');
    title('Ideal (real) background density');
    xlabel ('x (m)');
    ylabel ('z (m)');  
subplot(2,1,2)
    plot(depth_array,realrho(:,1),'k',depth_array,fit_real,'r')
    title(['\rho(z), R^2 = ' num2str(Rsquared_real)])
    xlabel('Depth (m)'); xlim([-depth 0]);
    ylabel('\rho (kg/m^3)')
    legend({'Real','Fit'},'Location','northeast')
    
%% Potential energy
% Using the relation: PE = b^2 / 2*N^2, where b = -g rho' / rho0 on the
% anomalous state, and PE = g/Ab*int_V(realrho(z)*z*dz) for the background
% state.

dz      = depth_array(2)-depth_array(1);
g       = 9.81;

% Background potential energy
for i=1:size(realrho,1)
    BPE(i) = sum((realrho(i,:)-realrho(1,:)).*depth_array(i))*dz*g;
end

plot(depth_array,BPE)
title('BPE profile')
xlabel('Depth (m)')
ylabel('BPE (J/kg)')

% Anomalous potential energy
aPE     = -g/(2*N^2*rhotop) .* den;

%% Discrete Fourier Transform
% 