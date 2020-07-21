%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Ghoncheh Mashayekhi, 2019
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Ghoncheh Mashayekhi, 2019
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load(['../Data/slcPsinums'])
jm = parcluster();
job = createJob(jm);

obj = createTask(job, @readNLSAFile,1,{dir,slcPsinums})
submit(job)
wait(job,'finished');
results = fetchOutputs(job);
delete(job);

figure('position',[100 200 2000 1000],'color',[1 1 1]);
k=1;
for  i=1:47
    %     load (['DMcryosparc_nonUniRef_J6_12_5ShGC1NOV_prD',num2str(i),'_t3.mat'])
    %     subplot(6,9,i);plot(lambda1(2:end),'-o');title(num2str(i))
    %   subplot(6,9,k);plot(results{1,1}(1:20,i),'-o');title(num2str(i))
    subplot(5,10,k);scatter3(results{1,1}{1,i}(:,1),results{1,1}{1,i}(:,2),results{1,1}{1,i}(:,3),10,1:length(results{1,1}{1,i}(:,1)),'filled');title(num2str(i))
    % lammmrationo(i)=results{1,1}(3,i)/results{1,1}(2,i);
    spec = '\\psi%d';
    xlabel(sprintf(spec,1),'fontsize',10);ylabel(sprintf(spec,2),'fontsize',10);
    zlabel(sprintf(spec,3),'fontsize',10);
    k=k+1;
end
