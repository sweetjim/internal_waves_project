function writeNC(ncpath,varargin)
p = inputParser;
default_create = false;
default_raw = true;
default_rawSize = [3088 800];
default_write = false;
default_xlength = 3088;
default_ylength = 800;

addParameter(p,'create',default_create,@isbool);
addParameter(p,'write',default_write,@isbool);
addParameter(p,'raw',default_raw,@isbool);
addParameter(p,'rawSize',default_rawSize,@isnumeric);
addParameter(p,'xlength',default_xlength,@isnumeric);
addParameter(p,'ylength',default_ylength,@isnumeric);
parse(p,varargin{:})

create   = p.Results.default_create;
write    = p.Results.default_write;
raw      = p.Results.default_raw;
rawSize  = p.Results.default_raw_size;
xlength  = p.Results.default_xlength;
ylength  = p.Results.default_ylength;

if create
    if raw
        % Create raw file
        nccreate(ncpath,'raw','Dimensions',...
        {'x',rawSize(1),'z',rawSize(2),'time',Inf},...
        'DeflateLevel',5,'Format' , 'netcdf4');

        nccreate(ncpath,'z','Dimensions',...
        {'z',rawSize(1)},...
        'DeflateLevel',5,'Format' , 'netcdf4');
        z = rawSize(1);
        ncwrite(ncpath,'z',z)

        nccreate(ncpath,'x','Dimensions',...
        {'x',rawSize(2)},...
        'DeflateLevel',5,'Format' , 'netcdf4');
        x = rawSize(2);
        ncwrite(ncpath,'x',x)
    end

    % Create anomaly file
    nccreate(ncpath,'anom','Dimensions',...
    {'x',ylength,'z',xlength,'time',Inf},...
    'DeflateLevel',5,'Format' , 'netcdf4');

    % Create the realistic scaling variables
    nccreate(ncpath,'z','Dimensions',...
    {'z',xlength},...
    'DeflateLevel',5,'Format' , 'netcdf4');
    z = depth;
    ncwrite(ncpath,'z',z)

    nccreate(ncpath,'x','Dimensions',...
    {'x',ylength},...
    'DeflateLevel',5,'Format' , 'netcdf4');
    x = width;
    ncwrite(ncpath,'x',x)
                
elseif write
    ncwrite(ncpath,'anom',image',[1 1 k]);
    if raw
        ncwrite(ncpath,'raw',raw_image',[1 1 k]);
    end
end

