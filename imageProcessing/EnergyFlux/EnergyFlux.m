function varargout = gui(varargin)
% gui MATLAB code for gui.fig
%      gui, by itself, creates a new gui or raises the existing
%      singleton*.
%
%      H = gui returns the handle to a new gui or the handle to
%      the existing singleton*.
%
%      gui('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gui.M with the given input arguments.
%
%      gui('Property','Value',...) creates a new gui or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 04-Nov-2015 22:29:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Choose default command line output for gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in browse_matfile.
function browse_matfile_Callback(hObject, eventdata, handles)
[file_mat,dir_mat,FilterIndex]=uigetfile('*.mat','Select Data File');
if FilterIndex==1
    set(handles.file_mat,'String',[dir_mat file_mat]);
    set(handles.dir_output, 'String', dir_mat)
end



function file_mat_Callback(hObject, eventdata, handles)
file_mat = get(hObject,'String');

% --- Executes during object creation, after setting all properties.
function file_mat_CreateFcn(hObject, eventdata, handles)
% hObject    handle to file_mat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_output.
function browse_output_Callback(hObject, eventdata, handles)

dir_output = uigetdir('', 'Select Data Output Folder');
set(handles.dir_output, 'String', dir_output)
% hObject    handle to browse_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function dir_output_Callback(hObject, eventdata, handles)

dir_output = get(hObject,'String');
% hObject    handle to dir_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dir_output as text
%        str2double(get(hObject,'String')) returns contents of dir_output as a double


% --- Executes during object creation, after setting all properties.
function dir_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dir_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in browse_plots.
function browse_plots_Callback(hObject, eventdata, handles)
% hObject    handle to browse_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function dir_plots_Callback(hObject, eventdata, handles)
% hObject    handle to dir_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dir_plots as text
%        str2double(get(hObject,'String')) returns contents of dir_plots as a double


% --- Executes during object creation, after setting all properties.
function dir_plots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dir_plots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function RhoName_Callback(hObject, eventdata, handles)
% hObject    handle to RhoName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of RhoName as text
%        str2double(get(hObject,'String')) returns contents of RhoName as a double


% --- Executes during object creation, after setting all properties.
function RhoName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to RhoName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Xname_Callback(hObject, eventdata, handles)
% hObject    handle to Xname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Xname as text
%        str2double(get(hObject,'String')) returns contents of Xname as a double


% --- Executes during object creation, after setting all properties.
function Xname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Xname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Zname_Callback(hObject, eventdata, handles)
% hObject    handle to Zname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Zname as text
%        str2double(get(hObject,'String')) returns contents of Zname as a double


% --- Executes during object creation, after setting all properties.
function Zname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Nname_Callback(hObject, eventdata, handles)
% hObject    handle to Nname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Nname as text
%        str2double(get(hObject,'String')) returns contents of Nname as a double


% --- Executes during object creation, after setting all properties.
function Nname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Nname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function DTname_Callback(hObject, eventdata, handles)
% hObject    handle to DTname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DTname as text
%        str2double(get(hObject,'String')) returns contents of DTname as a double


% --- Executes during object creation, after setting all properties.
function DTname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DTname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buffer_check.
function buffer_check_Callback(hObject, eventdata, handles)
% hObject    handle to buffer_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buffer_check





function gpz_value_Callback(hObject, eventdata, handles)
% hObject    handle to gpz_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% Hints: get(hObject,'String') returns contents of gpz_value as text
%        str2double(get(hObject,'String')) returns contents of gpz_value as a double


% --- Executes during object creation, after setting all properties.
function gpz_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gpz_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function gpx_value_Callback(hObject, eventdata, handles)
% hObject    handle to gpx_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of gpx_value as text
%        str2double(get(hObject,'String')) returns contents of gpx_value as a double


% --- Executes during object creation, after setting all properties.
function gpx_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gpx_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in start.
function start_Callback(hObject, eventdata, handles)
% hObject    handle to start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    set(handles.text21, 'String', 1)

axes(handles.axes1); cla
axes(handles.axes2); cla
axes(handles.axes3); cla
axes(handles.axes4); cla
axes(handles.axes5); cla
axes(handles.axes6); cla

% Load data set
file_mat=get(handles.file_mat,'String');
load(file_mat);

% Set variable names
Xname=get(handles.Xname,'String');
Zname=get(handles.Zname,'String');
Rhoname=get(handles.RhoName,'String');
Nname=get(handles.Nname,'String');
DTname=get(handles.DTname,'String');


modeStart=str2num(get(handles.modeStartSet,'String'));
modeEnd=str2num(get(handles.modeEndSet,'String'));

Xfull = eval(Xname);
Zfull = eval(Zname);
Rhofull = eval(Rhoname);
Nfull = eval(Nname);
DTfull = eval(DTname);

ax = [min(Xfull(:)) max(Xfull(:)) min(Zfull(:)) max(Zfull(:))];

% Impose buffer

if get(handles.buffer_check,'Value') == 1
    
    gpX=str2num(get(handles.gpx_value,'String'))/100;
    gpY=str2num(get(handles.gpz_value,'String'))/100;  
    
    if get(handles.radiobutton2,'Value')==1; 
        diffuse = 1; 
    else
        diffuse = 0; 
    end
    
    [Xfull_Buffer, Zfull_Buffer, Rhofull_Buffer, ind] = buffer_data(Xfull, Zfull, Rhofull, gpX, gpY,diffuse);  

end

    if get(handles.radiobutton5,'Value')==1; 
        CGS = 1; 
        disp('using CGS units')
    else
        CGS = 0; 
    end

% Plot the density perturbation field
axes(handles.axes1)

if get(handles.buffer_check,'Value') == 1
    pc = pcolor(Xfull_Buffer,Zfull_Buffer,Rhofull_Buffer(:,:,3)); set(pc,'LineStyle','none'); hold on;
    axis([min(Xfull_Buffer(:)) max(Xfull_Buffer(:)) min(Zfull_Buffer(:)) max(Zfull_Buffer(:))])
    plot([ax(1) ax(2) ax(2) ax(1) ax(1)],[ax(3) ax(3) ax(4) ax(4) ax(3)],'--k','LineWidth',2)
else
    pc = pcolor(Xfull,Zfull,Rhofull(:,:,3)); set(pc,'LineStyle','none');    
    axis([min(Xfull(:)) max(Xfull(:)) min(Zfull(:)) max(Zfull(:))])
end
hold on
colorbar
cMax = max(max(Rhofull(:,:,3)));
caxis(cMax*[-1 1]);
colormap redblue

% Calculate the velocity
[w, u] = vel_calculation(Xfull,Zfull,Rhofull,Nfull,DTfull,CGS);

% Calculate the pressure


if get(handles.buffer_check,'Value') == 1
    p = press_calculation(Xfull_Buffer,Zfull_Buffer,Rhofull_Buffer,Nfull,modeStart,modeEnd,CGS);    
    p = p(ind(1):ind(2),ind(3):ind(4),:);    
else
    p = press_calculation(Xfull,Zfull,Rhofull,Nfull,modeStart,modeEnd,CGS);        
end

% Calculate the energy fluxes
Jx = u.*p;
Jz = w.*p;

k = 1;


handles.Jx = Jx;
handles.Jz = Jz;
handles.Xfull = Xfull;
handles.Zfull = Zfull;
handles.p = p;
handles.u = u;
handles.w = w;
handles.k = k;
handles.ax = ax;

% Plot the results
plot_results(handles)


% Save the data

dir_output=get(handles.dir_output,'String');

save([dir_output '/greens_function_outputs.mat'],'Xfull','Zfull','w','u','p','Jx','Jz');

guidata(hObject,handles)



function modeStartSet_Callback(hObject, eventdata, handles)
% hObject    handle to modeStartSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modeStartSet as text
%        str2double(get(hObject,'String')) returns contents of modeStartSet as a double


% --- Executes during object creation, after setting all properties.
function modeStartSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modeStartSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function modeEndSet_Callback(hObject, eventdata, handles)
% hObject    handle to modeEndSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of modeEndSet as text
%        str2double(get(hObject,'String')) returns contents of modeEndSet as a double


% --- Executes during object creation, after setting all properties.
function modeEndSet_CreateFcn(hObject, eventdata, handles)
% hObject    handle to modeEndSet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

k = handles.k;

if k > 1
    
    handles.k = k - 1;
    plot_results(handles)
    set(handles.text21, 'String', num2str(k-1))
end

guidata(hObject,handles)


       
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

k = handles.k;
p = handles.p;

if k < size(p,3)
    
    handles.k = k + 1;
    plot_results(handles)
    set(handles.text21, 'String', num2str(k+1))
    
end
guidata(hObject,handles)


function plot_results(handles)

Jx = handles.Jx;
Jz = handles.Jz;
Xfull = handles.Xfull;
Zfull = handles.Zfull;
p = handles.p;
u = handles.u;
w = handles.w;
k = handles.k;
ax = handles.ax;

% Plot the calculated pressure
axes(handles.axes4)
cla
pc = pcolor(Xfull,Zfull,p(:,:,k)); set(pc,'LineStyle','none');
colorbar;
cMax = max(abs(p(:)));
caxis(cMax*[-1 1]);
axis(ax)
colormap redblue

% Plot the calculated vertical velocity
axes(handles.axes2)
cla
pc = pcolor(Xfull,Zfull,w(:,:,k)); set(pc,'LineStyle','none');
colorbar;
cMax = max(abs(w(:)));
caxis(cMax*[-1 1]);
axis(ax)
colormap redblue

% Plot the calculated horizontal velocity
axes(handles.axes3)
cla
pc = pcolor(Xfull,Zfull,u(:,:,k)); set(pc,'LineStyle','none');
colorbar;
cMax = max(abs(u(:)));
caxis(cMax*[-1 1]);
axis(ax)
colormap redblue

% Plot the calculated horizontal energy flux
axes(handles.axes5)
cla
pc = pcolor(Xfull,Zfull,Jx(:,:,k)); set(pc,'LineStyle','none');
colorbar;
cMax = max(abs(Jx(:)));
caxis(cMax*[-1 1]);
axis(ax)
colormap redblue

% Plot the calculated vertical energy flux
axes(handles.axes6)
cla
pc = pcolor(Xfull,Zfull,Jz(:,:,k)); set(pc,'LineStyle','none');
colorbar;
cMax = max(abs(Jz(:)));
caxis(cMax*[-1 1]);
axis(ax)
colormap redblue


% --- Executes on button press in filehelp.
function filehelp_Callback(hObject, eventdata, handles)
filehelp=msgbox({'The user must first supply the .mat file which contains the density perturbation, the grid, time step (optional, may be set in the GUI), and the buoyancy frequency (optional, may be set in the GUI).','', 'Density perturbation: The density perturbation must be a single array containing multiple time instances. The first dimension is the z direction, the second dimension is the x direction, and the third is time. Units must be in cgs or si based on designation in GUI.', '', 'Coordinate arrays: The coordinate arrays must be in the same shape as the velocity components minus the time dimension and must be separate arrays for the x and z coordinates. The arrays are in the form of outputs for the Matlab function "meshgrid." Refer to the Matlab help documents for further details.','','Optional variables: The user has the option of including the time step (in seconds) and the buoyancy frequency (in 1/sec) either in the data file or can input them manually in the GUI.',''}, 'Matlab File with Data');
% hObject    handle to filehelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in outputhelp.
function outputhelp_Callback(hObject, eventdata, handles)
outputhelp=msgbox({'After the calculations are finished, the data is output into the specified folder. The velocity, pressure, and horizontal and vertical flux field components are output into the matlab file "greens_function_outputs.mat."'},'Data Output');
% hObject    handle to outputhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in arrayhelp.
function arrayhelp_Callback(hObject, eventdata, handles)
arraynameshelp=msgbox('These are the names of the arrays in the data input .mat file for the algorithm to read from. The names of the various arrays can be user-specifed.  The value of the time step (in seconds) and the buoyancy frequency (in 1/sec) can be entered manually.','Array Names in Input .mat File');
% hObject    handle to arrayhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in modehelp.
function modehelp_Callback(hObject, eventdata, handles)
modehelp=msgbox('Set the range of modes considered in the calculation.  The code will select the range automatically if none are entered.','Mode Selection');
% hObject    handle to modehelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in bufferhelp.
function bufferhelp_Callback(hObject, eventdata, handles)
modehelp=msgbox('If the density perturbation intersects the boundary, using a buffer will reduce erroneous signals in the calculated fields.  Check the box to use a buffer.  Set the size of the buffer based on the percent of the domain size.  There are two types of buffers available: zeros and diffuse.  The zero buffer is quicker to calculate, but not as accurate.  The diffuse buffer provides more accurate results.','Buffer Selection');
% hObject    handle to bufferhelp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function unitsPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to unitsPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
