function [x1,x2] = getPositions(labimage,width)
    x1  = find(isnan(labimage(end-100,:)),1,'first');
    x2  = find(isnan(labimage(end-100,:)),1,'last');
    mid = 0.5*(x1+x2);

    x1 = (  find(isnan(labimage(end-100,1:mid)),1,'last')+...
            find(isnan(labimage(end-100,1:mid)),1,'first'))...
            /2/size(labimage,2);

    x2 = (( find(isnan(labimage(end-100,mid:end)),1,'last')+...
            find(isnan(labimage(end-100,mid:end)),1,'first'))/2 + mid)/size(labimage,2);

    x1 = x1*width;
    x2 = x2*width;
end

