%% Density saving routine (NetCDF format)

if tracking
    im = in;
end

if (im==startdim)%||(in==startdim)
    
    ncpath = strcat(extractBefore(savingpath,'_workspace.mat'),...
        '_densityFiles.nc');
    
    if isfile(ncpath)
        delete(ncpath)
    end
    
    % Create the image variables with 5x compression
    
    nccreate(ncpath,'abs','Dimensions',...
    {'x',size(density',1),'z',size(density',2),'time',Inf},...
    'DeflateLevel',5,'Format' , 'netcdf4');

    nccreate(ncpath,'anom','Dimensions',...
    {'x',size(den',1),'z',size(den',2),'time',Inf},...
    'DeflateLevel',5,'Format' , 'netcdf4');

    % Create the realistic scaling variables
    nccreate(ncpath,'z','Dimensions',...
    {'z',size(den,1)},...
    'DeflateLevel',5,'Format' , 'netcdf4');
    z = depth;
    ncwrite(ncpath,'z',z)

    nccreate(ncpath,'x','Dimensions',...
    {'x',size(den,2)},...
    'DeflateLevel',5,'Format' , 'netcdf4');
    x = width;
    ncwrite(ncpath,'x',x)

%     nccreate(ncpath,'t','Dimensions',...
%     {'t',endim},...
%     'DeflateLevel',5,'Format' , 'netcdf4');
%     shutter = 0.125;
%     t = shutter*endim;
%     ncwrite(ncpath,'t',t)            
end

ncwrite(ncpath,'abs',density',[1 1 im])
ncwrite(ncpath,'anom',den',[1 1 im])

