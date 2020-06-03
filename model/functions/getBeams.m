function [beams,beams_shaded,h] = getBeams(x,pos,u,ut,w0,h0,omega,N2,H1,k,sign)
%GETBEAMS Summary of this function goes here
%   Detailed explanation goes here
    beams           = zeros(2,length(x),2);
    beams_shaded    = zeros(2,length(x),2);
        
    [tp1,beams1] = getHill(x,pos(1),w0,h0,u,omega,N2,H1,0,k);
    [tp2,beams2] = getHill(x,pos(2),w0,h0,u,omega,N2,H1,0,k);

    h   = sign*(tp1+tp2);
    displace = ut/omega;

    [~,beams1_disp_up]   = getHill(x,pos(1),w0,h0,u,omega,N2,H1, displace,k);
    [~,beams2_disp_up]   = getHill(x,pos(2),w0,h0,u,omega,N2,H1, displace,k);
    [~,beams1_disp_down] = getHill(x,pos(1),w0,h0,u,omega,N2,H1,-displace,k);
    [~,beams2_disp_down] = getHill(x,pos(2),w0,h0,u,omega,N2,H1,-displace,k);
    
    beams(:,:,1) = beams1; 
    beams(:,:,2) = beams2;
    beams_shaded(:,:,1) = beams1_disp_up;
    beams_shaded(:,:,2) = beams1_disp_down;
    beams_shaded(:,:,3) = beams2_disp_up;
    beams_shaded(:,:,4) = beams2_disp_down;
end

