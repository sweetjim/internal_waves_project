function [Fk, k]=ffts(y,dx,dim,NFFT,ds)

n=size(y,dim);                  % Desired axis length

if(nargin<4)
    NFFT = floor((n+1)/2)*2;    % N-point: number of iterations
end
Fk  =   fft(y,NFFT,dim)*2/NFFT; % Transform on wavevector 'k'
nk  =   floor(NFFT/2+1);        % Midpoint of iterations (relflection pt)
kmax=   2*pi/dx;                % Discrete sample size in wavespace
k   =   kmax*linspace(0,1,NFFT);% Wavevector space

% make single sided
if( nargin<5 || ds==0 )
    k=k(1:nk);                  % Rescale to reflection pt

    if(dim==1)                  % Generate transform for k wavenumber
        Fk = Fk(1:nk,:,:);
    elseif(dim==2)              % Generate transform for m wavenumber
        Fk = Fk(:,1:nk,:);      
    elseif(dim==3)              % Generate transform for l wavenumber
        Fk = Fk(:,:,1:nk);      
    end

end
