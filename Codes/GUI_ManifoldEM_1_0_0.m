function varargout = GUI_ManifoldEM_1_0_0(varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (c) 2020 UWM ManifoldEM team
% Developed by Ghoncheh Mashayekhi, 2020
%
% GUI_ManifoldEM_1_0_0 MATLAB code for GUI_ManifoldEM_1_0_0.fig
%      GUI_ManifoldEM_1_0_0, by itself, creates a new GUI_ManifoldEM_1_0_0 or raises the existing
%      singleton*.
%
%      H = GUI_ManifoldEM_1_0_0 returns the handle to a new GUI_ManifoldEM_1_0_0 or the handle to
%      the existing singleton*.
%
%      GUI_ManifoldEM_1_0_0('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_ManifoldEM_1_0_0.M with the given input arguments.
%
%      GUI_ManifoldEM_1_0_0('Property','Value',...) creates a new GUI_ManifoldEM_1_0_0 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_ManifoldEM_1_0_0_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_ManifoldEM_1_0_0_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_ManifoldEM_1_0_0

% Last Modified by GUIDE v2.5 21-Jul-2020 12:27:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_ManifoldEM_1_0_0_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_ManifoldEM_1_0_0_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI_ManifoldEM_1_0_0 is made visible.
function GUI_ManifoldEM_1_0_0_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI_ManifoldEM_1_0_0 (see VARARGIN)

handles.ManifoldEMdir=pwd;
addpath(genpath([handles.ManifoldEMdir,'/Codes']))

% Choose default command line output for GUI_ManifoldEM_1_0_0
handles.output = hObject;
% set(findobj(handles.figure1),'Units','Normalized')
% a=get(0,'ScreenSize');
% set(handles.figure1,'Position',[a(1) a(2) floor(a(3)*.3) floor(a(4)*.3)])
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI_ManifoldEM_1_0_0 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_ManifoldEM_1_0_0_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_dist.
function push_dist_Callback(hObject, eventdata, handles)
% hObject    handle to push_dist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load([handles.ManifoldEMdir,'/Data/S2tessellationResult.mat'],'CG','Diameter')
load([handles.ManifoldEMdir,'/Data/starFile.mat'])
load([handles.ManifoldEMdir,'/Data/mrcsFile.mat'])

disp('Distance Calculation...')

emPar.Cs = Cs;        % Spherical aberration [mm]
emPar.EkV = Vol;        % Acceleration voltage [kV]
emPar.gaussEnv = inf;   % Gaussian damping envelope [A^-1]
emPar.nPix = nPix;       % lateral pixel size
emPar.dPix = PixSize;         % Pixel size [A]
emPar.AmpCont=AmpCont;

filterPar.type = 'Butter';
filterPar.Qc = 0.5;
filterPar.N = 8;

options.verbose = 0;
options.avgOnly = 0;
options.visual = 0;
maskSize=floor(Diameter/PixSize/2)+5;
mask = annularMask(0,maskSize,emPar.nPix,emPar.nPix);

switch  get(handles.check_parclust,'Value')
    case 0
        for prD=1:length(CG)
            ind = CG{prD};
            if ~isempty(ind)
                q1 = q(:,ind);
                df1 = df(ind);
                
                getDistanceCTF(length(df),ind, q1, df1, emPar, filterPar,...
                    mrcsfile, [handles.ManifoldEMdir,'/Dist'],['/IMGs_prD',num2str(prD),'.mat'],...
                    doTrsl,[handles.ManifoldEMdir,'/Data/xtrl.dat'],...
                    [handles.ManifoldEMdir,'/Data/ytrl.dat'],mask,options);
                prD
            end
        end
        
    case 1
        numberOfJobs = length(CG);% little in-house job management in matlab
        numberOfWorkers = str2num(char(get(handles.edit_nJobs,'String')));
        if ~isfield(handles,'ManifoldEMDirClust')
            disp('Canceled..pls enter the desired directory for ManifoldEM output in the cluster!')
            return
        end
        mrcsfile=[handles.ManifoldEMDirClust,'/Data/',filename];
        for num = 1:numberOfWorkers:numberOfJobs
            jm = parcluster();
            job = createJob(jm);
            
            ap = {[handles.ManifoldEMdir,'/Codes/']};
            job.AttachedFiles = ap;
            numNext  = min(numberOfJobs,num+numberOfWorkers-1);
            for prD =num:numNext
                ind = CG{prD};
                if ~isempty(ind)
                    q1 = q(:,ind);
                    df1 = df(ind);
                    
                    obj = createTask(job, @getDistanceCTF, 1, ...
                        {length(df),ind, q1, df1, emPar, filterPar,...
                        mrcsfile, [handles.ManifoldEMDirClust,'/Dist'],['/IMGs_prD',num2str(prD),'.mat'],...
                        doTrsl,[handles.ManifoldEMDirClust,'/Data/xtrl.dat'],...
                        [handles.ManifoldEMDirClust,'/Data/ytrl.dat'],mask,options});
                end
            end
            submit(job);
            wait(job,'finished');
            if ~isempty(isempty(job.Tasks(1).ErrorMessage))
                disp((job.Tasks(1).ErrorMessage))
            else
                disp([num2str(numNext),' prDs out of ',num2str(numberOfJobs),' are calculated'])
            end
            % results = fetchOutputs(job);
            delete(job);
        end
end
disp('Distance Calculation is finished.')
guidata(hObject, handles);

% --- Executes on button press in push_embed.
function push_embed_Callback(hObject, eventdata, handles)
% hObject    handle to push_embed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([handles.ManifoldEMdir,'/Data/S2tessellationResult.mat'],'CG')
disp('Embedding...')

tune =3;% tun*optmum sigma is used for embedding
rad = 5;% Trimming radius


switch  get(handles.check_parclust,'Value')
    case 0
        for prD=1:length(CG)
            ind = CG{prD};
            if ~isempty(ind)
                manifoldTrimming([handles.ManifoldEMdir,'/Dist/IMGs_prD',num2str(prD),'.mat'],...
                    0,tune,rad,[handles.ManifoldEMdir,'/EM'],['/EM_prD',num2str(prD),'.mat']);
                prD
            end
        end
    case 1
        
        numberOfJobs = length(CG);% little in-house job management in matlab
        numberOfWorkers = str2num(char(get(handles.edit_nJobs,'String')));
        if ~isfield(handles,'ManifoldEMDirClust')
            disp('Canceled..pls enter the desired directory for ManifoldEM output in the cluster!')
            return
        end
        for num = 1:numberOfWorkers:numberOfJobs
            jm = parcluster();
            job = createJob(jm);
            
            ap = {[handles.ManifoldEMdir,'/Codes/']};
            job.AttachedFiles = ap;
            numNext  = min(numberOfJobs,num+numberOfWorkers-1);
            for prD =num:numNext
                ind = CG{prD};
                if ~isempty(ind)
                    
                    obj = createTask(job, @manifoldTrimming, 0, {[handles.ManifoldEMDirClust,'/Dist/IMGs_prD',num2str(prD),'.mat'],...
                        0,tune,rad,[handles.ManifoldEMDirClust,'/EM'],['/EM_prD',num2str(prD),'.mat']});
                end
            end
            
            submit(job);
            wait(job,'finished');
            disp([num2str(numNext),' prDs out of ',num2str(numberOfJobs),' are calculated'])
            % results = fetchOutputs(job);
            delete(job);
        end
end
disp('Embedding is finished.');
guidata(hObject, handles);

% --- Executes on button press in push_NLSA.
function push_NLSA_Callback(hObject, eventdata, handles)
% hObject    handle to push_NLSA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

load([handles.ManifoldEMdir,'/Data/S2tessellationResult.mat'],'Diameter','CG')
load([handles.ManifoldEMdir,'/Data/starFile.mat'],'PixSize')
load([handles.ManifoldEMdir,'/Data/mrcsFile.mat'],'nPix')

disp('Applying NLSA...')

NoE=str2num(char(get(handles.edit_resolution,'String')));
ConCoef=20; % equal to 5% ocncatenation order
isSel.val=0;
maskSize=floor(Diameter/PixSize/2)+5;
mask = annularMask(0,maskSize,nPix,nPix);

switch  get(handles.check_parclust,'Value')
    case 0
        for prD=1:length(CG)
            ind = CG{prD};
            if ~isempty(ind)
                psiAnalysis([handles.ManifoldEMdir,'/Dist/IMGs_prD',num2str(prD),'.mat'],...
                    [handles.ManifoldEMdir,'/EM/EM_prD',num2str(prD),'.mat'],...
                    [handles.ManifoldEMdir,'/NLSA'],['/NLSA_prD',num2str(prD)],ConCoef,1:NoE,isSel,mask)
                prD
            end
        end
    case 1
        numberOfJobs = length(CG);% little in-house job management in matlab
        numberOfWorkers = str2num(char(get(handles.edit_nJobs,'String')));
        if ~isfield(handles,'ManifoldEMDirClust')
            disp('Canceled..pls enter the desired directory for ManifoldEM output in the cluster!')
            return
        end
        for num = 1:numberOfWorkers:numberOfJobs
            jm = parcluster();
            job = createJob(jm);
            
            ap = {[handles.ManifoldEMdir,'/Codes/']};
            job.AttachedFiles = ap;
            numNext  = min(numberOfJobs,num+numberOfWorkers-1);
            for prD =num:numNext
                ind = CG{prD};
                if ~isempty(ind)
                    obj = createTask(job, @psiAnalysis, 0, {[handles.ManifoldEMDirClust,'/Dist/IMGs_prD',num2str(prD),'.mat'],...
                        [handles.ManifoldEMDirClust,'/EM/EM_prD',num2str(prD),'.mat'],...
                        [handles.ManifoldEMDirClust,'/NLSA'],['/NLSA_prD',num2str(prD)],ConCoef,1:NoE,isSel,mask});
                end
            end
            submit(job);
            wait(job,'finished');
            if ~isempty(isempty(job.Tasks(1).ErrorMessage))
                disp((job.Tasks(1).ErrorMessage))
            else
                disp([num2str(numNext),' prDs out of ',num2str(numberOfJobs),' are calculated'])
            end
            delete(job);
        end
end
disp('NLSA is finished.');

guidata(hObject,handles)


function edit_resolution_Callback(hObject, eventdata, handles)
% hObject    handle to edit_resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_resolution as text
%        str2double(get(hObject,'String')) returns contents of edit_resolution as a double
diameter = str2num(char(get(handles.edit_diameter,'String')));
resolution = str2num(char(get(handles.edit_resolution,'String')));
ApIndex = str2num(char(get(handles.edit_ApIndex,'String')));
set(handles.edit_ApSize,'String',num2str(ApIndex*resolution/diameter));

clear('Data/S2tessellationResult.amt')

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_resolution_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_resolution (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ApIndex_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ApIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ApIndex as text
%        str2double(get(hObject,'String')) returns contents of edit_ApIndex as a double
diameter = str2num(char(get(handles.edit_diameter,'String')));
resolution = str2num(char(get(handles.edit_resolution,'String')));
ApIndex = str2num(char(get(handles.edit_ApIndex,'String')));
set(handles.edit_ApSize,'String',num2str(ApIndex*resolution/diameter));

clear('Data/S2tessellationResult.amt')

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_ApIndex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ApIndex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_diameter_Callback(hObject, eventdata, handles)
% hObject    handle to edit_diameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_diameter as text
%        str2double(get(hObject,'String')) returns contents of edit_diameter as a double
diameter = str2num(char(get(handles.edit_diameter,'String')));
resolution = str2num(char(get(handles.edit_resolution,'String')));
ApIndex = str2num(char(get(handles.edit_ApIndex,'String')));
set(handles.edit_ApSize,'String',num2str(ApIndex*resolution/diameter));

clear('Data/S2tessellationResult.amt')

guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function edit_diameter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_diameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_ApSize_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ApSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ApSize as text
%        str2double(get(hObject,'String')) returns contents of edit_ApSize as a double
% --- Executes during object creation, after setting all properties.
function edit_ApSize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ApSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_mrcs.
function push_mrcs_Callback(hObject, eventdata, handles)
% hObject    handle to push_mrcs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename,path] = uigetfile('*.mrcs');
mrcsfile=[path,filename];
if ~isempty(find(mrcsfile))
    [mode,nPix,nS]=ReadMRCHeaderGM(mrcsfile);
    if mode~=2
        disp('The data format is not float 32 which is the assumption in getDistance function! Need to revise it')
    end
end
save([handles.ManifoldEMdir,'/Data/mrcsFile.mat'],'mrcsfile','filename','nPix','nS')
disp('done!')
guidata(hObject,handles)

% --- Executes on button press in push_star.
function push_star_Callback(hObject, eventdata, handles)
% hObject    handle to push_star (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.star');
starfile=[path,file];
if ~isempty(find(starfile))
    set(handles.push_star,'Enable','off')
    drawnow
    if (strcmp(get(handles.push_star,'Enable'),'off')==1)
        getStarFile(starfile,handles.ManifoldEMdir);
        set(handles.push_star,'Enable','on')
    end
end
guidata(hObject,handles)

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_nJobs_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nJobs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nJobs as text
%        str2double(get(hObject,'String')) returns contents of edit_nJobs as a double


% --- Executes during object creation, after setting all properties.
function edit_nJobs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nJobs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in check_parclust.
function check_parclust_Callback(hObject, eventdata, handles)
% hObject    handle to check_parclust (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.check_parclust,'Value')==1
    set(handles.edit_ClustDir,'Enable','On')
    set(handles.text_insertdir,'Enable','On')
    set(handles.text_parjob,'Enable','On')
    set(handles.edit_nJobs,'Enable','On')
    drawnow
else
    set(handles.edit_ClustDir,'Enable','Off')
    set(handles.text_insertdir,'Enable','Off')
    set(handles.text_parjob,'Enable','Off')
    set(handles.edit_nJobs,'Enable','Off')
    
    drawnow
end
guidata(hObject,handles)

% Hint: get(hObject,'Value') returns toggle state of check_parclust


% --- Executes on button press in push_makeMovie.
function push_makeMovie_Callback(hObject, eventdata, handles)
% hObject    handle to push_makeMovie (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
load([handles.ManifoldEMdir,'/Data/S2tessellationResult.mat'],'Diameter','CG')
disp('Making 2D movies...')

NoE=str2num(char(get(handles.edit_NoE,'String')));
fps = 50;
switch  get(handles.check_parclust,'Value')
    case 0
        for prD=1:length(CG)
            ind = CG{prD};
            if ~isempty(ind)
                inFile = [handles.ManifoldEMdir,'/NLSA/NLSA_prD',int2str(prD)];
                for psinum = 1:NoE
                    load([inFile,'_psi_',int2str(psinum),'.mat' ]);
                    IMG1All{psinum} = IMG1;
                    %Topo_meanAll{psinum} = Topo_mean;
                end
                %
                %                 figure('position',[100 200 2000 1000],'color',[1 1 1]);
                %                 for i =1:NoE
                %                     if NoE<=3
                %                         subplot(1,NoE,i)
                %                     else
                %                         subplot(2,ceil(NoE/2),i)
                %                     end
                %                     topo = Topo_meanAll{i};
                %                     dim = sqrt(size(topo,1));
                %                     imagesc(reshape(topo(:,2),dim,dim));title(int2str(i));axis image;axis off;colormap(gray)
                %                     %scatter(psi(:,1),psi(:,2),'filled');axis image;axis off
                %                 end
                %                 print([handles.ManifoldEMdir,'/Topos/prD_',int2str(prD),'_topos'],'-dpng');
                %                 close all
                
                
                for psinum = 1:NoE
                    outFile =  ['/prD_',int2str(prD),'_psi_',int2str(psinum),'_NLSAmovie'];
                    makeMovie(IMG1All{psinum},[handles.ManifoldEMdir,'/Movies'],outFile,fps);
                end
            end
        end
    case 1
        numberOfJobs = length(CG);% little in-house job management in matlab
        numberOfWorkers = str2num(char(get(handles.edit_nJobs,'String')));
        if ~isfield(handles,'ManifoldEMDirClust')
            disp('Canceled..pls enter the desired directory for ManifoldEM output in the cluster!')
            return
        end
        if numberOfWorkers>10
            prompt = {'If there is a risk of getting the var space in cluster full, please change the Number of Jobs below'};
            dlgtitle = 'Input';
            dims = [1 60];
            definput = {num2str(numberOfWorkers)};
            answer = inputdlg(prompt,dlgtitle,dims,definput);
            numberOfWorkers=str2num(answer{1,1});
        end
        for num = 1:numberOfWorkers:numberOfJobs
            jm = parcluster();
            job = createJob(jm);
            %
            ap = {[handles.ManifoldEMdir,'/Codes/']};
            job.AttachedFiles = ap;
            numNext  = min(numberOfJobs,num+numberOfWorkers-1);
            for prD =num:numNext
                ind = CG{prD};
                if ~isempty(ind)
                    inFile = [handles.ManifoldEMDirClust,'/NLSA/NLSA_prD',int2str(prD)];
                    
                    variablesIn{1} = 'IMG1';
                    %variablesIn{2}= 'Topo_mean';
                    
                    obj = createTask(job,@getFromPsiFile,1,{variablesIn,NoE,inFile});
                end
            end
            
            submit(job)
            num
            wait(job,'finished');
            if ~isempty(isempty(job.Tasks(1).ErrorMessage))
                disp((job.Tasks(1).ErrorMessage))
            else
                results = fetchOutputs(job);
            end
            delete(job);
            clear jm
            for prD = num:numNext
                ind = CG{prD};
                if ~isempty(ind)
                    for psinum = 1:NoE
                        IMG1All{psinum} = results{prD-num+1}{psinum}{1}.IMG1;
                        %  Topo_mean{psinum} = results{prD-num+1}{psinum}{2}.Topo_mean;
                    end
                    
                    %                 figure('position',[100 200 2000 1000],'color',[1 1 1]);
                    %                 for i =1:NoE
                    %                     subplot(2,3,i)
                    %                     topo = Topo_mean{i};
                    %                     dim = sqrt(size(topo,1));
                    %                     imagesc(reshape(topo(:,2),dim,dim));title(int2str(i));axis image;axis off;colormap(gray)
                    %                     %scatter(psi(:,1),psi(:,2),'filled');axis image;axis off
                    %                 end
                    %                 print([handles.ManifoldEMdir,'/Topos/prD_',int2str(prD),'_topos'],'-dpng');
                    %                 close all
                    
                    
                    for psinum = 1:NoE
                        outFile =  ['/prD_',int2str(prD),'_psi_',int2str(psinum),'_NLSAmovie'];
                        makeMovie(IMG1All{psinum},[handles.ManifoldEMdir,'/Movies'],outFile,fps);
                    end
                end
            end
        end
end
disp('2D movies are ready')
guidata(hObject, handles);


% --- Executes on button press in push_NoE.
function push_NoE_Callback(hObject, eventdata, handles)
% hObject    handle to push_NoE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit_NoE_Callback(hObject, eventdata, handles)
% hObject    handle to edit_NoE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_NoE as text
%        str2double(get(hObject,'String')) returns contents of edit_NoE as a double


% --- Executes during object creation, after setting all properties.
function edit_NoE_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_NoE (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all NoE=str2num(char(get(handles.edit_resolution,'String')));
% CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_prop.
function push_prop_Callback(hObject, eventdata, handles)
% hObject    handle to push_prop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.mat');
propfile=[path,file];

if ~isempty(find(propfile))
    load(propfile)
else
    return
end
guidata(hObject,handles)
load([handles.ManifoldEMdir,'/Data/S2tessellationResult.mat'],'Diameter','CG')
load([handles.ManifoldEMdir,'/Data/starFile.mat'],'PixSize')
load([handles.ManifoldEMdir,'/Data/mrcsFile.mat'],'nPix')

disp('Propagating...')

ConCoef=20; % equal to 5% ocncatenation order
isSel.val=1;
maskSize=floor(Diameter/PixSize/2)+5;
mask = annularMask(0,maskSize,nPix,nPix);

% set(handles.push_prop,'Enable','off')
% drawnow
switch  get(handles.check_parclust,'Value')
    case 0
        for prD=1:length(CG)
            ind = CG{prD};
            if ~isempty(ind)
                isSel.sense=slcPsinums(prD,2);
                psiAnalysis([handles.ManifoldEMdir,'/Dist/IMGs_prD',num2str(prD),'.mat'],...
                    [handles.ManifoldEMdir,'/EM/EM_prD',num2str(prD),'.mat'],...
                    [handles.ManifoldEMdir,'/NLSA'],['/NLSA_prD',num2str(prD)],ConCoef,slcPsinums(prD,1),isSel,mask)
                prD
            end
        end
    case 1
        numberOfJobs = length(CG);% little in-house job management in matlab
        numberOfWorkers = str2num(char(get(handles.edit_nJobs,'String')));
        if ~isfield(handles,'ManifoldEMDirClust')
            disp('Canceled..pls enter the desired directory for ManifoldEM output in the cluster!')
            return
        end
        for num = 1:numberOfWorkers:numberOfJobs
            jm = parcluster();
            job = createJob(jm);
            
            ap = {[handles.ManifoldEMdir,'/Codes/']};
            job.AttachedFiles = ap;
            numNext  = min(numberOfJobs,num+numberOfWorkers-1);
            for prD =num:numNext
                ind = CG{prD};
                if ~isempty(ind)
                    isSel.sense=slcPsinums(prD,2);
                    obj = createTask(job, @psiAnalysis, 0, {[handles.ManifoldEMDirClust,'/Dist/IMGs_prD',num2str(prD),'.mat'],...
                        [handles.ManifoldEMDirClust,'/EM/EM_prD',num2str(prD),'.mat'],...
                        [handles.ManifoldEMDirClust,'/NLSA'],['/NLSA_prD',num2str(prD)],ConCoef,slcPsinums(prD,1),isSel,mask});
                end
            end
            submit(job)
            wait(job,'finished');
            if ~isempty(isempty(job.Tasks(1).ErrorMessage))
                disp(job.Tasks(1).ErrorMessage)
            else
                disp([num2str(numNext),' prDs out of ',num2str(numberOfJobs),'are calculated'])
            end
            delete(job);
        end
end
disp('Propagation is finished.');
% set(handles.push_prop,'Enable','on')
guidata(hObject,handles)

% --- Executes on button press in push_extract3D.
function push_extract3D_Callback(hObject, eventdata, handles)
% hObject    handle to push_extract3D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


nClass=50;
load([handles.ManifoldEMdir,'/Data/mrcsFile.mat'],'nPix')
load([handles.ManifoldEMdir,'/Data/slcPsinums.mat'])

switch  get(handles.check_parclust,'Value')
    case 0
        disp('3D Mapping...')
        for i=1:3
            writeBINARYtoSPIDER(nClass,nPix,handles.ManifoldEMdir,slcPsinums(:,2),slcPsinums(:,1),i)
            disp(['Step ',num2str(i),' is finished.'])
        end
    case 1
        if ~isfield(handles,'ManifoldEMDirClust')
            disp('Canceled..pls enter the desired directory for ManifoldEM output in the cluster!')
            return
        end
        disp('3D Mapping...')
        for i=1:3
            jm = parcluster();
            job = createJob(jm);
            
            ap = {[handles.ManifoldEMdir,'/Codes/']};
            job.AttachedFiles = ap;
            
            obj = createTask(job, @writeBINARYtoSPIDER,1,{nClass,nPix,handles.ManifoldEMDirClust,slcPsinums(:,2),slcPsinums(:,1),i});
            submit(job)
            wait(job,'finished');
            if ~isempty((job.Tasks(1).ErrorMessage))
                disp(job.Tasks(1).ErrorMessage)
            else
                disp([num2str(i),'  out of 3 steps is done!'])
            end
            delete(job);
        end
        
end
disp('3D mapping is finished')
guidata(hObject, handles);


function edit_ClustDir_Callback(hObject, eventdata, handles)
% hObject    handle to edit_ClustDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_ClustDir as text
%        str2double(get(hObject,'String')) returns contents of edit_ClustDir as a double
handles.ManifoldEMDirClust=get(handles.edit_ClustDir,'String');
handles.output = hObject;
guidata(hObject,handles)


% --- Executes during object creation, after setting all properties.
function edit_ClustDir_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_ClustDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in push_tess.
function push_tess_Callback(hObject, eventdata, handles)
% hObject    handle to push_tess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.ApSize=get(handles.edit_ApSize,'String');
Diameter=str2num(char(get(handles.edit_diameter,'String')));
Res=str2num(char(get(handles.edit_resolution,'String')));

if get(handles.radio_S2,'Value')
    S2tessellation(str2num(char(handles.ApSize)),100,handles.ManifoldEMdir,1);
end

if get(handles.radio_GC,'Value')
    selectGCs(str2num(char(handles.ApSize)),handles.ManifoldEMdir,1,1);
end

save([handles.ManifoldEMdir,'/Data/S2tessellationResult.mat'],'Diameter','Res','-append')
guidata(hObject,handles)


% --- Executes on button press in radio_GC.
function radio_GC_Callback(hObject, eventdata, handles)
% hObject    handle to radio_GC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radio_GC
