%% Density saving routine (NetCDF format)

if (k==start)
    
    ncpath = strcat(extractBefore(savingpath,'_workspace.mat'),...
        'tracked.nc');
    
    if isfile(ncpath)
        delete(ncpath)
    end
    
    % Create the image variables with 5x compression
    nccreate(ncpath,'anom','Dimensions',...
    {'x',frame_wide,'z',frame_high,'time',Inf},...
    'DeflateLevel',5,'Format' , 'netcdf4');

    % Create the realistic scaling variables
    nccreate(ncpath,'z','Dimensions',...
    {'z',frame_high},...
    'DeflateLevel',5,'Format' , 'netcdf4');
    z = depth;
    ncwrite(ncpath,'z',z)

    nccreate(ncpath,'x','Dimensions',...
    {'x',frame_wide},...
    'DeflateLevel',5,'Format' , 'netcdf4');
    x = width;
    ncwrite(ncpath,'x',x)

end

% ncwrite(ncpath,'abs',density',[1 1 im])
ncwrite(ncpath,'anom',den',[1 1 k])

