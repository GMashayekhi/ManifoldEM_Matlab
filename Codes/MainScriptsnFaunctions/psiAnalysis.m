function res = psiAnalysis(inputIMG,inputPsi,dir,output,ConCoef,psinums,isSel,mask)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team
% Developed by Ali Dashti 2014, modified by Ghoncheh Mashayekhi 2020
% Use NLSA* to extract the motions along NoE first Eigenfunctions
%
% *Giannakis, D. & Majda, A.J. Nonlinear Laplacian spectral analysis for
% time series with intermittency and low-frequency variability. Proc Natl
%  Acad Sci U S A 109, 2222-2227 (2012).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(inputIMG);
msk=mask(:);

load(inputPsi);
psi = psi1;

D = D(posPath,posPath);
nS = length(posPath);
ConOrder =floor(nS/ConCoef);


for psinum = psinums
    
    [psiSorted,psiSortedInd] = sort(psi(:,psinum));
    
    posPsi1 = psiSortedInd;
    %     psi1 = psi(posPsi1,:);
    %     CC = 1:max(size(psi1));
    
    
    DD = D(posPsi1,posPsi1);
    num = size(DD,2);
    
    k = num-ConOrder;
    tune = 3;
    
    
    ConD = zeros(num-ConOrder,num-ConOrder);
    for iii=1:num-ConOrder
        for ii = 1:num-ConOrder
            for ConNum = 0:(ConOrder-1)
                Ind1 = iii+ConNum;
                Ind2 = ii+ConNum;
                
                ConD(iii,ii) = ConD(iii,ii)+DD(Ind1,Ind2);
            end
        end
        %    iii
    end
    
    [lambdaC,psiC,sigmaC,mu] = DMembedding(ConD,tune);
    lambdaC = lambdaC(lambdaC>0);
    psiC1 = psiC;
    
    
    ys = reshape(imgAll,size(imgAll,1)*size(imgAll,2),size(imgAll,3));
    
    IMG1 = ys(:,posPath(posPsi1));
    
    sigma = sigmaC;
    ell = 7;
    N = size(psiC,1);
    psiC = [ones(N,1) psiC(:,1:ell)];
    %mu = mu.*mu;
    mu_psi = bsxfun(@times,mu,psiC);
    
    A = zeros(ConOrder*max(size(IMG1)),ell+1);%num-ConOrder);
    
    tmp = zeros(max(size(IMG1)),num-ConOrder);
    
    
    
    %Wiener filtering
    dim = sqrt(size(IMG1,1));
    SNR = 5;
    CTF1 = CTF(:,posPath(posPsi1));
    wiener_dom = zeros(dim*dim,num-ConOrder);
    for i =1:num-ConOrder
        for ii = 1:ConOrder
            ind_CTF =  ConOrder - ii +1 + i-1;
            wiener_dom(:,i) = wiener_dom(:,i)+CTF1(:,ind_CTF).^2;
        end
        
    end
    
    wiener_dom = wiener_dom+1/SNR;
    
    for ii = 1:ConOrder
        for i = 1:num-ConOrder
            ind1 = 1;
            ind2 = max(size(IMG1));
            ind3 = ConOrder - ii +1 + i-1;
            img = IMG1(:,ind3);
            img_f = fft2(reshape(img,dim,dim));
            CTF_i = reshape(CTF1(:,ind3),dim,dim);
            wiener_dom_i = reshape(wiener_dom(:,i),dim,dim);
            img_f_wiener = img_f.*(CTF_i ./wiener_dom_i);
            
            tmp(ind1:ind2,i) = reshape(ifft2(img_f_wiener),dim*dim,1).*msk; %% mask should applied here
            
        end
        ind4 = 1 + (ii-1)*max(size(IMG1));
        ind5 = ii*max(size(IMG1));
        A(ind4:ind5,:) = tmp*mu_psi;
        
        
    end
    
    TF = isreal(A);
    if TF~=1
        error('A is an imaginary matrix!');
    end
    
    [U,S,V]=svdRF(A);
    VX = V'*psiC';
    
    sdiag = diag(S);
    
    
    Npixel      = max(size(IMG1));
    Dim         = sqrt(Npixel);
    
    
    s=0;
    for ii=1:ell+1  % # of topos considered
        s=s+1;
        Topo = Inf(Npixel,ConOrder);
        for k=1:ConOrder
            Topo(:,k) = U( (k-1)*Npixel+1:k*Npixel , ii );
        end
        Topo_mean(:,ii) = mean(Topo,2);
    end
    
    
    
    clear A;clear tmp;
    %Unwrapping
    %%%
    siz=min(floor(size(VX,2)/100),10);
    kk=1;
    for mm=1:100
        if mm*siz <= size(VX,2)
            VarM2(kk)=var(VX(2,(mm-1)*siz+1:mm*siz));
            VarM3(kk)=var(VX(3,(mm-1)*siz+1:mm*siz));
            VarM4(kk)=var(VX(4,(mm-1)*siz+1:mm*siz));
            VarM5(kk)=var(VX(5,(mm-1)*siz+1:mm*siz));
            VarM6(kk)=var(VX(6,(mm-1)*siz+1:mm*siz));
            %             VarM7(kk)=var(VX(7,(mm-1)*siz+1:mm*siz));
            %             VarM8(kk)=var(VX(8,(mm-1)*siz+1:mm*siz));
            kk=kk+1;
        end
    end
    
    VarM=[mean(VarM2),mean(VarM3),mean(VarM4),mean(VarM5),mean(VarM6)];%,mean(VarM7),mean(VarM8)];
    [varM,varIn]=min(VarM);
    varIn=varIn+1;
    %%%
    i2 = varIn;
    % i2 = 3;
    i1 = 1;
    
    ConImgT = zeros(max(size(U)),ell+1);
    for i =[i1,i2]
        %ConImgT = U(:,i) *(sdiag(i)* V(:,i)')*psiC';
        ConImgT = ConImgT+U(:,i) *(sdiag(i)* V(:,i)');
    end
    
    recNum = ConOrder;
    tmp = zeros(max(size(IMG1)),num-ConOrder);
    IMGT = zeros(max(size(IMG1)),num-ConOrder-recNum);
    for i = 1:recNum
        ind1 = (i-1)*max(size(IMG1)) +1;
        ind2 = i*max(size(IMG1));
        tmp = ConImgT(ind1:ind2,:)*psiC';
        for ii = 1:num-ConOrder-recNum
            ind3 = i+ii-1;
            IMGT(:,ii) = IMGT(:,ii)+tmp(:,ind3);
        end
    end
    
    
    % %
    % %fitting
    nSrecon = min(size(IMGT));
    dim = max(size(IMGT));
    Drecon = L2_distance(IMGT,IMGT,1);
    
    
    k =nSrecon;
    tune = 3;
    
    
    [lambda,psirec,sigma] = DMembedding((Drecon.^2),tune);
    lambda = lambda(lambda>0);
    
    [a,b,tau] = fit_1D_open_manifold_3D(psirec);
    
    [at,bt]=sort(tau,'ascend');
    if bt(end)<bt(1)
        tau = 1- tau;
    end
    
    numclass = min(50,floor(nSrecon/2));
    
    tau = (tau-min(tau))./(max(tau)-min(tau));
    
    if isSel.val==1
        if isSel.sense == -1
            tau = 1-tau;
        end
    end
    
    tauinds = [];
    i1 = 1;i2  = size(IMGT,1);
    
    IMG1 = zeros(i2,numclass);
    for i = 1:numclass
        ind1 = (i-1)/numclass;
        ind2 = i/numclass;
        if (i ==numclass)
            tauind = find((tau>=ind1) & (tau<=ind2));
        else
            tauind = find((tau>=ind1) & (tau<ind2));
        end
        while (isempty(tauind))
            sc = 1/(numclass*2);
            ind1 = ind1 - sc*ind1;
            ind2 = ind2+sc*ind2;
            tauind = find((tau>=ind1)&(tau<ind2));
        end
        
        IMG1(i1:i2,i) = IMGT(:,tauind(1));
        tauinds(i) = tauind(1);
    end
    if exist(dir,'file')==0
            mkdir([dir,'/NLSA']);
            fileattrib([dir,'/NLSA'],'+w','o');
    end
        
    if isSel.val==1
        
        fileNam  =[dir,output,'_psi_',int2str(psinum),'.mat' ];
        save(fileNam,'IMG1','IMGT','posPsi1','psirec','tau','Topo_mean','tauinds','-v7.3');
    else
        
        
        fileNam  =[dir,output,'_psi_',int2str(psinum),'.mat' ];
        save(fileNam,'IMG1','psirec','tau','Topo_mean','-v7.3');
    end
    
        
end
res = 'ok';


end