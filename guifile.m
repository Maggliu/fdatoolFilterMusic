%�ҵ���ϵ��ʽliudm1997@gmail.com,��ӭ����
function varargout = guifile(varargin)
% GUIFILE MATLAB code for guifile.fig
%      GUIFILE, by itself, creates a new GUIFILE or raises the existing
%      singleton*.
%
%      H = GUIFILE returns the handle to a new GUIFILE or the handle to
%      the existing singleton*.
%
%      GUIFILE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUIFILE.M with the given input arguments.
%
%      GUIFILE('Property','Value',...) creates a new GUIFILE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before guifile_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to guifile_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help guifile

% Last Modified by GUIDE v2.5 10-Sep-2018 15:10:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @guifile_OpeningFcn, ...
                   'gui_OutputFcn',  @guifile_OutputFcn, ...
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


% --- Executes just before guifile is made visible.
function guifile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to guifile (see VARARGIN)

% Choose default command line output for guifile
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes guifile wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = guifile_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
set(handles.pushbutton6,'CDATA',imread('lowPass.PNG'));


function figure1_CreateFcn(hObject, eventdata, handles)
global X FS;
 [X,FS]=audioread('xxx.WAV'); % �� WAV �ļ�ת���ɱ��� ,xxx���ڳ�������Ŀ¼�µ��ļ����������ļ�����Ϊwav��ʽ��

function play_Callback(hObject, eventdata, handles)
global player;%����ȫ�ֱ���
musiccontrol(player,1);%ʹ��palyer�������֣���guifile��������ֲ��ź�������Ч�������½�һ�������ļ������Ʋ��š�

function pause_Callback(hObject, eventdata, handles)
global player;
musiccontrol(player,2);

function begin_Callback(hObject, eventdata, handles)%��ʼ�˲���ť
global Y;
global X;
global FS;
global player;
if get(handles.lowpass,'Value')==1                 %Ϊ�����˲������б��
    action=0;
elseif get(handles.highpass,'Value')==1
    action=2;
elseif get(handles.bandpass,'Value')==1
    action=4;
else
    action=6;
end
if get(handles.IIR,'Value')==1
    action=action+1;
else
    action=action+2;
end

Fs=str2num(get(handles.Fs,'String'));%��ȡ����������һ����д�ں���case��̫�鷳���ɴ�ȫ���ˣ�Ϊ��Ҳ����ν��
Fpass=str2num(get(handles.Fpass,'String'));
Fstop=str2num(get(handles.Fstop,'String'));
Fpass1=str2num(get(handles.Fpass1,'String'));
Fstop1=str2num(get(handles.Fstop1,'String'));
Fpass2=str2num(get(handles.Fpass2,'String'));
Fstop2=str2num(get(handles.Fstop2,'String'));
Apass=str2num(get(handles.Apass,'String'));
Astop=str2num(get(handles.Astop,'String'));
Apass1=str2num(get(handles.Apass1,'String'));
Apass2=str2num(get(handles.Apass2,'String'));
Astop1=str2num(get(handles.Astop1,'String'));
switch action
    case 1
        can=lowpassIIR(Fs,Fpass,Fstop);%��������˲������ز���
    case 2
        can=lowpassFIR(Fs,Fpass,Fstop);
    case 3
        can=highpassIIR(Fs,Fstop,Fpass);
    case 4
        can=highpassFIR(Fs,Fstop,Fpass);
    case 5
        can=bandpassIIR(Fs,Fstop1,Fpass1,Fpass2,Fstop2);
    case 6
        can=bandpassFIR(Fs,Fstop1,Fpass1,Fpass2,Fstop2);
    case 7
        can=bandstopIIR(Fs,Fstop1,Fpass1,Fpass2,Fstop2);
    case 8
        can=bandpassFIR(Fs,Fstop1,Fpass1,Fpass2,Fstop2);
end
Y=filter(can,X);%�����˲�
t=(0:length(X)-1)/FS; % ��������ʱ�� 
plot(handles.axes1,t,X); % ����ԭ����ͼ 
plot(handles.axes2,t,Y); % �����˲�����ͼ  
xf=fft(X); % ������Ҷ�任��ԭƵ�� 
yf=fft(Y); % ������Ҷ�任���˲���Ƶ�� 
fm=3000*length(xf)/FS; % ȷ����Ƶ��ͼ������Ƶ�� 
f=(0:fm)*FS/length(xf); % ȷ����Ƶ��ͼ��Ƶ�ʿ̶� 
plot(handles.axes3,f,abs(xf(1:length(f)))); % ����ԭ����Ƶ��ͼ 
plot(handles.axes4,f,abs(yf(1:length(f)))); % �����˲���Ƶ��ͼ 
player=audioplayer(Y,FS);


function bandpass_Callback(hObject, eventdata, handles) %�����ѡͼ������UI
figure=get(handles.panel3,'Parent');
position=get(handles.panel3,'Position');
set(handles.panel4,'Parent',figure)
set(handles.panel4,'Position',position)
set(handles.panel1,'Visible','off')
set(handles.panel2,'Visible','on')
set(handles.panel3,'Visible','off')
set(handles.panel4,'Visible','on')
set(handles.pushbutton6,'CDATA',imread('bandPass.PNG'));

function bandstop_Callback(hObject, eventdata, handles)
figure=get(handles.panel3,'Parent');
position=get(handles.panel3,'Position');
set(handles.panel4,'Parent',figure)
set(handles.panel4,'Position',position)
set(handles.panel1,'Visible','off')
set(handles.panel2,'Visible','on')
set(handles.panel3,'Visible','off')
set(handles.panel4,'Visible','on')
set(handles.pushbutton6,'CDATA',imread('bandStop.PNG'));

function lowpass_Callback(hObject, eventdata, handles)
set(handles.panel2,'Visible','off')
set(handles.panel1,'Visible','on')
set(handles.panel4,'Visible','off')
set(handles.panel3,'Visible','on')
set(handles.pushbutton6,'CDATA',imread('lowPass.PNG'));

function highpass_Callback(hObject, eventdata, handles)
set(handles.panel2,'Visible','off')
set(handles.panel1,'Visible','on')
set(handles.panel4,'Visible','off')
set(handles.panel3,'Visible','on')
set(handles.pushbutton6,'CDATA',imread('highPass.PNG'));
