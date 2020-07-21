function S2tessellation(ApertureSize,PDsizeTh,dir,visual)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020 UWM ManifoldEM team
%
% Initially developed by Ali Dashti 2017
% Revised by Ghoncheh Mashayekhi 2020
%
% Gets the ApertureSize and divides S2 into patches (what we call projection
% directions (PD) in manifoldEM) with that size.
% Only store the PDs which include more than PDsizeTh number of snapshots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('tessellation...')

load('Data/starFile.mat','q','df');
CG = [];
nG = floor(4*pi/(ApertureSize.^2));
[S20 it] = distribute3Sphere(nG);

S20 = S20';

nS = size(q,2);

S2 = 2*[q(2,:).*q(4,:)-q(1,:).*q(3,:);q(1,:).*q(2,:)+q(3,:).*q(4,:);q(1,:).^2+q(4,:).^2-0.5];

[IND NC] = classS2(S2', S20');

NIND = find(NC>PDsizeTh);

if length(NIND)<1
    disp('No Snapshots in any PDs..make sure the settings are right')
    allPDs=0;
    allPDsSize=0;
    return
end

for i =1:round(length(NIND)/2)
    
    a = find(IND==NIND(i));
    CG{i} = a;
    qq=q(:,a);
    
    PDs = 2*[qq(2,:).*qq(4,:) - qq(1,:).*qq(3,:); ...
        qq(1,:).*qq(2,:) + qq(3,:).*qq(4,:); ...
        qq(1,:).^2 + qq(4,:).^2 - ones(1,length(a))/2 ];
    % reference PR is the average
    PD = sum(PDs,2);
    % make it a unit vector
    PD = PD/sqrt(sum(PD.^2));
    allPDs(:,i)=PD;
    allPDsSize(i)=length(a);
end

if exist([dir,'/Data'],'dir')==0
    mkdir Data
end
Met='S2'
save([dir,'/Data/S2tessellationResult.mat'],'nG','CG','ApertureSize','Met')
disp('Done')

if visual==1
    figure('Color',[1 1 1]);
    scatter3(S20(1,:),S20(2,:),S20(3,:),2,'filled');hold on
    axis([-1 1 -1 1 -1 1])
    %'XLim',[-1 1],'YLim',[-1 1],'ZLim',[-1 1])
    lmax=max(allPDsSize);
    lmin=min(allPDsSize);
    c=colormap(jet(lmax-lmin+1));
    for i =1:length(allPDsSize)
        scatter3(allPDs(1,i),allPDs(2,i),allPDs(3,i),50,c(allPDsSize(i)-lmin+1,:),'filled');%axis vis3d
        hold on
    end
    title(['num of PDs:',num2str(length(allPDsSize))])
    colorbar;%(handles.axes1,'caxis',[lmin lmax])
    caxis([lmin lmax]);
end
end
