function plotBeams(x,beams,beams_shaded,depth)
    fill([x,fliplr(x)],[beams_shaded(:,:,1),fliplr(beams_shaded(:,:,2))],'r','EdgeColor','none','FaceAlpha',0.1)
    fill([x,fliplr(x)],[beams_shaded(:,:,3),fliplr(beams_shaded(:,:,4))],'r','EdgeColor','none','FaceAlpha',0.1)
    
%     xi = find(x>pos(2),1);
%     xf = find(x>pos(1),1);
%     
%     x1 = find(beams(1,:,1)>depth,1);
%     x2 = find(beams(1,:,2)>depth,1);
%     x3 = find(beams(2,:,1)<depth,1);
%     x4 = find(beams(2,:,2)<depth,1);
%     
%     ref_pos = 2*[x(xi)-x(x2), x(xi)-x(x1)]
    
    
    plot(x,beams(:,:,1),'--k',x,beams(:,:,2),'--k')
    plot(x,beams(:,:,1),'--k',x,beams(:,:,2),'--k')
end