function allGCsres=readNLSAFile(dir,psinum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Ghoncheh Mashayekhi, 2019
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for GCi=1:47
    if psinum(GCi,1)~=0
    File =[dir,'/NLSA/NLSA_prD',num2str(GCi),'_psi_',num2str(psinum(GCi,1)),'.mat'];
    clear psirec tau
    
    load(File,'psirec','tau')
    allGCsres{1,GCi}=psirec;
    allGCsres{2,GCi}=tau;
    end
end

