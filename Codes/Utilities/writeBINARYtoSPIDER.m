function res = writeBINARYtoSPIDER(nClass,nPix,dir,senses,psinums,pcase)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Ghoncheh Mashayekhi, 2017- 2020
% Adopted from the original codes developed by Ali Dashti 2014
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boundCond=0;
ConCoef=20;

if exist([dir,'/Dat'],'file')==0
    mkdir([dir,'/Dat'])
    fileattrib([dir,'/Dat'],'+w','o')
end

fil=[dir,'/Data/S2tessellationResult.mat'];
load(fil)
fil=[dir,'/Data/starFile.mat'];
load(fil,'q')

qq=q;
numimbin=zeros(1,50);
indsinbin=cell(1,50);
indsinbin(1,:)={0};
%

switch pcase
    case 1
        % Using IMGT
        for prD = 1:size(psinums,1)
            if psinums(prD,1)~=0
                
                clear IMGT tau q posPath ind psi1 IMG1 posPsi1
                
                ind=CG{1,prD};
                q=qq(:,ind);
                
                fileNam1  =[dir,'/NLSA/NLSA_prD',int2str(prD),'_psi_',num2str(psinums(prD,1)),'.mat'];
                load(fileNam1,'tau','IMGT','posPsi1');
                
                fileNam2  =[dir,'/EM/EM_prD',int2str(prD),'.mat'];
                load(fileNam2,'posPath');
                posPsi=posPath(posPsi1);
                
                conOrder=floor(length(ind(posPath))/ConCoef);
                
                q=q(:,posPsi);
                
                nS = size(q,2);
                if (boundCond ==1)
                    q = q(:,conOrder:nS);
                else
                    q = q(:,conOrder:nS-conOrder-1);
                end
                
                for bin = 1:50
                   
                    ind1 = (bin-1)/nClass;
                    ind2 = bin/nClass;
                    if (bin ==nClass)
                        tauind= find((tau>=ind1) & (tau<=ind2));
                    else
                        tauind= find((tau>=ind1) & (tau<ind2));
                    end
                    while (isempty(tauind))
                        sc = 1/(nClass*2);
                        ind1 = ind1 - sc*ind1;
                        ind2 = ind2+sc*ind2;
                        tauind = find((tau>=ind1)&(tau<ind2));
                    end
                    indsinbin{bin}=[indsinbin{bin};ind(posPsi(tauind))];
                    
                    
                    fileNam1 = [dir,'/Dat/NLSAImage','_',num2str(bin),'_of_',int2str(nClass),'.dat'];
                    fileNam2 = [dir,'/Dat/TauVals','_',num2str(bin),'_of_',int2str(nClass),'.dat'];
                    fileNam5 = [dir,'/Dat/qs','_',num2str(bin),'_of_',int2str(nClass),'.dat'];
                    
                    if bin==1
                        f1 = fopen(fileNam1);
                    else
                        f1 = fopen(fileNam1,'a');
                    end
                    fwrite(f1,IMGT(:,tauind),'float32');
                    fclose(f1);
                    
                    if bin==1
                        f2= fopen(fileNam2);
                    else
                        f2= fopen(fileNam2,'a');
                    end
                    fwrite(f2,tau(tauind),'float32'); %gm: it means for each bin of a single PD we would have different q and PD?!
                    fclose(f2);
                    
                    if bin==1
                        f5 = fopen(fileNam5);
                    else
                        f5 = fopen(fileNam5,'a');
                    end
                    fwrite(f5,q(:,tauind),'double');
                    fclose(f5);
                end
            end
        end
            save([dir,'/Dat/indsinbinRC1.mat'], 'indsinbin');
      
    case 2
        
        for j=[1:50]
           
            fIn = [dir,'/Dat/qs','_',num2str(j),'_of_',int2str(nClass),'.dat'];
            fid = fopen(fIn,'r');
            qs = fread(fid,'double');
            fclose(fid);
           len=length(qs)/4;
            qs = reshape(qs,4,len);
            PDs = 2*[qs(2,:).*qs(4,:) - qs(1,:).*qs(3,:); ...
                qs(1,:).*qs(2,:) + qs(3,:).*qs(4,:); ...
                qs(1,:).^2 + qs(4,:).^2 - ones(1,len)/2 ];
            
            phi = [];
            theta = [];
            psi = [];
            
            for i =1:len             
                PD = PDs(:,i);
                Qr = [1+PD(3), PD(2), -PD(1), 0]';
                Qr = Qr/sqrt(sum(Qr.^2));
                [phi(i), theta(i), psi(i)] = q2Spider(Qr,0);
            end     
           
%             align = [psi' theta' phi'];%used this
            align = [psi' theta' phi'];%used this
            name = [dir,'/Dat/align_',num2str(j,'%02d'),'.dat'];
            writeSPIDERdoc(name, align);
           
        end
      
    case 3
        for j=[1:50]
            fIn = [dir,'/Dat/NLSAImage','_',num2str(j),'_of_',int2str(nClass),'.dat'];
            fid = fopen(fIn,'r');
            data = fread(fid,'float32');
            fclose(fid);         
            n = size(data,1)/nPix^2;           
            data = reshape(data,nPix,nPix,n);
%             data=permute(data,[2,1,3]);
            fOu = [dir,'/Dat/imgsSPIDER_',num2str(j),'_of_',int2str(nClass),'.dat'];
            writeSPIDERfile(fOu,data,'stack');
            
        end      
end
res='ok';