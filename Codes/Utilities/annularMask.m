function mask = annularMask(a,b,N,M)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Russell Fung 2007, modified by Peter Schwander December 2008
%
% mask = annularMask(a,b,N,M)
% 
% returns a N x M matrix with an annular (donut) mask of inner
% radius a and outer radius b. Pixels outside the donut or inside the hole
% are filled with 0, and the rest with 1.
% 
% The circles with radii a and b are centered on pixel (N/2,M/2).
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
aSq = a*a;
bSq = b*b;
mask = zeros(N,M);
for xx=1:N
    xDist = xx-N/2;
    xDistSq = xDist*xDist;
    for yy=1:M
        yDist = yy-M/2;
        yDistSq = yDist*yDist;
        rSq = xDistSq+yDistSq;
        mask(xx,yy) = (rSq>=aSq)&(rSq<bSq);
    end
end