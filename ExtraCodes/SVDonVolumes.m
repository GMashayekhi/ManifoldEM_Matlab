function SVDonVolumes(Dir,nClass,dim,inputdataformat,outputdataformat, visual)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020 UWM ManifoldEM team
%
% Initially developed by Ali Dashti 2014
% Revised by Ghoncheh Mashayekhi 2017
%
% inDirFile: the directory where the files are located 
% nClass: number of bins
% dim: dimension of the volumes, in RyR: 336
% dataformatinput/output=1 is for Spider input/output
% dataformtainput/output=2 is mrc input/outttput
% if visual is set to 1 would represent the plots relateddddd to SVD
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
topoNum = 8;
for i = [1:nClass]
    
    datafile = sprintf([Dir,'norm_psi_Class50_%02d.spi'],i);
    switch  inputdataformat
        case 1
            a = readSPIDERfile(datafile);
        case 2
            
            a = ReadMRC(datafile);
        otherwise
            disp('unknow data format')
            return
    end
    
    b(:,i) = a(:);
end


[U,S,V]=svdRF(double(b));
sdiag = diag(S);
%save([outDirFile,'choronos.mat'],'S','V','-v7.3');

if visual
    figure
    plot(sdiag,':*');
end

V = V';
s=0;
if visual
    figure('color',[1 1 1]);
    for i=1:topoNum
        s=s+1;
        subplot(2,ceil(topoNum/2),s);
        plot(V(i,1:end) , '-.b', 'MarkerSize',2 );
        ylabel(['\fontsize{12}V_{',int2str(i),'}']);
        xlabel(['\fontsize{12} data index']);
    end
end

V =V';



i1 = 1;
i2 = 2;

s=0;
Npixel = dim*dim*dim;
ConOrder = 1;
for ii=1:topoNum  % # of topos considered
    s=s+1;
    Topo = Inf(Npixel,ConOrder);
    for k=1:ConOrder
        Topo(:,k) = U( (k-1)*Npixel+1:k*Npixel , ii );
    end
    Topo_mean(:,ii) = mean(Topo,2);
end

Topo_mean = reshape(Topo_mean,dim,dim,dim,topoNum);


ConImgT = zeros(max(size(U)),nClass);
for i =[i1:i2]
    ConImgT = ConImgT+U(:,i) *(sdiag(i)* V(:,i)');
    i
end



ConImgT = ConImgT(:);
ConImgT = reshape(ConImgT,dim,dim,dim,nClass);

for i = 1:nClass
    switch  outputdataformat
        case 1
            datafile = [Dir,'SVD_',int2str(i),'.spi'];
            writeSPIDERfile(datafile,ConImgT(:,:,:,i));
        case 2
            f=WriteMRCHeader(ConImgT(:,:,:,i),1,[Dir,'SVD_',int2str(i),'.mrc']);
            fwrite(f,permute(ConImgT(:,:,:,i),[2 1 3]),'float32');
        otherwise
            disp('unknow data format')
            return
    end
    if i<topoNum
        switch  outputdataformat
            case 1
                datafile = [Dir,'_',int2str(i),'Topo.spi'];
                writeSPIDERfile(datafile,Topo_mean(:,:,:,i));
            case 2
                f=WriteMRCHeader(Topo_mean(:,:,:,i),1,[Dir,'_',int2str(i),'Topo.mrc']);
                fwrite(f,permute(Topo_mean(:,:,:,i),[2 1 3]),'float32');
            otherwise
                disp('unknow data format')
                return
        end
    end
    
end
end
