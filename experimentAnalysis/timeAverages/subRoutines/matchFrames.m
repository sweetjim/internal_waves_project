%% Match frames
% For use within the selected_runs loop. Script will catch the initial and
% final positions of the hills (as NaNs), and also their trajectories. 

dt      = data(selected_runs(i),17);
u       = zeros(length(selected_runs),1);
ut      = zeros(size(u));
omega   = zeros(size(u));
t       = linspace(0,min_t*dt,min_t);
trajectory = zeros(min_t,length(selected_runs));
hst     = zeros(2,4,length(selected_runs)); 
% Hill slice time: 
%((initial, final),
%(left hill rear, left hill front, right hill rear, right hill front))
%(run)
clf

for i=1:length(selected_runs)
    u(i)        = data(selected_runs(i),4)*0.0359;    % Mean flow velocity     (m / s)
    ut(i)       = data(selected_runs(i),3)*0.0359;    % Tidal amplitude        (m / s)
    omega(i)    = 2*pi/data(selected_runs(i),9);  % Tidal frequency           (rad / s)
    trajectory(:,i) = u(i)*t+ut(i)*sin(omega(i).*t);
    [h1,h2,h3,h4]   = getNans(initial_array(:,:,i));
    hst(1,:,i) = [h1,h2,h3,h4];
    [h1,h2,h3,h4]   = getNans(final_array(:,:,i)); 
    hst(2,:,i) = [h1,h2,h3,h4];
end

start_t = 0;
end_t   = min_t;

plot(t,trajectory(:,:)); hold on;
for i=1:length(selected_runs)
    pt_i = floor((hst(1,1,i))*dt);
    pt_f = floor((hst(2,4,i))*dt);
    sprintf('S: %i \t F: %i',pt_i,pt_f)
    if pt_i>start_t
        start_t = pt_i; 
    end
    if pt_f<end_t
        end_t = pt_f;
    end
    plot(t(pt_i),trajectory(pt_i,i),'squarek');
    plot(t(pt_f),trajectory(pt_f,i),'squarer');
end

plot(t(start_t),trajectory(start_t,i),'xk');
plot(t(end_t),trajectory(end_t,i),'xr');

function [h1,h2,h3,h4] = getNans(image)
h1 = find( isnan(image(:,80)),1);
h2 = find(~isnan(image(h1:end,80)),1)+h1;
h3 = find( isnan(image(h2:end,80)),1)+h2;
h4 = find(~isnan(image(h3:end,80)),1)+h3;
end