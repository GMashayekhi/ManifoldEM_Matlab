function y = ctemh_cryoFrank(k,params)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Peter Schwander 2010
   
% from Kirkland, adapted for cryo (EMAN1)
% Version V 1.1
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    %
    % Here, the damping envelope is characterized by a single parameter B 
    % see J. Frank
    % params(1)   Cs in mm
    % params(2)   df in Angstrom, a positive value is underfocus
    % params(3)   Electron energy in keV
    % params(4)   B in A-2

    % Note: we assume |k| = s

    Cs = params(1)*1.0e7;
    df = params(2);
    kev = params(3);
    B = params(4);
    mo = 511.0;
    hc = 12.3986;
    wav = (2*mo)+kev;
    wav = hc/sqrt(wav*kev);
    w1 = pi*Cs*wav*wav*wav;
    w2 = pi*wav*df;
    k2 = k.*k;
    %wi = exp(-2*B*k2); % B. Sander et al. / Journal of Structural Biology 142 (2003) 392?401, CHECKCHECK
    sigm = B/sqrt(2*log(2)); % B is Gaussian Env. Halfwidth
    %sigm = B/2;
    wi = exp(-k2/(2*sigm^2));
    wr = (0.5*w1.*k2-w2).*k2; % gam = (pi/2)Cs lam^3 k^4 - pi lam df k^2 

    y = (sin(wr)-0.1*cos(wr)).*wi;

end