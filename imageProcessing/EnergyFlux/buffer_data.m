function [xGrid, yGrid, rho_pert, ind] = buffer_data(xGrid, yGrid, rho_pert, gpX, gpY, diffuse)

dx = xGrid(2,2)-xGrid(1,1);

bufferSizeX = (max(xGrid(:))-min(xGrid(:)))*gpX;
nPx = ceil(bufferSizeX/dx);
bufferSizeX = nPx*dx;
bufferX = dx*[1:nPx];

bufferSizeY = (max(yGrid(:))-min(yGrid(:)))*gpY;
nPy = ceil(bufferSizeY/dx);
bufferSizeY = nPy*dx;
bufferY = dx*[1:nPy];

xBuffer = [min(xGrid(:))-bufferX(end:-1:1) xGrid(1,:) max(xGrid(:))+bufferX];
yBuffer = [min(yGrid(:))-bufferY(end:-1:1) yGrid(:,1)' max(yGrid(:))+bufferY];

[xGridWindow,zGridWindow] = meshgrid(xBuffer,yBuffer);

[s1, s2] = size(xGrid);
f_grid_out = boarder_points(1,1,s1,s2)';

[s1, s2] = size(xGridWindow);
f_out_toInterpolate = boarder_points(nPy, nPx, s1, s2);

xI = [xGrid(f_grid_out); xGridWindow(1,2:end-1)'; xGridWindow(end,2:end-1)'; xGridWindow(:,1); xGridWindow(:,end)];
yI = [yGrid(f_grid_out); zGridWindow(1,2:end-1)'; zGridWindow(end,2:end-1)'; zGridWindow(:,1); zGridWindow(:,end)];

rpg_Window = zeros(size(xGridWindow,1),size(xGridWindow,2),5);

h_bar = waitbar(0,'Buffering Data: 0%');

if diffuse == 1

    warning('off','MATLAB:scatteredInterpolant:DupPtsAvValuesWarnId');

    for k = 1:size(rho_pert,3)


        rpg = rho_pert(:,:,k);
        rhoPertGridWindow = zeros(s1,s2);


        rI = [rpg(f_grid_out); 0*xGridWindow(1,2:end-1)'; 0*xGridWindow(end,2:end-1)'; 0*xGridWindow(:,1); 0*xGridWindow(:,end)];

        rhoPertGridWindow(f_out_toInterpolate) = griddata(xI,yI,rI,xGridWindow(f_out_toInterpolate),zGridWindow(f_out_toInterpolate));
        
        rhoPertGridWindow(1+nPy:end-nPy,1+nPx:end-nPx) = rho_pert(:,:,k);  

        for i = 1:10


            for j = 1:size(rhoPertGridWindow,1)
                rhoPertGridWindow(j,:) = smooth(rhoPertGridWindow(j,:),max([1 ceil(nPx/3)]));
            end
            for j = 1:size(rhoPertGridWindow,2)
                rhoPertGridWindow(:,j) = smooth(rhoPertGridWindow(:,j),max([1 ceil(nPy/3)]));
            end

            rhoPertGridWindow(1+nPy:end-nPy,1+nPx:end-nPx) = rho_pert(:,:,k);       

        end

        rpg_Window(:,:,k) = rhoPertGridWindow;
        waitbar(k/size(rho_pert,3),h_bar,sprintf('Buffering Data: %d%%',k/size(rho_pert,3)*100))

    end

    warning('on','MATLAB:scatteredInterpolant:DupPtsAvValuesWarnId');
    
else
    
    rpg_Window = zeros(size(xGridWindow,1),size(xGridWindow,2),size(rho_pert,3));
    
    for k = 1:size(rho_pert,3)
        
        rpg_Window(1+nPy:end-nPy,1+nPx:end-nPx,k) = rho_pert(:,:,k);
        waitbar(k/size(rho_pert,3),h_bar,sprintf('Buffering Data: %d%%',k/size(rho_pert,3)*100))
        
    end
    
end

close(h_bar)

xGrid = xGridWindow;
yGrid = zGridWindow;
rho_pert = rpg_Window;

ind = [nPy+1 size(rho_pert,1)-nPy nPx+1 size(rho_pert,2)-nPx];

end

function f_out = boarder_points(nPy, nPx, s1, s2)

[ind1, ind2] = meshgrid(1+nPy:s1-nPy,1+nPx:s2-nPx);
f = sub2ind([s1 s2],ind1,ind2);
f_out = setdiff(1:s1*s2,f(:));

end