function [res] = getDistanceCTF(nStot,ind, q, df, emPar, filterPar, imgFileName, dir,outFile,doTrsl,transFileNameX,transFileNameY,mask,options)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Authors: Peter Schwander 2014, Ali Dahsti 2017, Ghoncheh Mashayekhi 2020
%
% [res] = getDistanceCTF(ind, q, df, emPar, sigmaH, imgFileName, outFile, options)
% Calculates squared Euclidian distances for snapshots in similar
% projection directions. Includes CTF correction of microspope.
% Version with conjugates, effectively double number of data points
%
% % Input parameters
% nStot        Total umber of snapshots with augmentation
% ind          Global image indexes
%
% q            Rotation quaternions of all images, 4xN
%
% df           Defocus values of all images
%
% emPar        Common microscope parameters
%                emPar.Cs         Spherical aberration [mm]
%                emPar.EkV        Acceleration voltage [kV]
%                emPar.gaussEnv   Gaussian damping envelope [A^-1]
%                emPar.nPix       lateral pixel size
%                emPar.dPix       Pixel size [A]
%
% filterPar     filter Gaussian width [pixel]
%                filterPar.Qc         Cutoff frequency [Nyquist]
%                filterPar.type       Filter type 'Butter' or 'Gauss'
%                filterPar.N          Filter order (for 'Butter' only)
%
% imgFileName  Image file with all raw images
%
% outFile      Output filename
% 
% doTrsl       Flag which shows the translation of the images should be applied
%
% transFileNameX dat file name which includes the xorigins
%
% transFileNameY dat file name which includes the yorigins
%
% mask         2D mask to be applied
% options      Options field
%                options.verbose  Gives verbose information
%                options.avgOnly  Skips calculation of distances
%                options.visual   Displays averaged images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%

version = 'getDistanceCTF V 0.0';

% define default options, if not set
if ~isfield(options,'verbose')
    options.verbose = false;
end
if ~isfield(options,'avgOnly')
    options.avgOnly = false;
end
if ~isfield(options,'visual')
    options.visual = false;
end


nS = size(ind,1);
Psis = nan(nS,1);

imgAvg = zeros(emPar.nPix,emPar.nPix);
imgAll = zeros(emPar.nPix,emPar.nPix,nS);

centers=zeros(nS,2);
y = zeros((emPar.nPix)^2, nS);
fy = complex(zeros(emPar.nPix,emPar.nPix,nS));
CTF = zeros(emPar.nPix,emPar.nPix, nS);
D = zeros(nS,nS);

% maps images to file
m = memmapfile(imgFileName,'Offset',1024,'Format',{'single',emPar.nPix^2,'y'});
if doTrsl==1
    m2x = memmapfile(transFileNameX,'Format',{'single',1,'trlx'});
    m2y = memmapfile(transFileNameY,'Format',{'single',1,'trly'});
end

% read images with conjugates    
for iS=1:nS
    if ind(iS) <=nStot/2
        tmp=reshape(m.Data(ind(iS)).y,emPar.nPix,emPar.nPix)';
        
        if doTrsl==1
            centers(iS,:)=[m2x.Data(ind(iS)).trlx,m2y.Data(ind(iS)).trly];
            tmp = repmat(tmp,3,3);
            tmp=imtranslate(tmp,centers(iS,:));
            tmp = tmp(emPar.nPix+1:2*emPar.nPix,emPar.nPix+1:2*emPar.nPix);
        end
        
        y(:,iS)=tmp(:);
    else
        tmp = reshape(m.Data(ind(iS)-nStot/2).y, emPar.nPix, emPar.nPix)';
        
        if doTrsl==1
            centers(iS,:)=[m2x.Data(ind(iS)-nStot/2).trlx,m2y.Data(ind(iS)-nStot/2).trly];
            tmp = repmat(tmp,3,3);
            tmp=imtranslate(tmp,centers(iS,:));
            tmp = tmp(emPar.nPix+1:2*emPar.nPix,emPar.nPix+1:2*emPar.nPix);
        end
        
        tmp = flipud(tmp);
        y(:,iS)=tmp(:);
    end
end
        
    
        
y= vNorm2(y);

% setup mesh for filter
if mod(emPar.nPix,2)
    [X, Y] = meshgrid(-(emPar.nPix-1)/2:(emPar.nPix-1)/2,-(emPar.nPix-1)/2:(emPar.nPix-1)/2); % emPar.nPix odd
else
    [X, Y] = meshgrid(-emPar.nPix/2:emPar.nPix/2-1,-emPar.nPix/2:emPar.nPix/2-1); % emPar.nPix even
end

Q = (1/(emPar.nPix/2))*sqrt(X.^2+Y.^2); % Q in units of Nyquist frequency

% Setup filter
switch(filterPar.type)
    case('Gauss')
        G =  exp(-(log(2)/2)*(Q/filterPar.Qc).^2);
    case('Butter')
        G = sqrt(1./(1+(Q/filterPar.Qc).^(2*filterPar.N)));
    otherwise
        disp(['Fatal Error: Filter type ' filterPar.type ' unknown']);
end

% Filter images in Fourier space
G = ifftshift(G);
GG=repmat(G,1,1,size(y,2));
y=real(ifft2(GG.*fft2(reshape(y,emPar.nPix,emPar.nPix,size(y,2)))));

% Calculate average projection directions
PDs = 2*[q(2,:).*q(4,:) - q(1,:).*q(3,:); ...
    q(1,:).*q(2,:) + q(3,:).*q(4,:); ...
    q(1,:).^2 + q(4,:).^2 - ones(1,nS)/2 ];

% reference PR is the average
PD = sum(PDs,2);

% make it a unit vector
PD = PD/sqrt(sum(PD.^2));


SNR = 2;
% rotate images and perform FFT
for iS=1:nS
    
    % Quaternion approach
    s = -(1+PD(3))*q(4,iS) - PD(1)*q(2,iS) - PD(2)*q(3,iS);
    c =  (1+PD(3))*q(1,iS) + PD(2)*q(2,iS) - PD(1)*q(3,iS);
    
    Psi = 2*atan(s/c);  % note that the Psi are in the interval [-pi,pi]
    
    if isnan(Psi) % this happens only for a rotation of pi about an axis perpendicular to the projection direction
        Psi = 0;
    end
    
    Psis(iS) = Psi;  % save image rotations
   
    if options.verbose
        display(sprintf('Image rotation Psi = %g', Psi));
    end
    
    img = imrotateFill(y(:,:,iS),-(180/pi)*Psi); % the negative sign is due to Spider convention
    imgAvg = imgAvg + img;
    
    % Note: Q is defined in Nyquist and thus must be divided by twice the pixel size
    CTF(:,:,iS) = ifftshift(ctemh_cryoFrank(Q/(2*emPar.dPix),[emPar.Cs,df(iS),emPar.EkV,emPar.gaussEnv])); % ifftshift is correct!
    imgAll(:,:,iS) = img;    
end
clear y;

[n1 n2 n3] = size(imgAll);
mv=mean(imgAll,3);
mvm=repmat(mv,1,1,n3);
mm=repmat(mask,1,1,n3);
fy=fft2(double((imgAll-mvm).*mm));
fy = permute(fy,[3,1,2]);
fy = reshape(fy,n3,n1*n2);
CTF = reshape(CTF,emPar.nPix^2,nS);
CTF = CTF';
CTFfy = CTF.*fy;
Dv = (CTF.^2) *abs(fy.^2)';
D = Dv + Dv' - 2*real(CTFfy *CTFfy');
CTF=CTF';

if exist(dir,'file')==0
    mkdir(dir);
    fileattrib(dir,'+w','o');
end

save([dir,outFile],'CTF','imgAll','D','Psis','imgAvg','-v7.3');

res = 'ok';

end