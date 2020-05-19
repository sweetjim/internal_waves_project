%% Write data file
% Data file
if isfile('data')
    delete data
end

%     copyfile data_blank data
fid = fopen('data_blank');
txt = textscan(fid,'%s','delimiter','\n');
fclose(fid);
% Re-write the relevant bits of the file

txt{1}{20} = strrep('f0=1.0E-4','1.0E-4',...
    strcat(num2str(f0),','));
txt{1}{25} = strrep('rhoConst=1026.5','1026.5',...
    strcat(num2str(rho_ref(1)),','));
txt{1}{26} = strrep('rhoNil=1026.5','1026.5',...
    strcat(num2str(rho_ref(1)),','));
txt{1}{36} = strrep('tidalForcingU=1.0E-6','1.0E-6',...
    strcat(num2str(ut*1e-3),','));
txt{1}{38} = strrep('tidalFreq=1.41E-4','1.41E-4',...
    strcat(num2str(omega0),','));
txt{1}{40} = strrep('meanForcingV=2E-6','2E-6',...
    strcat(num2str(u0*1e-3),','));
txt{1}{68} = strrep('dYspacing=.001','.001',...
    strcat(num2str(res*1e-1),','));
txt{1}{69} = strrep( "delXfile = 'dx.field'","'dx.field'",...
    strcat("'",dx_phrase,"',"));
txt{1}{76} = strrep("bathyFile='double_hill1_spaced.field'","'double_hill1_spaced.field'",...
    strcat("'",hill_phrase,"',"));
txt{1}{77} = strrep("hydrogSaltFile = 'Sinit_N_7e1.field'","'Sinit_N_7e1.field'",...
    strcat("'",S_phrase,"',"));
txt{1}{78} = strrep("uVelInitFile='v0.field'","'v0.field'",...
    strcat("'",v0_phrase,"',"));

fid = fopen('data','w');
for j=1:length(txt{1})
    fprintf(fid,'%s\n',txt{1}{j});
end
fclose(fid);

%% Config file


fid = fopen('config_blank.yaml');
txt = textscan(fid,'%s','delimiter','\n');
fclose(fid);

txt{1}{7} = strrep('jobname: lm','lm',project_phrase);

% IMPORTANT: field files will need to go into the following directory
txt{1}{18} = strrep(txt{1}{18},'/scratch/nm03/js8285/mitgcm_input/',...
    strcat(input_location,...
    field_location,'/',project_phrase,'/'));
txt{1}{24} = ' nodesize: 48';
txt{1}{26} = ' #manifest';
txt{1}{27} = ' #fullhash: binhash';
fid = fopen('config.yaml','w');

for j=1:length(txt{1})
    fprintf(fid,'%s\n',txt{1}{j});
end

fclose(fid);



