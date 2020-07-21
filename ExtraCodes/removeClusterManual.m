function [posPath] = removeClusterManual(psi1,posPath,imgLabels,imgAllIntensity,pull)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Ali Dashti, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    imgLabels1 = imgLabels(posPath);
    imgAllIntensity1 = imgAllIntensity(posPath);
    clusterIntensity = [];
% %     for i = 1:3
% %         figure('position',[100 200 2000 1000],'color',[1 1 1]);
% %         scatter(psi1(:,1),psi1(:,2),20,abs(imgLabels1),'filled');
% %         axis image
% %         colormap(jet);
% %          title(['choose cluster number',int2str(i)] , 'fontsize',10);
% %          axis image
% % 
% %          roi = impoly;
% %          pos = wait(roi);
% %          close
% % 
% %          posD{i} = inpolygon(psi1(:,1),psi1(:,2),pos(:,1),pos(:,2));
% %          posD{i} = find(posD{i}==1);
% % 
% %          clusterIntensity(i) = mean(imgAllIntensity1(posD{i}))
% %     end
% %     figure('position',[100 200 2000 1000],'color',[1 1 1]);
% %     scatter(psi1(:,1),psi1(:,2),20,abs(imgLabels1),'filled');
% %     axis image
% %     colormap(jet);
% % 
% %    title(['cluster size 1:',num2str(clusterIntensity(1),'%5f')...
% %     '  2:',num2str(clusterIntensity(2))...
% %     ' cluster size 3:',num2str(clusterIntensity(3))...
% %     ] , 'fontsize',10);
% % 
% %     pause(5)

    figure('position',[100 200 2000 1000],'color',[1 1 1]);

    scatter(psi1(:,1),psi1(:,2),50,abs(imgLabels1),'filled');
    xlabel('\psi_1','fontsize',30);ylabel('\psi_2','fontsize',30);
    title(['prD:',int2str(pull),'choose the data'] , 'fontsize',10);
    axis([-5 5 -5 5]);

    roi = impoly;
    pos = wait(roi);
    close

    posPath1 = inpolygon(psi1(:,1),psi1(:,2),pos(:,1),pos(:,2));


    posPath1 = find(posPath1 == 1);
    posPath = posPath(posPath1);
end
        