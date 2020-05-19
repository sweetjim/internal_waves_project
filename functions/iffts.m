%% Inverse frequency Fourier transform
function [y]=iffts(Fk,nx,dim,NFFT,ds)

if(dim==2)
    Fk=permute(Fk,[2,1,3]);
elseif(dim==3)
    Fk=permute(Fk,[3,2,1]);
end
nk=size(Fk,1);

% If Fk/k have been trimmed relative to initial profile, then NFFT
% may not be related to nk.
if(nargin<4)
    NFFT=(nk-1)*2;
else
    % zero pad
    nk2=floor(NFFT/2+1);
    Fk=cat(1,Fk,zeros(nk2-nk,size(Fk,2),size(Fk,3)));
end

% add back negative frequencies
% make single sided
if( nargin<5 || ds==0 )
    Fk2=Fk(2:end-1,:,:);
    temp=cat(1,Fk,flipdim(conj(Fk2),1));
else
    temp=Fk;
end

temp=temp/2*NFFT;

% invert transform
if( nargin<5 || ds==0 )
    y=ifft(temp,NFFT,1,'symmetric');
else
    y=ifft(temp,NFFT,1);
end

% trim
y=y(1:nx,:,:);

if(dim==2)
    y=permute(y,[2,1,3]);
elseif(dim==3)
    y=permute(y,[3,2,1]);
end


