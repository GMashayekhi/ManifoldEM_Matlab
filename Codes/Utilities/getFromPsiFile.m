function [variablesOut] = getFromPsiFile(variablesIn,NoE,inDir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed  by Ali Dashti, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    for psinum = 1:NoE
       
        outFile  =[inDir,'_psi_',int2str(psinum),'.mat' ];
            
        variables = [];
        for i = 1:length(variablesIn)
            
            variables{i} = load(outFile,variablesIn{i});
        end

      variablesOut{psinum} =variables;

    end
end