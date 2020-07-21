function a = vNorm2(a)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020 UWM ManifoldEM team
% Developed by Peter Schwander 2010, and revised 2020
%
% normalizes the columns of a n x m matrix
%
% Depending on the dataset size and RAM of the device you might need to do
% this in batches
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%display(sprintf('variance normalize'));

a = bsxfun(@minus,a,mean(a)); % zero mean
a = bsxfun(@rdivide,a,sqrt(var(a))); % variance normalization

end