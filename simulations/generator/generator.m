%% Script that generates relevant model folders
clearvars
clc
name_phrase = 'lab_model';  % The longhand model title (appears only in model folders)
project_name = 'lm';        % The shorthand version (appears elsewhere)
ieee    = 'b' ; 
accuracy= 'real*8' ; 
input_location = '/scratch/nm03/js8285/mitgcm_input/';  % Storage location of the field files
RPS2ms  = 0.0359;

% Model settings
model_time  = 60;           % Seconds
cpus        = 16;           
memory      = 32;           % GB
walltime    = 5;            % Hours (to 1 decimal place!)
deltaT_max  = 0.001;        % Maximum timestep desired (will be reduced if larger than resolving velocity) in seconds
bin_time    = 1;            % Time at which the model compiles a frame
res         = 0.01;         % Minimum resolution

% Grid settings
nx  = 1024; % pts
ny  = 1;    % pts
nz  = 300;  % pts
Lx  = 5;    % m
H1  = 0.3;  % m

% Environment settings
g       = 9.81;             % Gravity (m/s2)
rho_ref = [1020 1004];      % Top and bottom densities (kg/m3)
alphaT  = 2e-4;             % Thermal coefficient (1/K) (unused in a haline experiment)
betaS   = 0.71e-3;          % Haline coefficient (1/psu)
N2      = g/rho_ref(2)*(rho_ref(1)-rho_ref(2))/H1; % Buoyancy frequency squared
Sref    = 21;               % Bottom haline reference (psu)
u       = 0.01 * RPS2ms;    % Mean current conversion from RPS
ut      = 0.05 * RPS2ms;    % Tidal forcing conversion from RPS
omega   = 1/(10) * 2*pi;     % Forcing frequency conversion from period (s)

fprintf('Omega^2 = %.2f\tN^2 = %.2f\n',(omega-u-ut)^2,N2)

while 1
    if (omega-u-ut)^2>N2
        fprintf('Omega^2 (%.2f) > N^2 (%.2f)\n\n',(omega-u-ut)^2,N2)
        superbuoyant = input('This is superbuoyant, press enter to continue or enter a new omega^2: ');
        if isempty(superbuoyant)
            disp('Using superbuoyany regime.')
            break
        else
            omega = sqrt(superbuoyant);
            fprintf('Using omega^2 = %.2f \n',omega^2)
            break
        end
    else
        break
    end
end

f0      = 1e-4;
F0      = 1e-6;
F0_meanV= 2e-6;

% Hill settings
sep         = 0.15;         % Seperation between hill centers (m)
sep_array   = sep*[1];      % Array of hill spacings to produce
w0          = 1e-3;         % Hill width (play around with it)
h0          = 0.06;         % Hill height (m)

prompt = 'What sort of model is this (identifier)?: ';
id = input(prompt,'s');

if isempty(id)
   id = ''; 
else
    id = strcat('_',id);
end

run hillCode