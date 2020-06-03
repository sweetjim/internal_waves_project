%% Run model
rhobot = 1018;

H   = -depth;       
L   = 5.2/2;        % Half tank length

z   = linspace(-H,0,200);
x   = linspace(-L,L,1000);

h1  = 0.06;     h2  = h1;
w1  = 40;       w2  = w1;
xi  = 0;        xf  = width;

func= @(h,w,x0) h*exp(-(w.*(x-x0)).^2);
h   = func(h1,w1,x1)+func(h2,w2,x2);

nf = 3;             % Number of harmonics to compute
n = 0:nf;
f = 0; 
alpha0=0.005*2;

[w,w_up,w_down,w_lee,p,anom] = computeSolution(H,z,x,h,N,u,ut,omega,f,alpha0,n);