function makeMovie(IMG1,dir,outFile,fps)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed  by Ali Dashti, 2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if exist(dir,'file')==0
    mkdir(dir)
end

writerObj = VideoWriter([dir,outFile]);
writerObj.FrameRate = fps;

open(writerObj);

F = struct('cdata',[],'colormap',[]);
scrsz = get(groot,'ScreenSize');
h = figure('position',[100 200 2000 1000],'Color',[1 1 1]);


dim = floor(sqrt(max(size(IMG1))));
l1 = mean(min(-IMG1(:,1:end),[],1));
l2 = mean(max(-IMG1(:,1:end),[],1));


for  i = 1:size(IMG1,2)
    
    
    IMG = reshape(-IMG1(:,i),dim,dim);
    imagesc(IMG), axis image;axis off
    
    title(int2str(i))
    colormap(gray)
    
    F= getframe(h);
    writeVideo(writerObj,F);
end
close(writerObj);
close all
end