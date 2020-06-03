function [w,w_up,w_down,w_lee,p,anom] = computeSolution(H,z,x,h,N,u,ut,omega,f,alpha0,n)
    % complex numbers
    i=complex(0,1);

    % topo transform
    [hhat,k]=ffts(h,x(2)-x(1),2, length(x));

    % grids
    [K,Z,nn]=ndgrid(k,z,n);
    [Hhat,~,~]=ndgrid(hhat,z,n);

    % downstream waves i.e. -n*omega+k*u  (n<=0)
    OMEGA0=-nn*omega+K*u;
    % the topo boundary condition
    w0=Hhat.*i.*OMEGA0.*besselj(-nn,(K*ut)/omega);
    % the vertical wavenumber
    m0=real(abs(K).*sqrt((N.^2-(OMEGA0).^2)./(OMEGA0.^2-f.^2)).*sign(OMEGA0));
    % make zero evanescent solutions
    m0((N.^2-OMEGA0.^2)./(OMEGA0.^2-f.^2)<0)=0;
    % the decay rate
    gamma0=real(alpha0.*m0.*OMEGA0.*(2*N^2-OMEGA0.^2-f^2)./(N^2-OMEGA0.^2)./(f^2-OMEGA0.^2)/2);


    % upstream waves  i.e. n*omega+k*u  (n>=0)
    OMEGA1=nn*omega+K*u;
    % the topo boundary condition
    w1=Hhat.*i.*OMEGA1.*besselj(nn,(K*ut)/omega);
    % the vertical wavenumber
    m1=real(abs(K).*sqrt((N.^2-OMEGA1.^2)./(OMEGA1.^2-f.^2)).*sign(OMEGA1));
    % make zero evanescent solutions
    m0((N.^2-OMEGA1.^2)./(OMEGA1.^2-f.^2)<0)=0;
    % the decay rate
    gamma1=real(alpha0.*m1.*OMEGA1.*(2*N^2-OMEGA1.^2-f^2)./(N^2-OMEGA1.^2)./(f^2-OMEGA1.^2)/2);

    % depth dependence of flow (what=1 at Z=-H and what=0 at Z=0)
    what0=(exp(-i*(m0.*Z)-gamma0.*(Z-H))-exp(i*(m0.*Z)+gamma0.*(Z+H)))./(exp(i*m0.*H+2*gamma0.*H)-exp(-i*m0.*H));
    what1=(exp(-i*(m1.*Z)-gamma1.*(Z-H))-exp(i*(m1.*Z)+gamma1.*(Z+H)))./(exp(i*m1.*H+2*gamma1.*H)-exp(-i*m1.*H));
    what1(isnan(what1))=0;
    what0(isnan(what0))=0;

    % sum the upstream (n<=0) and  downstream (n=>0) to give net
    what=(w0.*what0+w1.*what1);
    % correct n=0 harmonic component - it is a duplicated when summing n>=0 and n<=0
    what(nn==0)=w0(nn==0).*what0(nn==0);
    what(isnan(what))=0;
    % calculate IFFT
    w=iffts(what,length(x),1,length(x));

    % tidal lee
    mask0=zeros(size(K));
    mask0((K*u)>(nn*omega+f))=1;
    what_lee=mask0.*w0.*what0;
    what_lee(isnan(what_lee))=0;
    w_lee=iffts(what_lee,length(x),1,length(x));

    % downstream beam
    what_down=(1-mask0).*w0.*what0;
    what_down(isnan(what_down))=0;
    what_down(nn==0)=0;
    w_down=iffts(what_down,length(x),1,length(x));

    % upstream beam
    what_up=w1.*what1;
    what_up(isnan(what_up))=0;
    what_up(nn==0)=0;
    w_up=iffts(what_up,length(x),1,length(x));

    phat0=-(exp(-1i*(m0.*Z)-gamma0.*(Z-H))+exp(1i*(m0.*Z)+gamma0.*(Z+H)))./(exp(1i*m0.*H+2*gamma0.*H)-exp(-1i*m0.*H))./(m0).*(N^2-OMEGA0.^2)./(OMEGA0);
    phat1=-(exp(-1i*(m1.*Z)-gamma1.*(Z-H))+exp(1i*(m1.*Z)+gamma1.*(Z+H)))./(exp(1i*m1.*H+2*gamma1.*H)-exp(-1i*m1.*H))./(m1).*(N^2-OMEGA1.^2)./(OMEGA1);
    phat1(isnan(phat1))=0;
    phat1(isinf(abs(phat1)))=0;
    phat0(isnan(phat0))=0;
    phat0(isinf(abs(phat0)))=0;

    phat=(w0.*phat0+w1.*phat1);
    phat(nn==0)=w0(nn==0).*phat0(nn==0);
    phat(isnan(phat))=0;
    phat(isinf(abs(phat)))=0;
    p=iffts(phat,length(x),1,length(x));
    
    %% 

    b0=w0.*N^2./(i.*(OMEGA0));          % Buoyancy (continuity eq in fourier space)
    b1=w1.*N^2./(i.*(OMEGA1));
    bhat=(b0.*what0+b1.*what1);
    % bhat(isnan(bhat))=0;

    bhat(nn==0)=bhat(nn==0)/2; % remove duplicate n=zeros

    % bhat(nn==0)=w0(nn==0).*bhat0(nn==0);

    bhat(isnan(bhat))=0;
    bhat(isinf(abs(bhat)))=0;

    b=iffts(bhat,length(x),1,length(x));
    anom=b/9.81*1000;

end