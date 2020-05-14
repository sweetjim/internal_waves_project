function [w, u] = vel_calculation(xGrid,yGrid,rhoGrid,N0,dt,CGS)

%% Set step sizes;

dz = yGrid(2,2)-yGrid(1,1);
dx = xGrid(2,2)-xGrid(1,1);

%% Set system parameters

if CGS == 1
    g = 980;
    rho_0 = 1;
else
    g = 9.8;
    rho_0 = 1000;
end


%% Calculate density perturbation time derivative

nSlices = size(rhoGrid,3);

dRho_dt = zeros(size(rhoGrid,1),size(rhoGrid,2),nSlices);

for j = 1:nSlices
    if j == 1
        dRho_dt(:,:,j) = (-rhoGrid(:,:,1) + rhoGrid(:,:,2))/dt; 
    elseif j == nSlices
        dRho_dt(:,:,j) = (-rhoGrid(:,:,end-1) + rhoGrid(:,:,end))/dt;         
    elseif j == 2
        dRho_dt(:,:,j) = (-rhoGrid(:,:,1) + rhoGrid(:,:,3))/dt/2; 
    elseif j == nSlices-1        
        dRho_dt(:,:,j) = (-rhoGrid(:,:,end-2) + rhoGrid(:,:,end))/dt/2; 
    else
        dRho_dt(:,:,j) = ( rhoGrid(:,:,j-2)/12 - 2*rhoGrid(:,:,j-1)/3 + 2*rhoGrid(:,:,j+1)/3 - rhoGrid(:,:,j+2)/12 )/dt;
    end
end

%% Calculation of the vertical velocity 

w = g./N0.^2/rho_0.*dRho_dt;

%% Vertical velocity gradient

dw_dz_exp = permute(fourth_grad(permute(w,[2 1 3]),dz),[2 1 3]);

%% Horizontal integration

for j = 1:nSlices
    u1(:,:) = -cumsum(dw_dz_exp(:,:,j),2)*dx;
    u2(:,:) = cumsum(dw_dz_exp(:,end:-1:1,j),2)*dx; u2 = u2(:,end:-1:1);


    %% Identify where the boundary is good to start integration from

    for i = 1:size(rhoGrid,1)

        ind = i-2:i+2;
        f = find(ind>0 & ind<=size(rhoGrid,1));
        ind = ind(f);

        rStartMean(i) = mean(abs(rhoGrid(ind,1,j)));
        rEndMean(i) = mean(abs(rhoGrid(ind,end,j)));

    end

    indStart = find(rStartMean<rEndMean);
    indEnd = find(rEndMean<=rStartMean);

    %% Set the horizontal velocity

    u(indStart,:,j) = u1(indStart,:);
    u(indEnd,:,j) = u2(indEnd,:);

%% Smooth the velocity fields

for k = 1:3; for i = 1:size(u,2); u(:,i,j) = smooth(u(:,i,j),5); end; end

end

end

function df_dx = fourth_grad(f,dx)

df_dx = 0*f;

for j = 1:size(f,3)

    df_dx(:,1,j) = -3/2*f(:,1,j) + 2*f(:,2,j) - f(:,3,j)/2;
    df_dx(:,2,j) = -f(:,1,j)/2 + f(:,3,j)/2;
    df_dx(:,3:end-2,j) = 1/12*f(:,1:end-4,j) - 2/3*f(:,2:end-3,j) + 2/3*f(:,4:end-1,j) - 1/12*f(:,5:end,j);
    df_dx(:,end-1,j) = -f(:,end-2,j)/2 + f(:,end,j)/2;
    df_dx(:,end,j) = 3/2*f(:,end,j) - 2*f(:,end-1,j) + f(:,end-2,j)/2;
end
    
    
df_dx = df_dx/dx;

end