function [results, iter] = distribute3Sphere(numPts)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Russell Fung February 2009
%
% Distributes numPts points roughly uniformly on a unit 3-sphere and
% returns the coordinates in results. Number of iterations required is
% returned in iter.
% 
% Algorithm adapted from L. Lovisolo and E.A.B. da Silva, Uniform
% distribution of points on a hyper-sphere with applications to vector
% bit-plane encoding, IEE Proc.-Vis. Image Signal Process., Vol. 148, No.
% 3, June 2001
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maxIter = 100;

K = numPts;

A3 = 4*pi; % surface area of a unit 3-sphere
delta = exp(log(A3/K)/2);

results = zeros(2*K,3); % algorithm sometimes returns more/ less points
iter = 0;
id = 0;

while ~(id==K)&(iter<maxIter)
    iter = iter+1;
    id = 0;
    dw1 = delta;
    for w1 = 0.5*dw1:dw1:pi
        cw1 = cos(w1);
        sw1 = sin(w1);
        x1 = cw1;
        dw2 = dw1/sw1;
        for w2 = 0.5*dw2:dw2:2*pi
            cw2 = cos(w2);
            sw2 = sin(w2);
            x2 = sw1*cw2;
            x3 = sw1*sw2;
            id = id+1;
            results(id,:) = [x1 x2 x3];
        end
    end
    delta = delta*exp(log(id/K)/2);
end
results = results(1:K,:);