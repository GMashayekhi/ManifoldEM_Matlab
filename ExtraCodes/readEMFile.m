function allGCsres=readEMFile(dir,np)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Ghoncheh Mashayekhi, 2019
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for GCi=1:np
    File =[dir,'/EM/EM_prD',num2str(GCi),'.mat'];
    clear psi1 posPath
    
    load(File,'psi1','posPath')
    allGCsres{1,GCi}=psi1;
    allGCsres{2,GCi}=posPath;
end

