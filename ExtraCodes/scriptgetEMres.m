%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Ghoncheh Mashayekhi, 2019
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


load(['Data/S2tessellationResult.mat'],'CG')
for i=1:58
    ind=CG{i};
    for j=1:length(ind)
        if ind(j)>14491
            ind(j)=ind(j)-14491;
        end
        if indsii(ind(j))<=862462
            imgLabels{i}(j)=0;
        else
            imgLabels{i}(j)=1;
        end
    end
    
end



jm = parcluster();
job = createJob(jm);

obj = createTask(job, @readEMFile,1,{dir,np})
submit(job)
wait(job,'finished');
results = fetchOutputs(job);
delete(job);

figure('position',[100 200 2000 1000],'color',[1 1 1]);
k=1;
for  i=1:58
%     load (['DMcryosparc_nonUniRef_J6_12_5ShGC1NOV_prD',num2str(i),'_t3.mat'])
%     subplot(6,9,i);plot(lambda1(2:end),'-o');title(num2str(i))
 %   subplot(6,9,k);plot(results{1,1}(1:20,i),'-o');title(num2str(i))
    subplot(6,10,k);scatter(results{1,1}{1,i}(:,1),results{1,1}{1,i}(:,2),10,imgLabels{i}(results{1,1}{2,i}),'filled');title(num2str(i))
  % lammmrationo(i)=results{1,1}(3,i)/results{1,1}(2,i);
  k=k+1;
end

