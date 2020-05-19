function getSubPlot(M,n,array,width,depth,title_name,varargin)
    
    if abs(depth)> 100
       y_label = 'Y position (pixels)'; 
    else
        y_label = 'Depth (m)';
    end
    if width>100
        x_label = 'X position (pixels)' ;
    else
        x_label = 'X position (m)';
    end
    if depth>0
        
        depth = [0 depth];
    else
        depth = [depth 0];
    end
    
    p = inputParser;
    default_m = 2;
    default_map = 'thermal';
    default_d_range = [-2 2];
    default_c_label = '';
    
    addParameter(p,'clabel',default_c_label,@ischar);
    addParameter(p,'m',default_m,@isnumeric);
    addParameter(p,'DisplayRange',default_d_range,@isnumeric)
    addParameter(p,'oceanmap',default_map,@ischar)
    parse(p,varargin{:})
    
    m       = p.Results.m;
    map     = p.Results.oceanmap;
    d_range = p.Results.DisplayRange;
    c_label = p.Results.clabel;
    
    
    
    subplot(M,m,n)
        image = interp2(flip(array'),-2);
        imshow(image,...
            imref2d(size(image),[0 width],depth),...
            'DisplayRange',d_range);
        cmocean(map)
        title(title_name)
        xlabel(x_label)
        ylabel(y_label)
        
        if ~strcmp(c_label,'')
            cbar = colorbar;
            cbar.Label.String = c_label;  
        end
        
end