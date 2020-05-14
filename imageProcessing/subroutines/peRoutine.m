%% PE Routine
% To obtain the potential energy of the fluid we peicewise integrate
% vertically, as: PE(z) = g*INT_0^z(rho)dz

% The double 'density' is a logarithmic light attenuation intensity field
% that has been converted to a density field. 

figure(1)
subplot(2,1,1)
doPlot(medfilt2(density,[4 4]),width,depth,rhotop,rhobot,'Absolute density')
subplot(2,1,2)
doPlot(medfilt2(den,[4 4]),width,depth,vmin,vmax,'Anomalous density')

integratePE = @(x1,x2) x1-x2;

g           = 9.81;
PE          = zeros(size(den)); 

width_array = linspace(0,width,size(den,2));
dz          = depth_array(2)-depth_array(1);



for y=1:size(den,1)
%     for x=1:size(den,2)
        PE(y,:) = trapz((density(y,:))-density(1,:))*-depth_array(y)*g*dz;
%         PE(y,x) = g*dz*sum(density(1:y,x).*depth_array(1:y));
%     end
end

figure(2)
plot(PE,depth_array);
title('Background potential energy')
xlabel('BPE (J/s)')
ylabel('Depth (m)')

function doPlot(density,width,depth,min,max,name)

    imshow(density,imref2d(size(density),...
                [0 width],...
                [-depth 0]),...
                'DisplayRange',[min max]);
    title(name);
    xlabel('x (m)')
    ylabel('Depth (m)')
    cbar = colorbar;
    cbar.Label.String = ('\Delta \rho (kg/m^3)');
end