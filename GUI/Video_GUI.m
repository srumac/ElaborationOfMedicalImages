function varargout = Video_GUI(varargin)
% VIDEO_GUI MATLAB code for Video_GUI.fig
%      VIDEO_GUI, by itself, creates a new VIDEO_GUI or raises the existing
%      singleton*.
%
%      H = VIDEO_GUI returns the handle to a new VIDEO_GUI or the handle to
%      the existing singleton*.
%
%      VIDEO_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIDEO_GUI.M with the given input arguments.
%
%      VIDEO_GUI('Property','Value',...) creates a new VIDEO_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Video_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Video_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Video_GUI

% Last Modified by GUIDE v2.5 20-Sep-2017 17:55:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Video_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Video_GUI_OutputFcn, ...
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


% --- Executes just before Video_GUI is made visible.
function Video_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% varargin   command line arguments to Video_GUI (see VARARGIN)

% Choose default command line output for Video_GUI
handles.output = hObject;
set(handles.start_stop_video,'Enable', 'off'); %set start and stop video button off
set(handles.save_video,'Enable', 'off'); %set save video button off
set(handles.detect,'Enable', 'off'); %set detect button off

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Video_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Video_GUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;
guidata(hObject,handles);


% --- Executes on button press in load_video.
function load_video_Callback(hObject, eventdata, handles)

global video mov len flag jjj band cascade

%Initializations
set(handles.load_video,'String','Loading...');  
set(handles.load_video,'Enable', 'off');
filename = uigetfile()
flag = 0; %flag of stop button
jjj = 1; %variable representing current frame                                            
band = 0; %flag of detection
cascade = {}; 
area = 150000;
set(handles.detect,'String','Detect');  
set(handles.save_video,'String','Save')
set(handles.detect,'Enable', 'on');
set(handles.save_video,'Enable', 'on');
set(handles.start_stop_video,'Enable','on')

% Load Cascade
load('cascade_finale')
cascade = cascade;

%Load video
video = VideoReader(filename); 
mov = divide(video); %divide the video in its frames, save them in "mov"
len = length(mov); %number of frames

%Resizing, necessary if frames are too big 
if size(mov(1).cdata, 1)*size(mov(1).cdata, 2)>area
    %resize video proportionally to dimension
    D = size(mov(1).cdata, 1)*size(mov(1).cdata, 2);
    r = floor(sqrt(area/D));
    for contatore =1:length(mov)
       mov(contatore).cdata = imresize(mov(contatore).cdata, 0.4);
    end
end

%show first frame
imshow(mov(1).cdata); 
set(handles.load_video,'String','Load New Video');
set(handles.load_video,'Enable', 'on');

% --- Executes on button press in start_stop_video.
function start_stop_video_Callback(hObject, eventdata, handles)

global mov iii len flag jjj l band mov_out                           
axes(handles.axes1);  %necessary for visualization

%if detection is complete, visualize processed video from first frame
if band == 1
   mov = mov_out;
   jjj = 1;
end

%If button label was 'Start'
if strcmp(get(handles.start_stop_video,'String'),'Start Video')
      set(handles.start_stop_video,'String','Stop Video');             % change button label in 'stop'
     % if 'stop' button was not previously clicked
          if flag==0                                                         
            jjj=1; %show video from first frame                                                          
          %if 'stop' button was prevously clicked
          elseif flag==1         
            jjj=l;  %show video from last frame
          end
    flag=0;
    %proceed with showing frames
    for iii = jjj:len
        imshow(mov(iii).cdata);
        drawnow;
        if flag==1                                                     % interrompe la visualizzazione se utilizzo il tasto stop
           break;
        end
    end
    set(handles.start_stop_video,'String','Start Video')
    guidata(hObject,handles);
     
%if button label was 'stop'
elseif strcmp(get(handles.start_stop_video,'String'),'Stop Video')
        set(handles.start_stop_video,'String','Start Video');
        flag=1; %'stop' button was clicked
        l=iii; %save current frame in l
        axes(handles.axes1);
        imshow(mov(l).cdata); %stop at current frame
        drawnow;
        guidata(hObject,handles);
    
end

% --- Executes on button press in save_video.
function save_video_Callback(hObject, eventdata, handles)

global mov_out mov band

if band == 0
    mov_out = mov;
end

%User can select saving folder 
workingDir = uigetdir();
%save video in workingDir
video_new = save_video('new_video', mov_out, workingDir);

set(handles.save_video,'String','Saved successfully')
set(handles.save_video,'Enable', 'off');

function detect_Callback(hObject, eventdata, handles)
set(handles.detect,'Enable', 'off'); 
set(handles.detect,'String','Detecting...'); 
pause %necessary user action in order to visualize progress

global mov cascade mov_out band

%detection
tic %show processing time
[mov_out, ~] = detect(mov, cascade);
toc

band = 1;%detection completed flag
axes(handles.axes1);
set(handles.detect,'String','Detection Completed!');           
imshow(mov_out(1).cdata); %show first frame of processed video        


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% global flag
% flag=1;
delete(hObject);
