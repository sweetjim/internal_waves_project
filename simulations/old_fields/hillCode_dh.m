%% Topography and stratification code
% Simple code that exports different .field files for usage in gadi. 

ieee    = 'b' ; 
accuracy= 'real*8' ; 
g       = 9.81; % m/s2
alphaT  = 2e-4; % 1/T
N2      = 3e-6; 

% grid size 
nx  = 1024; % pts
ny  = 1;    % pts
nz  = 300;  % pts
Lx  = 5;    % m
H1  = 0.3;  % m
z   = -linspace(0,H1,nz+1); 
z   = (z(1:end-1)+z(2:end))/2; 

% x   = (x(1:end-1)+x(2:end))/2; 


%% Draw a varying horizontal resolution that increases near the hills
x   = linspace(0,Lx,nx+1); 

n1  = 0:nx-1;
res = 0.01; % m
func    = @(x,x0,w0,h0) h0*exp(-(x-x0).^2/w0);
res_func = @(n1,nx,x0,x1) 1+tanh((n1-x0*nx)/x1);

sep     = 0.15;
pos     = (Lx/2+[sep,-sep]);
res_pos = 0.5+0.2*[ 0.7];
w0      = 4e-3;
h0      = H1;

res_space   = res_func(n1,nx,res_pos(1),100)-res_func(n1,nx,res_pos(2),100);
hill_space  = func(x,pos(1),w0,h0)+func(x,pos(2),w0,h0);

clf
yyaxis left
plot(x,hill_space)
ylim([0 1])
% xlim([2 3])


dx  = res+(1e-3-res)/2*res_space;
x   = cumsum(dx)/sum(dx)*Lx;
dx  = diff(x);
dx = [dx dx(end)];
x   = x(1:(nx));

yyaxis right
plot(x,dx)

%% 




hill_space      = hill_space-mean(hill_space); 
hill_space      = hill_space./rms(hill_space); 
hill_space      = hill_space-min(hill_space); 
H       = min(z); 
harray = [200 350 500 650]; 

for i=1:length(harray) 
    h   = H+hill_space*harray(i); % Scaling
    fid = fopen(sprintf( 'double_hill%i.field' ,harray(i)), 'w' ,ieee); fwrite(fid,h,accuracy); fclose(fid);
end 

plot(h)

%% 


fid = fopen( 'dx.field' , 'w' ,ieee); 
fwrite(fid,dx,accuracy); 
fclose(fid); 

% make uniform strat 
dTdz    = N2/(alphaT*g); 
[X,Z]   = ndgrid(x,z); % Change to S 
T       = dTdz*(Z+H1); % Isopyncals every ~4.5m
fid     = fopen( 'Tinit_N2_3e6.field' , 'w' ,ieee); % Change for S.field
fwrite(fid,T,accuracy); 
fclose(fid); 

% initial v, match mean forcing to impulse
[X,Z]   = ndgrid(x,z);

mean    = 0.01;
omega0  = 1.38889e-4;
f0      = 1e-4;
F0      = 1e-6;
u0      = omega0/(f0^2-omega0^2)*F0 + mean; 
fid     = fopen('v0.field','w',ieee); 
fwrite(fid,u0*ones(size(X)),accuracy); 
fclose(fid);

