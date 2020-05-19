function [h1,h2,h3,h4] = getNans(image,varargin)

 p = inputParser;
    default_axis = 1;   
    default_slice = 80;
    default_sample = 1;
    addParameter(p,'axis',default_axis,@isnumeric);
    addParameter(p,'slice',default_slice,@isnumeric);
    addParameter(p,'sample',default_sample,@isnumeric);
    parse(p,varargin{:})
    
    axis    = p.Results.axis;
    slice   = p.Results.slice;
    sample  = p.Results.sample;
    
    switch axis
        case 1
            h1 = max(find( isnan(image(:,slice)),sample));
            h2 = max(find(~isnan(image(h1:end,slice)),sample)+h1);
            h3 = max(find( isnan(image(h2:end,slice)),sample)+h2);
            h4 = max(find(~isnan(image(h3:end,slice)),sample)+h3);
        case 2
            h1 = max(find( isnan(image(slice,:)),sample));
            h2 = max(find(~isnan(image(slice,h1:end)),sample)+h1);
            h3 = max(find( isnan(image(slice,h2:end)),sample)+h2);
            h4 = max(find(~isnan(image(slice,h3:end)),sample)+h3);
    end
end