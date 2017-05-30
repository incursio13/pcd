function varargout = ui(varargin)
% UI MATLAB code for ui.fig
%      UI, by itself, creates a new UI or raises the existing
%      singleton*.
%
%      H = UI returns the handle to a new UI or the handle to
%      the existing singleton*.
%
%      UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI.M with the given input arguments.
%
%      UI('Property','Value',...) creates a new UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ui

% Last Modified by GUIDE v2.5 30-May-2017 04:50:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ui_OpeningFcn, ...
                   'gui_OutputFcn',  @ui_OutputFcn, ...
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


% --- Executes just before ui is made visible.
function ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ui (see VARARGIN)

% Choose default command line output for ui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Update handles structure
% UIWAIT makes ui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in insert_gambar.
function insert_gambar_Callback(hObject, eventdata, handles)
% hObject    handle to insert_gambar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
axes(handles.axes1)
global im
global nama_file pathname filename
[filename, pathname] = uigetfile({'*.jpg;','JPG File';'*.*','All Files' },'mytitle');
%[path,user_cance]=imgetfile();

if strcmp(int2str(filename),'0')~=1
    im=strcat(pathname,filename);
    im=imread(im);
    imshow(im);
    nama_file=filename;
    title(strrep(filename,'_','\_'));
%     title(filename);
%     set(handles.text3,'String',filename);
end

set(handles.klasifikasi,'Enable','on');
% tombol_train.Enable='off';


% --- Executes on button press in klasifikasi.
function klasifikasi_Callback(hObject, eventdata, handles)
global filename k im;
global dtrainIdentity dtrainName dtrainDir dtrainNoSegmentGCH dtrainSegmentGCH;
ix=1;
temp2=strsplit(filename,'_');
temp2=temp2{1};
im_segment=fp_gch(fp_01_segmentation(im));
im = fp_gch(im);
for i=1:5
    temp=strsplit(dtrainName{k*i},'_');
    temp=temp{1};

    if strcmp(temp, temp2)
        ix=dtrainIdentity(k*i);
    end
end
temp = fp_04_knn_canberra(dtrainNoSegmentGCH, im, k);
clsPrediction = [];
for j=1:length(temp)
    clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
end
[acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity), clsPrediction, ix);
set(handles.klasifikasi_can,'String',num2str(prec));
set(handles.klas_acc_can,'String',num2str(acc));

% Euclidean - GCH -Segment
temp = fp_04_knn_euclidean(dtrainNoSegmentGCH, im, k);
clsPrediction = [];
for j=1:length(temp)
    clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
end
[acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity), clsPrediction, ix);
set(handles.klasifikasi_euc,'String',num2str(prec));
set(handles.klas_acc_euc,'String',num2str(acc));


%     % Segment - Canberra - GCH
temp = fp_04_knn_canberra(dtrainSegmentGCH, im_segment, k);
clsPrediction = [];
for j=1:length(temp)
    clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
end
[acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity),clsPrediction, ix);
set(handles.klasifikasi_can_seg,'String',num2str(prec));
set(handles.klas_acc_can_seg,'String',num2str(acc));

% Euclidean - GCH - Segment
temp = fp_04_knn_euclidean(dtrainSegmentGCH, im_segment, k);
k
temp
ix
clsPrediction = [];
for j=1:length(temp)
    clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
end
clsPrediction
[acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity),clsPrediction, ix);
acc
prec
set(handles.klasifikasi_euc_seg,'String',num2str(prec));
set(handles.klas_acc_euc_seg,'String',num2str(acc));



% --- Executes on button press in segmentasi.
function segmentasi_Callback(hObject, eventdata, handles)
% hObject    handle to segmentasi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in tanpa_segmentasi.
function tanpa_segmentasi_Callback(hObject, eventdata, handles)
% hObject    handle to tanpa_segmentasi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in euclidean.
function euclidean_Callback(hObject, eventdata, handles)
% hObject    handle to euclidean (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of euclidean


% --- Executes on button press in canberra.
function canberra_Callback(hObject, eventdata, handles)
% hObject    handle to canberra (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of canberra


% --- Executes on button press in GetPerformance.
function GetPerformance_Callback(hObject, eventdata, handles)
set(handles.GetPerformance,'Enable','off');
path = 'dataset/train/';
numOfTrain = 0.83;

% ===========================================================================
% Load images.

[classCount, classIdentity, classImage, imageDir, imageName] = fp_02_load(path);
global k
k = int8((numOfTrain)*classCount(1));

% Image segmentation.
temp = {};
for i=1:length(classImage)
    temp1 = fp_01_segmentation(classImage{i});
    temp = [temp temp1];
end

segmentImage = temp;
% for i=1:length(temp)
%    figure, imshow(temp{i}); 
% end

% ===========================================================================
% Get global color histogram.

gch_no_segment = {};
for i=1:length(classImage)
    temp = fp_gch(classImage{i});
    gch_no_segment = [gch_no_segment temp];
end

gch_segment = {};
for i=1:length(classImage)
    temp = fp_gch(segmentImage{i});
    gch_segment = [gch_segment temp];
end

% ===========================================================================
% Separate data train and data test.
global dtrainIdentity dtrainName dtrainDir dtrainNoSegmentGCH dtrainSegmentGCH;
[dtrainIdentity, dtestIdentity] = fp_05_separate(classCount, classIdentity, numOfTrain);

[dtrainName, dtestName] = fp_05_separate(classCount, imageName, numOfTrain);
[dtrainDir, dtestDir] = fp_05_separate(classCount, imageDir, numOfTrain);

[dtrainNoSegmentGCH, dtestNoSegmentGCH] = fp_05_separate(classCount, gch_no_segment, numOfTrain);
[dtrainSegmentGCH, dtestSegmentGCH] = fp_05_separate(classCount, gch_segment, numOfTrain);

% ===========================================================================
% Trivia

temp = dtrainIdentity;
dtrainIdentity = [];
for i=1:length(temp)
    idx_class_can_pixel = temp{i};
    for j=1:length(idx_class_can_pixel)
        dtrainIdentity = [dtrainIdentity idx_class_can_pixel(j)];
    end
end

temp = dtestIdentity;
dtestIdentity = [];
for i=1:length(temp)
    idx_class_can_pixel = temp{i};
    for j=1:length(idx_class_can_pixel)
        dtestIdentity = [dtestIdentity idx_class_can_pixel(j)];
    end
end

clear classIdentity;
% clear classImage;
clear imageName;
clear imageDir;
clear classProperties;
clear sv;

% ===========================================================================
% KNN retrieval.
% GCH

idx_can_GCH = {};
idx_euc_GCH = {};
idx_segment_can_GCH = {};
idx_segment_euc_GCH = {};

pr_can_GCH = {};
pr_euc_GCH = {};   
pr_segment_can_GCH = {};
pr_segment_euc_GCH = {};

for i=1:length(dtestNoSegmentGCH)
    % ========================= GCH ======================
    % Canberra - GCH - No Segment
    temp = fp_04_knn_canberra(dtrainNoSegmentGCH, dtestNoSegmentGCH{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_can_GCH = [idx_can_GCH temp];
    [acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity), clsPrediction, dtestIdentity(i));
    temp = [acc, prec, rec];
    pr_can_GCH = [pr_can_GCH temp];
    
    % Euclidean - GCH - No Segment
    temp = fp_04_knn_euclidean(dtrainNoSegmentGCH, dtestNoSegmentGCH{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_euc_GCH= [idx_euc_GCH temp];
    [acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity), clsPrediction, dtestIdentity(i));
    temp = [acc, prec, rec];
    pr_euc_GCH = [pr_euc_GCH temp];
    
%     % Segment - Canberra - GCH
    temp = fp_04_knn_canberra(dtrainSegmentGCH, dtestSegmentGCH{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_can_GCH = [idx_segment_can_GCH temp];
    [acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity), clsPrediction, dtestIdentity(i));
    temp = [acc, prec, rec];
    pr_segment_can_GCH = [pr_segment_can_GCH temp];
    
    % Euclidean - GCH - Segment
    temp = fp_04_knn_euclidean(dtrainSegmentGCH, dtestSegmentGCH{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_euc_GCH= [idx_segment_euc_GCH temp];
    [acc, prec, rec] = fp_06_precision_recall(length(dtrainIdentity), clsPrediction, dtestIdentity(i));
    temp = [acc, prec, rec];
    pr_segment_euc_GCH = [pr_segment_euc_GCH temp];
end

% % ====================== Average ===============
avg_acc_can = 0.0;
avg_acc_euc = 0.0;
avg_can_GCH = 0.0;
avg_euc_GCH = 0.0;

avg_segment_acc_can = 0.0;
avg_segment_acc_euc = 0.0;
avg_segment_can_GCH = 0.0;
avg_segment_euc_GCH = 0.0;
% % 
for i=1:length(dtestDir)
    avg_acc_can = avg_acc_can + pr_can_GCH{i}(1);
    avg_acc_euc = avg_acc_euc + pr_euc_GCH{i}(1);
    avg_can_GCH = avg_can_GCH + pr_can_GCH{i}(2);
    avg_euc_GCH = avg_euc_GCH + pr_euc_GCH{i}(2);
    
    avg_segment_acc_can = avg_segment_acc_can + pr_segment_can_GCH{i}(1);
    avg_segment_acc_euc = avg_segment_acc_euc + pr_segment_euc_GCH{i}(1);
    avg_segment_can_GCH = avg_segment_can_GCH + pr_segment_can_GCH{i}(2);
    avg_segment_euc_GCH = avg_segment_euc_GCH + pr_segment_euc_GCH{i}(2);
end
% 
avg_acc_euc = avg_acc_euc / double(length(dtestDir));
avg_acc_can = avg_acc_can / double(length(dtestDir));
avg_can_GCH = avg_can_GCH / double(length(dtestDir));
avg_euc_GCH = avg_euc_GCH / double(length(dtestDir));

avg_segment_acc_can = avg_segment_acc_can / double(length(dtestDir));
avg_segment_acc_euc = avg_segment_acc_euc / double(length(dtestDir));
avg_segment_can_GCH = avg_segment_can_GCH / double(length(dtestDir));
avg_segment_euc_GCH = avg_segment_euc_GCH / double(length(dtestDir));

% ================ Trivia ==============
clear i; clear j; clear prec; clear rec; clear temp; clear acc;
% clear clsPrediction;
% 
% % Done.
set(handles.insert_gambar,'Enable','on');
set(handles.acc_canberra,'String',num2str(avg_acc_can));
set(handles.acc_euclidean,'String',num2str(avg_acc_euc));
set(handles.precision_canberra,'String',num2str(avg_can_GCH));
set(handles.precision_euclidean,'String',num2str(avg_euc_GCH));

set(handles.acc_canberra_segment,'String',num2str(avg_segment_acc_can));
set(handles.acc_euclidean_segment,'String',num2str(avg_segment_acc_euc));
set(handles.precision_canberra_segment,'String',num2str(avg_segment_can_GCH));
set(handles.precision_euclidean_segment,'String',num2str(avg_segment_euc_GCH));
