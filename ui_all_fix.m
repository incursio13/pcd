function varargout = ui_all_fix(varargin)
% UI_ALL_FIX MATLAB code for ui_all_fix.fig
%      UI_ALL_FIX, by itself, creates a new UI_ALL_FIX or raises the existing
%      singleton*.
%
%      H = UI_ALL_FIX returns the handle to a new UI_ALL_FIX or the handle to
%      the existing singleton*.
%
%      UI_ALL_FIX('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in UI_ALL_FIX.M with the given input arguments.
%
%      UI_ALL_FIX('Property','Value',...) creates a new UI_ALL_FIX or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ui_all_fix_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ui_all_fix_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ui_all_fix

% Last Modified by GUIDE v2.5 21-Dec-2016 21:52:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ui_all_fix_OpeningFcn, ...
                   'gui_OutputFcn',  @ui_all_fix_OutputFcn, ...
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


% --- Executes just before ui_all_fix is made visible.
function ui_all_fix_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ui_all_fix (see VARARGIN)

% Choose default command line output for ui_all_fix
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ui_all_fix wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ui_all_fix_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% path = 'C:\Users\Arhy\Documents\viskom.fp\dataset\fixed\';
path = 'C:\Users\incr\Documents\viskom\dataset\';
numOfTrain = 0.8;
k = 5;

% ===========================================================================

% Load images.
[classCount, classIdentity, classImage, imageDir, imageName] = fp_02_load(path);

% Image segmentation.
temp = {};
for i=1:length(classImage)
    temp = [temp fp_01_segmentation(classImage{i})];
end

segmentImage = temp;

% ===========================================================================

% Pixel properties.
pixelClassProperties = cell(1,length(classCount));
pixelSegmentProperties = cell(1,length(classCount));

% Get glcm properties.
glcmClassProperties = {};
glcmSegmentProperties = {};
for i=1:length(classImage)
    glcmClassProperties = [glcmClassProperties fp_03_glcm(classImage{i})];
    pixelClassProperties{i} = fp_08_RGB(classImage{i});
    
    glcmSegmentProperties = [glcmSegmentProperties fp_03_glcm(segmentImage{i})];
    pixelSegmentProperties{i} = fp_08_RGB(segmentImage{i});
end

% ===========================================================================

% Separate data train and data test.
[dtrainIdentity, dtestIdentity] = fp_05_separate(classCount, classIdentity, numOfTrain);

[dtrainClassImage, dtestClassImage] = fp_05_separate(classCount, classImage, numOfTrain);
[dtrainSegmentImage, dtestSegmentImage] = fp_05_separate(classCount, segmentImage, numOfTrain);

[dtrainName, dtestName] = fp_05_separate(classCount, imageName, numOfTrain);
[dtrainDir, dtestDir] = fp_05_separate(classCount, imageDir, numOfTrain);

[dtrainClassGLCM, dtestClassGLCM] = fp_05_separate(classCount, glcmClassProperties, numOfTrain);
[dtrainClassPixel, dtestClassPixel] = fp_05_separate(classCount, pixelClassProperties, numOfTrain);

[dtrainSegmentGLCM, dtestSegmentGLCM] = fp_05_separate(classCount, glcmSegmentProperties, numOfTrain);
[dtrainSegmentPixel, dtestSegmentPixel] = fp_05_separate(classCount, pixelSegmentProperties, numOfTrain);

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
clear classImage;
clear imageName;
clear imageDir;
clear classProperties;
clear sv;
% ===========================================================================

% KNN retrieval.
% Pixel
idx_class_can_pixel = {};
idx_class_euc_pixel = {};
    
idx_segment_can_pixel = {};
idx_segment_euc_pixel = {};

pr_class_can_pixel = {};
pr_class_euc_pixel = {};
    
pr_segment_can_pixel = {};
pr_segment_euc_pixel = {};

% GLCM

idx_class_can_GLCM = {};
idx_class_euc_GLCM = {};
    
idx_segment_can_GLCM = {};
idx_segment_euc_GLCM = {};

pr_class_can_GLCM = {};
pr_class_euc_GLCM = {};
    
pr_segment_can_GLCM = {};
pr_segment_euc_GLCM = {};

for i=1:length(dtestClassPixel)
    % ========================= Pixel ======================
    % Class - Canberra - Pixel
    temp = fp_04_knn_canberra(dtrainClassPixel, dtestClassPixel{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_class_can_pixel = [idx_class_can_pixel temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_class_can_pixel = [pr_class_can_pixel temp];
    
    % Class - Euclidean - Pixel
    temp = fp_04_knn_euclidean(dtrainClassPixel, dtestClassPixel{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_class_euc_pixel= [idx_class_euc_pixel temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_class_euc_pixel = [pr_class_euc_pixel temp];
    
    % Segment - Canberra - Pixel
    temp = fp_04_knn_canberra(dtrainSegmentPixel, dtestSegmentPixel{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_can_pixel = [idx_segment_can_pixel temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_segment_can_pixel = [pr_segment_can_pixel temp];
    
    % Segment - Euclidean - Pixel
    temp = fp_04_knn_euclidean(dtrainSegmentPixel, dtestSegmentPixel{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_euc_pixel= [idx_segment_euc_pixel temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_segment_euc_pixel = [pr_segment_euc_pixel temp];
    
    % ========================= GLCM ======================
    % Class - Canberra - Pixel
    temp = fp_04_knn_canberra(dtrainClassGLCM, dtestClassGLCM{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_class_can_GLCM = [idx_class_can_GLCM temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_class_can_GLCM = [pr_class_can_GLCM temp];
    
    % Class - Euclidean - GLCM
    temp = fp_04_knn_euclidean(dtrainClassGLCM, dtestClassGLCM{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_class_euc_GLCM= [idx_class_euc_GLCM temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_class_euc_GLCM = [pr_class_euc_GLCM temp];
    
    % Segment - Canberra - GLCM
    temp = fp_04_knn_canberra(dtrainSegmentGLCM, dtestSegmentGLCM{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_can_GLCM = [idx_segment_can_GLCM temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_segment_can_GLCM = [pr_segment_can_GLCM temp];
    
    % Segment - Euclidean - GLCM
    temp = fp_04_knn_euclidean(dtrainSegmentGLCM, dtestSegmentGLCM{i}, k);
    
    clsPrediction = [];
    for j=1:length(temp)
        clsPrediction = [clsPrediction dtrainIdentity(temp(j))];
    end
    
    idx_segment_euc_GLCM = [idx_segment_euc_GLCM temp];
    [prec, rec] = fp_06_precision_recall(classCount, clsPrediction, dtestIdentity(i));
    temp = [prec, rec];
    pr_segment_euc_GLCM = [pr_segment_euc_GLCM temp];
end

avg_class_can_Pixel = 0.0;
avg_class_can_GLCM = 0.0;
avg_class_euc_Pixel = 0.0;
avg_class_euc_GLCM = 0.0;
avg_segment_can_Pixel = 0.0;
avg_segment_can_GLCM = 0.0;
avg_segment_euc_Pixel = 0.0;
avg_segment_euc_GLCM = 0.0;

for i=1:length(dtestDir)
    avg_class_can_Pixel = avg_class_can_Pixel + pr_class_can_pixel{i}(1);
    avg_class_can_GLCM = avg_class_can_GLCM + pr_class_can_GLCM{i}(1);
    avg_class_euc_Pixel = avg_class_euc_Pixel + pr_class_euc_pixel{i}(1);
    avg_class_euc_GLCM = avg_class_euc_GLCM + pr_class_euc_GLCM{i}(1);
    
    avg_segment_can_Pixel = avg_segment_can_Pixel + pr_segment_can_pixel{i}(1);
    avg_segment_can_GLCM = avg_segment_can_GLCM + pr_segment_can_GLCM{i}(1);
    avg_segment_euc_Pixel = avg_segment_euc_Pixel + pr_segment_euc_pixel{i}(1);
    avg_segment_euc_GLCM = avg_segment_euc_GLCM + pr_segment_euc_GLCM{i}(1);
end

avg_class_can_Pixel = avg_class_can_Pixel / double(length(dtestDir));
avg_class_can_GLCM = avg_class_can_GLCM / double(length(dtestDir));
avg_class_euc_Pixel = avg_class_euc_Pixel / double(length(dtestDir));
avg_class_euc_GLCM = avg_class_euc_GLCM / double(length(dtestDir));

avg_segment_can_Pixel = avg_segment_can_Pixel / double(length(dtestDir));
avg_segment_can_GLCM = avg_segment_can_GLCM / double(length(dtestDir));
avg_segment_euc_Pixel = avg_segment_euc_Pixel / double(length(dtestDir));
avg_segment_euc_GLCM = avg_segment_euc_GLCM / double(length(dtestDir));

clear i; clear j; clear prec; clear rec; clear temp;
clear clsPrediction;
% Done.

%tanpa segmentasi euclidean
axes(handles.axes1);
x=[];
y1=[];
y2=[];
for i=1:length(pr_class_euc_GLCM)
	x=[x i];
	y1=[y1 pr_class_euc_GLCM{i}(1)];
	y2=[y2 pr_class_euc_pixel{i}(1)];
end
plot(x,y1,x,y2);
legend('GLCM','Pixel');
title(strcat('Non Segmentasi-Euclidean || GLCM :', num2str(avg_class_euc_GLCM), ' || Pixel :', num2str(avg_class_euc_Pixel)));
xlabel('Index data test');
ylabel('Precision')

%tanpa segmentasi canberra
axes(handles.axes2);
x=[];
y1=[];
y2=[];
for i=1:length(pr_class_euc_GLCM)
	x=[x i];
	y1=[y1 pr_class_can_GLCM{i}(1)];
	y2=[y2 pr_class_can_pixel{i}(1)];
end
plot(x,y1,x,y2);
legend('GLCM','Pixel');
title(strcat('Non Segmentasi-Canberra|| GLCM :', num2str(avg_class_can_GLCM), ' || Pixel :', num2str(avg_class_can_Pixel)));
xlabel('Index data test');
ylabel('Precision')

%dengan segmentasi euclidean
axes(handles.axes3);
x=[];
y1=[];
y2=[];
for i=1:length(pr_class_euc_GLCM)
	x=[x i];
	y1=[y1 pr_segment_euc_GLCM{i}(1)];
	y2=[y2 pr_segment_euc_pixel{i}(1)];
end
plot(x,y1,x,y2);
legend('GLCM','Pixel');
title(strcat('Segmentasi-Euclidean || GLCM :', num2str(avg_segment_euc_GLCM), ' || Pixel :', num2str(avg_segment_euc_Pixel)));
xlabel('Index data test');
ylabel('Precision')

%dengan segmentasi canberra
axes(handles.axes4);
x=[];
y1=[];
y2=[];
for i=1:length(pr_class_euc_GLCM)
	x=[x i];
	y1=[y1 pr_segment_can_GLCM{i}(1)];
	y2=[y2 pr_segment_can_pixel{i}(1)];
end
plot(x,y1,x,y2);
legend('GLCM','Pixel');
title(strcat('Segmentasi-Canberra || GLCM :', num2str(avg_segment_can_GLCM), ' || Pixel :', num2str(avg_segment_can_Pixel)));
xlabel('Index data test');
ylabel('Precision')
