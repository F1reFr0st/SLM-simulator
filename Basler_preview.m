clc
clear 
close all

delete(imaqfind);
% Create a video input object.
vid = videoinput('gentl', 1, 'Mono8');
src = getselectedsource(vid);

triggerconfig(vid,'manual');
vid.FramesPerTrigger = 1;
vid.TriggerRepeat = Inf;
vidRes = vid.VideoResolution;
imageRes = fliplr(vidRes);
% Create a figure window. This example turns off the default
% toolbar and menubar in the figure.
hFig = figure('Toolbar','none',...
       'Menubar', 'none',...
       'NumberTitle','Off',...
       'Name','Camera Settings', 'Units','normalized', ...
       'Position', [0.15 0.15  0.7 0.7]);

%ah1 = axes('Parent',hFig,'Units','normalized',
% 'Position',[0.05 0.1 0.75 0.8]);


% Set up the push buttons
uicontrol('String', 'Select ROI',...
    'Callback', {@InitializeROI, imageRes},...
    'Units','normalized',...
    'Position',[0.05 0.02 0.1 .04]);
uicontrol('String', 'Apply ROI',...
    'Callback', {@ApplyROI, vid},...
    'Units','normalized',...
    'Position',[0.17 0.02 0.1 .04]);
uicontrol('String', 'OK',...
    'Callback', {@StopPreview, vid},...
    'Units','normalized',...
    'Position',[0.85 0.02 .1 .04]);

bl3 = uicontrol('Parent',hFig,'Style','text','Units', ...
    'normalized', 'Position',[.55 0.07 .04 .02],...
                'String', int2str(src.ExposureTime));

uicontrol('Parent',hFig,'Style','slider','Callback', ...
    {@ChangeExposure, src, bl3},'Units','normalized', ...
    'Position',[.29 0.02 .54 .04],...
    'value',src.ExposureTime, ...
    'min',30, 'max',1000000);

uicontrol('Parent',hFig,'Style','text','Units', ...
    'normalized', 'Position',[.28 0.07 .04 .02],...
                'String','0');
uicontrol('Parent',hFig,'Style','text','Units', ...
    'normalized', 'Position',[.80 0.07 .04 .02],...
                'String','10000000');


% Create the image object in which you want to
% display the video preview data.


%hImage = imshow(zeros(imageRes), 'Parent', ah1);
hImage = imshow(zeros(imageRes));

%setappdata(hImage,'UpdatePreviewWindowFcn', @update_livehistogram_display);
preview(vid, hImage);

function InitializeROI(src,event, x)        
       global h 
       h = images.roi.Rectangle(gca, 'Position', [1 1 x(2)-1 x(1)-1],'StripeColor','r');  
end

function ApplyROI(src,event, vid)
        global h         
        vid.ROIPosition = ceil(h.Position);        
        delete(h);
end

function ChangeExposure(src, event, obj1, obj2)
    obj1.ExposureTime = src.Value;
    obj2.String = int2str(src.Value);
end

function create_axes()
    global ah2
    ah2 = axes('Units','normalized','Position',[0.83 0.1 0.15 0.8]);
end

function StopPreview(src,event, obj)
    close  gcf
    stoppreview(obj);
    SLM_simulator;
    %delete(obj1)
    %clear obj1 obj2
end

function update_livehistogram_display(src,event,hImage)
    global ah2

    delete(ah2)
    % Display the current image frame. 
    set(hImage, 'CData', event.Data);    
    % Select the second subplot on the figure for the histogram.
    ah2 = axes('Units','normalized','Position',[0.83 0.1 0.15 0.8]);      
    % Plot the histogram. Choose 128 bins for faster update of the display.
    imhist(event.Data, 32);
end
