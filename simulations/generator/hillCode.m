%% Topography and variable resolution
% Draw a varying horizontal resolution that increases near the hills

x   = linspace(0,Lx,nx+1);
z   = -linspace(0,H1,nz+1);
z   = (z(1:end-1)+z(2:end))/2;
H   = min(z);

n1      = 0:nx-1;
res     = 0.01; % m
func    = @(x,x0,w0,h0) h0*exp(-(x-x0).^2/w0);
res_func = @(n1,nx,x0,x1) 1+tanh((n1-x0*nx)/x1);

% Initial setup for first plot
j       = 1;
pos     = (Lx/2+[sep+sep_array(j),-sep-sep_array(j)]);  % Position of the hills
res_pos = 0.5+0.3*(1+4*sep)*[-1 1];     % Bounds of the finest resolution profile
res_w0  = 50;

res_space   = res_func(n1,nx,res_pos(1),res_w0)-res_func(n1,nx,res_pos(2),res_w0);
hill_space  = H+func(x,pos(1),w0,h0)+func(x,pos(2),w0,h0);

clf
subplot(2,2,[1 2])
yyaxis left
plot(x,hill_space)
title('Resolving space')
ylabel('Height (m)')
xlabel('Position (m)')
ylim([H 0])
xlim([0 Lx])

dx  = res+(1e-3-res)/2*res_space;
x   = cumsum(dx)/sum(dx)*Lx;    % Normalize x
dx  = diff(x);
dx  = [dx dx(end)];             % Add missing index
x   = x(1:(nx));

yyaxis right
plot(x,dx*1e3)
ylim([min(dx) max(dx)*1.02]*1e3)
ylabel('Resolution (mm)')

for i=1:length(sep_array)
    pos = (Lx/2+[sep+sep_array(i),-sep-sep_array(i)]);
    h   = H+func(x,pos(1),w0,h0)+func(x,pos(2),w0,h0); % Generate hills
    
    sep_phrase = round(sep_array(i)*1e2);
    
    subplot(2,2,3)
    title('Hill seperation')
    plot(x,h); hold on;
    if i==length(sep_array)
        legend({sprintf('%i cm',round(sep_array(1)*1e2)),...
            sprintf('%i cm',round(sep_array(i)*1e2))})
    end
    xlabel('Position (m)')
    ylabel('Height (m)')
    ylim([H 0])
    xlim([2 3])
    
    %% Stratification and initial velocity field
    
    % Make uniform strat recalling:
    % rho = rho_0(1+beta(delS)) -> drho/dz/rho_0 = (beta(dS/dz)),
    % N2/g =  drho/dz/rho_0 -> N2/g = beta(dS/dz)
    
    dSdz    = N2/(-betaS*g);
    [X,Z]   = ndgrid(x,z);
    S       = dSdz*(Z+H1)+Sref; % Isopyncals every ~4.5m
    
    % initial v, match mean forcing to impulse
    [X,Z]   = ndgrid(x,z);
    mean    = u;
    omega0  = omega;
    u0      = omega0/(f0^2-omega0^2)*F0 + F0_meanV/f0; % Initial forcing velocity
    
    if i==length(sep_array)
        subplot(2,2,4)
        yyaxis left
        plot(z,S(1,:))
        title('Salinity profile')
        xlabel('Height (m)')
        ylabel('Salinity (psu)')
        
        dim = [.15 .25 .8 .28];
        str = sprintf('Initial velocity = %0.3f mm/s = %0.3f RPS',u0*1e3,u0/RPS2ms);
        annotation('textbox',dim,'String',str,'FitBoxToText','on');
        
        yyaxis right
        rho = rho_ref(2)*(1+betaS*(S(1,:)-S(1,1)));
        plot(z,rho)
        ylabel('Density (kg/m^3)')
        
        % Save the figure
        
        figure_name = sprintf('lm%s_figure.png',id);
        saveas(gcf,figure_name)
    end
    
    %% Field outputs
    dx_phrase = sprintf('dx_%d_mm.field',round(res*1e3));
    fid = fopen(dx_phrase, 'w' ,ieee);
    fwrite(fid,dx,accuracy);
    fclose(fid);
    v0_phrase = sprintf('v0_%d_mm_p_s.field',round(u0*1e3));
    fid     = fopen(v0_phrase,'w',ieee);
    fwrite(fid,u0*ones(size(X)),accuracy);
    fclose(fid);
    S_phrase  = sprintf('S_rho_%d_%d.field',round(rho_ref(2)),round(rho_ref(1)));
    fid     = fopen(S_phrase , 'w' ,ieee); % Change for S.field
    fwrite(fid,S,accuracy);
    fclose(fid);
    hill_phrase = sprintf('dh_%i_cm.field',sep_phrase);
    fid = fopen(hill_phrase, 'w' ,ieee);
    fwrite(fid,h,accuracy);
    fclose(fid);
    
    %% Data file inputs
    
    % Other files
    copyfile eedata_blank eedata
    copyfile data_blank.pkg data.pkg
    copyfile data_blank.mnc data.mnc
    
    project_phrase = sprintf('%s%i%s',project_name,sep_phrase,id);
    field_location = strcat(project_name,id,'_fields');
    
    run writeData
    
    %% Move exported files into folders
    parent_folder = strcat('model',id);
    
    if isfile(parent_folder)
        delete parent_folder
    end
    identifier_phrase = strcat(num2str(sep_phrase),'cm');
    
    model_folder_phrase = sprintf('%s%s',name_phrase,identifier_phrase);   % To go into payu directory
    field_folder_phrase = project_phrase;                                  % To go into /mitgcm_input directory
    mkdir(model_folder_phrase)
    mkdir(field_folder_phrase)
    
    model_files = {'data' 'config.yaml' 'eedata' 'data.pkg' 'data.mnc'};
    field_files = {dx_phrase hill_phrase S_phrase v0_phrase};
    for k=1:length(model_files);movefile(model_files{k},model_folder_phrase);end
    for k=1:length(field_files);movefile(field_files{k},field_folder_phrase);end
    
    % Move folders into identifier directory
    
    model_location = strcat(project_name,id,'_models');
    mkdir(parent_folder)
    mkdir(field_location)
    mkdir(model_location)
    
    if i==length(sep_array)
        movefile(figure_name,parent_folder)
    end
    movefile(model_folder_phrase,model_location)
    movefile(field_folder_phrase,field_location)
    
    movefile(field_location,parent_folder)
    movefile(model_location,parent_folder)
    
end
