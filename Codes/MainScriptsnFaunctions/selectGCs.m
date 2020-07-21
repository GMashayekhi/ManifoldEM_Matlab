function selectGCs(ApertureSize,dir,GCnum,visual)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020 UWM ManifoldEM team
%
% Initially developed by Ali Dashti 2014
% Revised by Ghoncheh Mashayekhi 2020
%
% Gets the aperturesize and find the GCnum highly populated Greate Circles 
% on S2. To do so, first the min(10,GCnum*2) highly populated Greate
% Circles are selected. Then out of those the most further apart ones are 
% chosed. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


disp('tessellation...')

load('Data/starFile.mat','q','df');
CG = [];
nG = floor(4*pi/(ApertureSize.^2));

numShannon = floor(pi/ApertureSize);
ov =1;

[S20 it] = distribute3Sphere(nG);


S20 = S20';

nS = size(q,2);

S2 = 2*[q(2,:).*q(4,:)-q(1,:).*q(3,:);q(1,:).*q(2,:)+q(3,:).*q(4,:);q(1,:).^2+q(4,:).^2-0.5];



p = [zeros(1,size(S2,2)); S2];  % construct pure vector quaternion

C = cell(nG,4);
% if visual==1
%     figure;
% end

for j = 1:(nG)
    
    qG =  [1+S20(3,j); S20(2,j); -S20(1,j); 0];
    qGc = [1+S20(3,j); -S20(2,j); S20(1,j); 0];
    qG = qG/sqrt(sum(qG.^2,1));
    qGc = qGc/sqrt(sum(qGc.^2,1));
    
    
    ps = qMult_bsx(qG,qMult_bsx(p,qGc));
    
    eps = ApertureSize; 
    
    ind = find(abs(ps(4,:)) < eps/2);
    
    C{j,1} = j; % class number
    C{j,2} = numel(ind); % number of members
    C{j,3} = ind;
    C{j,4} = S20(:,j); %center
    
%     if visual
%         scatter3(S2(1,1:100:end),S2(2,1:100:end),S2(3,1:100:end),1), axis vis3d
%         hold on
%         scatter3(S20(1,j),S20(2,j),S20(3,j),16,'r'), axis vis3d
%         scatter3(S2(1,ind),S2(2,ind),S2(3,ind),1,'g'), axis vis3d
%         hold off
%         drawnow;
%         pause(0);
%     end
    
end

% sort great circles
[nel inx] = sort([C{:,2}],'descend');

candGCnum = max(10,2*GCnum);
IDX = kmeans(S20(:,inx(1:candGCnum))',GCnum);

for i =1:GCnum
    a = find(IDX==i);
    GCind(i) = a(1);
end


% if visual
%     figure;
%     subplot(121)
%     scatter3(S20(1,inx(1:candGCnum)),S20(2,inx(1:candGCnum)),S20(3,inx(1:candGCnum)),30,IDX,'filled');
%     subplot(122)
%     bar(nel(GCind));
% 
%     figure;
%     scatter3(S20(1,:),S20(2,:),S20(3,:),1), axis vis3d
%     for j = inx([GCind])
%         
%         qG =  [1+S20(3,j); S20(2,j); -S20(1,j); 0];
%         qGc = [1+S20(3,j); -S20(2,j); S20(1,j); 0];
%         qG = qG/sqrt(sum(qG.^2,1));
%         qGc = qGc/sqrt(sum(qGc.^2,1));
%         
%         
%         ps = qMult_bsx(qG,qMult_bsx(p,qGc));
%         
%         eps = ApertureSize;
%         
%         ind = find(abs(ps(4,:)) < eps/2);
%         
%         hold on
%        % scatter3(S20(1,j),S20(2,j),S20(3,j),16,'r'), axis vis3d
%         scatter3(S2(1,ind),S2(2,ind),S2(3,ind),5), axis vis3d
%  
%         pause(1)
%     end
% end


%select great circle
theta = [];
CGtot = [];
jj = 0;

if visual==1
    figure;
end

CGtot={};
nn=1;
for j = inx([GCind])
    
    jj = jj+1;
    
    qG =  [1+S20(3,j); S20(2,j); -S20(1,j); 0];
    qGc = [1+S20(3,j); -S20(2,j); S20(1,j); 0];
    qG = qG/sqrt(sum(qG.^2,1));
    qGc = qGc/sqrt(sum(qGc.^2,1));
    
    
    ps = qMult_bsx(qG,qMult_bsx(p,qGc));
    
    eps = ApertureSize;
    
    ind = find(abs(ps(4,:)) < eps/2);
    
    theta{j} = atan2(ps(3,ind),ps(2,ind));
    
    
    
    numClass = ov*numShannon;
    dTheta = pi/numShannon;
    
    %New and more general and allows oversampling
    CG = cell(numClass+1,3);
    for i = 1:numClass+1
        binCntr = -pi/2 + (i-1)*dTheta/ov; % the bin centers
        lo = binCntr - dTheta/2;
        up = binCntr + dTheta/2;
        tmp = find((lo  <= theta{j}) & (theta{j} < up));
        CG{i,1} = i;
        CG{i,2} = numel(tmp);
        CG{i,3} = ind(tmp)';
    end
         
    CGtot(nn:nn+size(CG,1)-1,1) = CG(:,3);
    nn=nn+size(CG,1);
        
end
CG=CGtot;

if visual
    for i =1:size(CG,1)
        
        a=CG{i};
        qq=q(:,a);
        
        PDs = 2*[qq(2,:).*qq(4,:) - qq(1,:).*qq(3,:); ...
            qq(1,:).*qq(2,:) + qq(3,:).*qq(4,:); ...
            qq(1,:).^2 + qq(4,:).^2 - ones(1,length(a))/2 ];
        % reference PR is the average
        PD = sum(PDs,2);
        % make it a unit vector
        PD = PD/sqrt(sum(PD.^2));
        allPDs(:,i)=PD;
        allPDs(:,i)=PD;
        allPDsSize(i)=length(a);
    end
    
    figure('Color',[1 1 1]);
    scatter3(S20(1,:),S20(2,:),S20(3,:),2,'filled');hold on
    axis([-1 1 -1 1 -1 1])
    %'XLim',[-1 1],'YLim',[-1 1],'ZLim',[-1 1])
    lmax=max(allPDsSize);
    lmin=min(allPDsSize);
    c=colormap(jet(lmax-lmin+1));
    for i =1:size(CG,1)
        scatter3(allPDs(1,i),allPDs(2,i),allPDs(3,i),50,c(allPDsSize(i)-lmin+1,:),'filled');%axis vis3d
        hold on
    end
    title(['num of PDs:',num2str(length(allPDsSize))])
    colorbar;
    caxis([lmin lmax]);
end
CG=CG';
Met='GC';
save([dir,'/Data/S2tessellationResult.mat'],'nG','CG','ApertureSize','Met')
disp('Done')

end