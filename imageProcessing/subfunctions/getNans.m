function [h1,h2,h3,h4] = getNans(image)
h1 = find( isnan(image(:,80)),1);
h2 = find(~isnan(image(h1:end,80)),1)+h1;
h3 = find( isnan(image(h2:end,80)),1)+h2;
h4 = find(~isnan(image(h3:end,80)),1)+h3;
end