%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Ghoncheh Mashayekhi, 2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

load(['Data/S2tessellationResult.mat'],'CG')
for i=[1:50]
    ind=CG{i};
    for j=1:length(ind)
        if ind(j)>17725
            ind(j)=ind(j)-17725;
        end
        if inds(ind(j))<=862462
            imgLabels(j)=0;
        else
            imgLabels(j)=1;
        end
    end
%     load(['Dist/IMGs_prD',num2str(i),'.mat'],'imgAll','CTF')
    load(['EM/EM_prD',num2str(i),'.mat'],'psi1','posPath')
    [posPath] = removeClusterManual(psi1,posPath,imgLabels,imgAllIntensity,i);
    save(['EM/EM_prD',num2str(i),'.mat'],'posPath','-append') 
    CGnew{i}=ind(posPath);
    i
end

