function manifoldTrimming(distFile,posPath,tune,rad,dir,outFile)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team
% Developed by Ali Dashti 2017,
%
% Does the embedding (with sigma equal to tune*sigma_optimum) and outliers
% removal repeatedly until all the points in the first three Eigenfunctions
% llie inside a hypersphere with radian equal to rad
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(distFile,'D')
nS= size(D,2);

if posPath ==0
    posPath = 1:nS;
end

D = D(posPath,posPath);
nS= size(D,2);

%[lambda1,psi1,sigma1,mu1] = DMembedding(D,k,tune,60000);
[lambda1,psi1,sigma1,mu1] = DMembedding(D,tune);
%  lambda1= lambda1(lambda1>0);


plotNum = 1;

psinum1 = plotNum;
psinum2 = plotNum+1;
psinum3 = plotNum+2;

psiDist = sqrt(psi1(:,psinum1).^2 + psi1(:,psinum2).^2 + psi1(:,psinum3).^2);

posPath1 = find(psiDist<rad);


while (length(posPath1)<nS)
    
    nS = length(posPath1);
    
    
    D1 = D(posPath1,posPath1);
    
    % k1 = min(k,size(D1,2));
    [lambda1,psi1,sigma1,mu1] = DMembedding(D1,tune);
    %  lambda1 = lambda1(lambda1>0);
    
    psiDist = sqrt(psi1(:,psinum1).^2 + psi1(:,psinum2).^2 + psi1(:,psinum3).^2);
    posPathInt = find(psiDist<rad);
    
    posPath1 = posPath1(posPathInt);
    
end

posPath = posPath(posPath1);
if exist(dir,'file')==0
    mkdir(dir)
    fileattrib(dir,'+w','o')
end
save([dir,outFile],'psi1','lambda1','sigma1','posPath');

end
        