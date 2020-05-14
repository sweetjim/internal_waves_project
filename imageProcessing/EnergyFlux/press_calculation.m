function p = press_calculation(xGrid,zGrid,rhoPertGrid,N0,modeStart,modeEnd,CGS)


if CGS == 1
    g = 980;
else
    g = 9.8;
end    
    
nSlices = size(rhoPertGrid,3);

h_bar = waitbar(0,'Calculating Pressure: 0%');

for j = 1:nSlices

    rho = rhoPertGrid(:,:,j);

    dz = zGrid(2,2)-zGrid(1,1);

    [~,dRho_dZ] = gradient(rho,dz);

    a = N0^2/2/g;

    %% Set domain parameters

    % Set minimium points to zero
    xGrid0 = xGrid - min(xGrid(:));
    yGrid0 = zGrid - min(zGrid(:));

    % Domain length
    l = max(xGrid0(:));

    % Domain height
    h = max(yGrid0(:));

    %% Create vertical coordinates z and z'

    z = yGrid0(:,1);
    z_prime = z;

    [z,z_prime] = meshgrid(z,z_prime);

    %% Calculate the source term

    f_source = (N0^2.*rho + g*dRho_dZ).*exp(a*yGrid0);
    f = fft(f_source,[],2)/(size(f_source,2))*2;
    
    if isempty(modeStart) == 1
        modeStart = 1;
    end
    
    fProfile = mean(abs(f));
    if isempty(modeEnd) == 1
        [mx, mi] = max(fProfile);
        possibleEndIndex = find(fProfile < mx*.01);
        f_end = find(possibleEndIndex > mi, 1, 'first');
        modeEnd = possibleEndIndex(f_end);
        if isempty(modeEnd)
            modeEnd = floor(size(f,2)/2);
        end
    end

    Fki_store_fast = -imag(f(:,2:modeEnd+1));
    Fkr_store_fast = real(f(:,2:modeEnd+1));


    %% Create base pressure

    pGrid_gf = 0*xGrid0;

    %% Set mode number

    
    modeCount = modeEnd-modeStart+1;

    for n = modeStart:modeEnd;

        waitbar((n-modeStart+1 + modeCount*(j-1))/(nSlices*modeCount),h_bar,sprintf('Calculating Pressure: %.2f%%',(n-modeStart+1 + modeCount*(j-1))/(nSlices*modeCount)*100))

    %% Create mode specific parameters: kx, kappa, gamma

    kx = 2*pi*n/l;
    kappa = sqrt(kx^2 + N0^4/4/g^2);
    gamma = -4*kx^2*kappa*sinh(kappa*h);

    %% Calculate G_k pos = z>z', neg = z<z'

    Gk_pos_term1 = (kappa + a)^2 * exp(kappa * (z+z_prime-h));
    Gk_neg_term1 = (kappa + a)^2 * exp(kappa * (z_prime+z-h));

    Gk_pos_term2 = 2*kx^2 * cosh( kappa * (z-z_prime-h));
    Gk_neg_term2 = 2*kx^2 * cosh( kappa * (z_prime-z-h));

    Gk_pos_term3 = (kappa - a)^2 * exp(kappa * (-(z+z_prime)+h));
    Gk_neg_term3 = (kappa - a)^2 * exp(kappa * (-(z_prime+z)+h));

    Gk_pos = (Gk_pos_term1 + Gk_pos_term2 + Gk_pos_term3)/gamma;
    Gk_neg = (Gk_neg_term1 + Gk_neg_term2 + Gk_neg_term3)/gamma;

    Gk = Gk_pos;

    f = find(z<z_prime);

    Gk(f) = Gk_neg(f);

    %% Calculate the fourier components for the given wave number

    % [Fkr, Fki] = fourier_code(kx, f_source, xGrid0(1,:));
    % Fkr_store(:,n) = Fkr;
    % Fki_store(:,n) = Fki;

    % 
    Fkr = Fkr_store_fast(:,n);
    Fki = Fki_store_fast(:,n);


    %% Calculate the convolution value (G_k * F)

    Gkintegrandr = Gk.*(ones(length(Fkr),1)*Fkr');
    Gkintegrandi = Gk.*(ones(length(Fki),1)*Fki');


    term1_fast = trapz(yGrid0(:,1),Gkintegrandr')'*cos(kx*xGrid0(1,:));
    term2_fast = trapz(yGrid0(:,1),Gkintegrandi')'*sin(kx*xGrid0(1,:));

    deltaP_gf = -exp(-N0^2/2/g*yGrid0).*(term1_fast+term2_fast);

    pGrid_gf = pGrid_gf + deltaP_gf;

    end


    p(:,:,j) = pGrid_gf;

end

    close(h_bar);
    
end