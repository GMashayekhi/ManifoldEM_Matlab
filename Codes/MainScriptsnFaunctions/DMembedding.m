function [eigVal,psi,sigma,mu] = DMembedding(D,tune)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Adopted from Giannakis, modifieid by Ali Dashti, 2017, Ghoncheh Mashayekhi
% 2020
% 
% Does the embedding
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

D( D< 1E-6)=0;
a0 = 1*(rand(4,1)-.5);
logEps = -150:1:150;
a = findOptSigma(sqrt(D),logEps,a0);

sigma      = tune*sqrt(2*exp(-a(2)/a(1))); % Gaussian Kernel width (=1 for autotuning)

K = exp(-D/sigma/sigma);
alpha = 1;
nEigs =  50;

% first round of normalization
W = bsxfun(@rdivide,K,sum(K,2).^alpha);
W = bsxfun(@rdivide,W,sum(K,1).^alpha);
DD = sum(W);
sqrtD = sqrt(DD);
invSqrtD = 1./sqrtD;
% second round of normalization
L = bsxfun(@times,W,invSqrtD);
L = bsxfun(@times,L,invSqrtD');
% calculate eigenvectors and eigenvalues of L, and EOFs

L = abs( L + L' ) / 2; % TO DO: WHY? iron out numerical wrinkles

%L = K;

%[eigVec,eigVal] = eig(L);
opts.maxit = 200;
[eigVec,eigVal] = eigs(L,nEigs+1,'lm',opts);

%    [lambda, ix] = sort( lambda, 'descend' );
%
[eigVal,sortOrder] = sort(diag(eigVal),'descend');
eigVec = eigVec(:,sortOrder);
psi = bsxfun(@rdivide,eigVec,eigVec(:,1));
mu = eigVec(:,1).*eigVec(:,1);

training_set_col_sum = sum(K,1);
training_set_invSqrtD = invSqrtD;

psi = psi(:,2:end);

L_estimate = max(diag(L));

end