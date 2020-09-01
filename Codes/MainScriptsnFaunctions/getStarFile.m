function getStarFile(filename,dir)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team 
% Developed by Ghoncheh Mashayekhi, 2017
% gets the starfile directory+name as filename and save the information in
% manifoldEM format in dir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('writing star file....')
doTrsl=0;
f=fopen(filename);

UserGuide=textscan(f, '%s',40,'Delimiter',''); %1
fclose all;

for i=1:size(UserGuide{1,1},1)
    if ~isempty(find(UserGuide{1,1}{i,1}=='#'))
        name{i,1}=UserGuide{1,1}{i,1}(1:find(UserGuide{1,1}{i,1}=='#')-1);
    end
end

headlines=size(name,1);

for i=1:headlines
    f=fopen(filename);
    x=textscan(f, [repmat('%*s ',1,i-1),'%s ',repmat('%*s ',1,headlines-i+1)],'headerlines', headlines+2); %1
    varname = genvarname(name{i});
    eval([varname,'=x{1,1};']);
    fclose all;
end

if ~exist('x_rlnAnglePsi','var') | ~exist('x_rlnAngleRot','var') | ~exist('x_rlnAngleTilt','var')
    disp('Orientations are missing...can not continue')
    return
end

if ~exist('x_rlnDetectorPixelSize','var') 
    disp('Pixel size is missing...can not continue')
    return
end

if ~exist('x_rlnDefocusU','var') | ~exist('x_rlnDefocusV','var')
    disp('Defocus values is missing...can not continue')
    return
end

if ~exist('x_rlnSphericalAberration','var') 
    disp('SphericalAberration size is missing...can not continue')
    return
end

if ~exist('x_rlnDetectorPixelSize','var') 
    disp('Pixel size is missing...can not continue')
    return
end

if ~exist('x_rlnAmplitudeContrast','var') 
    disp('AmplitudeContrast size is missing...can not continue')
    return
end
phi=cell2mat(cellfun(@str2num,x_rlnAngleRot,'un',0))*pi/180;
theta=cell2mat(cellfun(@str2num,x_rlnAngleTilt,'un',0))*pi/180;
psi=cell2mat(cellfun(@str2num,x_rlnAnglePsi,'un',0))*pi/180;
df1=cell2mat(cellfun(@str2num,x_rlnDefocusU,'un',0));
df2=cell2mat(cellfun(@str2num,x_rlnDefocusV,'un',0));
ImageName=x_rlnImageName;
df=(df1+df2)/2;

Cs=(cell2mat(cellfun(@str2num,x_rlnSphericalAberration,'un',0)));
Vol=(cell2mat(cellfun(@str2num,x_rlnVoltage,'un',0)));
AmpCont=(cell2mat(cellfun(@str2num,x_rlnAmplitudeContrast,'un',0)));
PixSize=(cell2mat(cellfun(@str2num,x_rlnDetectorPixelSize,'un',0)));

Vol=Vol(1);Cs=Cs(1);AmpCont=AmpCont(1);PixSize=PixSize(1);

if exist('x_rlnOriginX','var')
    x=cell2mat(cellfun(@str2num,x_rlnOriginX,'un',0));
    y=cell2mat(cellfun(@str2num,x_rlnOriginY,'un',0));
    
    if find(abs(x)>1) | find(abs(y))>1
        xfilename=[dir,'/Data/xtrl.dat'];%%%'cryosparc_nonUniRef-J6_12_xtranslate.dat';
        f=fopen(xfilename,'w');
        fwrite(f,x,'single');
        fclose(f);
        
        yfilename=[dir,'/Data/ytrl.dat'];%%'cryosparc_nonUniRef-J6_12_ytranslate.dat';
        f=fopen(yfilename,'w');
        fwrite(f,y,'single');
        fclose all;
        doTrsl=1;
    end
end

df = (df1+df2)/2;
zros = zeros(size(phi));
% important q's must be 4xn
qz =  [cos(phi/2),zros,zros,-sin(phi/2)]';
qy =  [cos(theta/2),zros,-sin(theta/2),zros]';
qzs = [cos(psi/2),zros,zros,-sin(psi/2)]';  
q = qMult_bsx(qzs,qMult_bsx(qy,qz));

% Double number of data points by augmentation.
qc = [-q(2,:);q(1,:);-q(4,:);q(3,:)];
q = [q, qc];
df = [df; df];

if exist([dir,'/Data'],'dir')==0
    mkdir Data
end
save([dir,'/Data/starFile.mat'], 'q', 'df', 'Cs', 'Vol', 'PixSize', 'AmpCont','doTrsl')

disp('done!')
