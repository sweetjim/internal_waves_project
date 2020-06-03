function [hill,beams] = getHill(x,pos,w,h,u,omega,N2,H1,displace,k)
    func    = @(x,x0,w0,h0) h0*exp(-(x-x0).^2/w0);
    hill    = func(x,pos,w,h);

    steepest_slope_up   = find(gradient(hill)>max(gradient(hill))*(1-1/100));
    steepest_slope_down = find(gradient(hill)<min(gradient(hill))*(1-1/100));

    % Beam start positions
    hill_bp = [steepest_slope_up steepest_slope_down];

    Omega2 = [(omega-u*k)^2 (omega+u*k)^2];

    beam_angle = cos(rad2deg(real([sqrt(Omega2(1)^2/(N2-Omega2(1))),...
            sqrt(Omega2(2)^2/(N2-Omega2(2)))])));

    beams(1,:) = (x-x(hill_bp(2))-displace).* beam_angle(1)-H1-h/exp(1); % Upstream
    beams(2,:) = (x-x(hill_bp(1))-displace).*-beam_angle(2)-H1-h/exp(1); % Downstream
end