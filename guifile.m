%我的联系方式liudm1997@gmail.com,欢迎讨论
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
 [X,FS]=audioread('xxx.WAV'); % 将 WAV 文件转换成变量 ,xxx填在程序所在目录下的文件名。音乐文件必须为wav格式。

function play_Callback(hObject, eventdata, handles)
global player;%声明全局变量
musiccontrol(player,1);%使用palyer控制音乐，在guifile里调用音乐播放函数不奏效，所以新建一个函数文件来控制播放。

function pause_Callback(hObject, eventdata, handles)
global player;
musiccontrol(player,2);

function begin_Callback(hObject, eventdata, handles)%开始滤波按钮
global Y;
global X;
global FS;
global player;
if get(handles.lowpass,'Value')==1                 %为各个滤波器进行编号
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

Fs=str2num(get(handles.Fs,'String'));%读取各个参数，一个个写在后面case里太麻烦，干脆全读了，为空也无所谓。
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
        can=lowpassIIR(Fs,Fpass,Fstop);%计算各个滤波器返回参数
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
Y=filter(can,X);%进行滤波
t=(0:length(X)-1)/FS; % 计算数据时刻 
plot(handles.axes1,t,X); % 绘制原波形图 
plot(handles.axes2,t,Y); % 绘制滤波波形图  
xf=fft(X); % 作傅里叶变换求原频谱 
yf=fft(Y); % 作傅里叶变换求滤波后频谱 
fm=3000*length(xf)/FS; % 确定绘频谱图的上限频率 
f=(0:fm)*FS/length(xf); % 确定绘频谱图的频率刻度 
plot(handles.axes3,f,abs(xf(1:length(f)))); % 绘制原波形频谱图 
plot(handles.axes4,f,abs(yf(1:length(f)))); % 绘制滤波后频谱图 
player=audioplayer(Y,FS);


function bandpass_Callback(hObject, eventdata, handles) %点击单选图标后调整UI
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
