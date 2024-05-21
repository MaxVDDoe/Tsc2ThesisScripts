%% Variables
disp("Initializing Variables...")
BehaviourBoxVideo = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\MI23-05952-05F_OF_Miniscope.avi";
BehaviourBoxTimeStamps = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\MI23-05952-05F_OF_Miniscope_TimeStamps.csv";
MiniscopeVideo = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\My_V4_Miniscope\Merged.Avi";
MiniscopeTimeStamps = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\My_V4_Miniscope\timeStamps.csv";
MiniscopeMetaData = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\metaData.json";

BorisTimeStamps = "S:\Data\Miniscope Behaviour Combo\Boris Files\Grooming miniscope mice 05.xls";

OutputPath = "S:\";

%% Loading...
disp("Loading Data...")
% Time stamps
BehaviourBoxTimeStamps = readmatrix(BehaviourBoxTimeStamps,"OutputType","string");
MiniscopeTimeStamps = readcell(MiniscopeTimeStamps,"Delimiter",",");
MiniscopeMetaData = readstruct(MiniscopeMetaData);

% Videos
BehaviourBoxVideo = VideoReader(BehaviourBoxVideo);
MiniscopeVideo = VideoReader(MiniscopeVideo);

% Boris Data
BorisTimeStamps = readtable(BorisTimeStamps);

%% Transform timestamps
disp("Transforming timestamps...")

% Behaviourbox time stamps
BehaviourBoxTimeStamps = datetime(BehaviourBoxTimeStamps,"Format","dd-MMM-uuuu HH:mm:ss.SSS");

% Miniscope time stamps
MiniscopeStartTime = datetime(MiniscopeMetaData.recordingStartTime.year, ...
                     MiniscopeMetaData.recordingStartTime.month, ...
                     MiniscopeMetaData.recordingStartTime.day, ...
                     MiniscopeMetaData.recordingStartTime.hour, ...
                     MiniscopeMetaData.recordingStartTime.minute, ...
                     MiniscopeMetaData.recordingStartTime.second, ...
                     MiniscopeMetaData.recordingStartTime.msec,"Format","dd-MMM-uuuu HH:mm:ss.SSS");

MiniscopeAbsTime = cell(size(MiniscopeTimeStamps,1)-1,1);
for i = 1:size(MiniscopeTimeStamps,1)-1
    MiniscopeAbsTime{i} = MiniscopeStartTime + milliseconds(MiniscopeTimeStamps{i+1,2});
end
MiniscopeAbsTime = [MiniscopeAbsTime{:}]';

% Boris time stamps
BorisFrames = zeros(size(BorisTimeStamps,1)/2,2);
k = 1;
for i = 1:2:size(BorisTimeStamps,1)
    BorisFrames(k,1) = BorisTimeStamps.ImageIndex(i);
    BorisFrames(k,2) = BorisTimeStamps.ImageIndex(i+1);
    k = k + 1;
end

%% Find the start of the Behaviour video
disp("Finding the start of the behaviour video...")
TimeDifference = zeros(size(MiniscopeAbsTime,1),1);
MinTimeDifference = zeros(size(BehaviourBoxTimeStamps,1),1);
Indx_MinTimeDifference = zeros(size(BehaviourBoxTimeStamps,1),1);
fprintf(1,'Caculating time differences: %d / %d\n',size(BehaviourBoxTimeStamps,1), 0)
parfor i = 1:size(BehaviourBoxTimeStamps,1)
    TimeDifference = abs(milliseconds(MiniscopeAbsTime - BehaviourBoxTimeStamps(i)));
    [MinTimeDifference(i), Indx_MinTimeDifference(i)] = min(TimeDifference);
end

%% Calibration
VideoNumFrames = MiniscopeVideo.NumFrames;
Meanvalue = zeros(VideoNumFrames,1);
MaxValue = zeros(VideoNumFrames,1);
parfor i = 1:VideoNumFrames
    disp(i + " / " + VideoNumFrames)
    frame = read(MiniscopeVideo,i);
    Meanvalue(i) = mean(frame,"all");
    MaxValue(i) = max(max(frame));
end

[MinimalValue, MinimalIndex] = min(Meanvalue);
[MaximalValue, MaximalIndex] = max(Meanvalue);
BrightestPixel = max(MaxValue);

disp("Minimal value found was: "+MinimalValue+" At Index: "+MinimalIndex)
disp("Maximal value found was: "+MaximalValue+" At Index: "+MaximalIndex)
disp("Brightest Pixel: "+BrightestPixel)
disp("counting activity between: "+(BrightestPixel - round(BrightestPixel/3))+" / "+BrightestPixel)

MaximalFrame = read(MiniscopeVideo,MaximalIndex);
mask = MaximalFrame >= (BrightestPixel - round(BrightestPixel/3));

%% Overal activity Of Miniscope
disp("Calculating activity...")
Activity = zeros(MiniscopeVideo.NumFrames,1);
j = MiniscopeVideo.NumFrames;
parfor i = 1:j
    disp(i + " / " + j)
    Frame = read(MiniscopeVideo,i);
    MeanInRoi = mean(Frame(mask),"all");
    MeanOutRoi = mean(Frame(~mask),"all");
    Activity(i) = MeanInRoi - MeanOutRoi;
end

%% Sync activity to the behviour video

SyncedActivity = zeros(size(Indx_MinTimeDifference,1),1);
for i = 1:size(Indx_MinTimeDifference,1)
    SyncedActivity(i) = Activity(Indx_MinTimeDifference(i));
end
%% Save The Video's
% Screen information
ScreenSizePixels = get(0,'screensize');
ScreenSizeWidth = ScreenSizePixels(3);
ScreenSizeHight = ScreenSizePixels(4);
FigureWidth = BehaviourBoxVideo.Width + MiniscopeVideo.Width;
FigureHight = FigureWidth/3;

% Create a figure for plotting
f = figure(Resize="off");
f.Position = [(ScreenSizeWidth/2)-(FigureWidth/2),(ScreenSizeHight/2)-(FigureHight/2),FigureWidth,FigureHight];

% Border
Border = zeros((BehaviourBoxVideo.Height-MiniscopeVideo.Height)/2,MiniscopeVideo.Width,3);

% Video writer
Writer = VideoWriter("S:\OpenField Combination Video.avi","Motion JPEG AVI");
Writer.FrameRate = 25;
open(Writer)

% Plot activity
p = plot(Activity(Indx_MinTimeDifference(1):Indx_MinTimeDifference(1000)),'r');
xLine_handle = xline(1);

% Color map
cMap = turbo(BrightestPixel);

% Prealocation
FinalFrame = zeros(1224,1368,3,10);
FinalFrame = uint8(FinalFrame);
k = 1;

for i = 1:BehaviourBoxVideo.NumFrames
    FrameBehaviourBox = read(BehaviourBoxVideo,i);
    FrameMiniscope = read(MiniscopeVideo,Indx_MinTimeDifference(i));
    ColorMiniscope = ind2rgb(FrameMiniscope,cMap);
    
    %Move the activity in time
    if i <= 200
        delete(xLine_handle)
        xLine_handle = xline(i);
    else
        set(p,YData=Activity(Indx_MinTimeDifference(i)-199:Indx_MinTimeDifference(i)+800))
    end
    ActivityFrame = getframe(f).cdata;

    % Concatenate all the frames in a funny way
    FinalFrame(:,:,:,k) = [FrameBehaviourBox [Border;ColorMiniscope;Border]; ActivityFrame];

    % write frame to disk
    if k == 10
        disp("Writing video frame " + i + " / " + BehaviourBoxVideo.NumFrames)
        writeVideo(Writer,FinalFrame);
        k = 1;
    else
         k = k + 1;
    end
end
close(Writer)
disp("Done")







% for g = 1:size(BorisFrames,1)
%     disp("Opening " + g + ".avi")
% 
% 
%     % Get the range of activity specific for this behaviour
%     StartBehaviour = Indx_MinTimeDifference(BorisFrames(g,1));
%     EndBehaviour = Indx_MinTimeDifference(BorisFrames(g,2));
% 
%     % Plot the activity
%     plot(Activity(StartBehaviour-100:EndBehaviour+100),'r');
%     % Place the xLines to deliniate the onset and ofset of the bahaviour
%     % and the x line that shows the current time
%     xline(100,'-')
%     xline(size(StartBehaviour:EndBehaviour,2)+100,'-')
%     xLine_handle = xline(1);
% 
%     for i = 1:BorisFrames(g,2)-BorisFrames(g,1)+200+1
%         BehaviourBoxIndx = BorisFrames(g,1)-100:BorisFrames(g,2)+100;
%         MiniscopeIndx = Indx_MinTimeDifference(BehaviourBoxIndx);
%         % Move Xline
%         delete(xLine_handle)
%         xLine_handle = xline(i);
% 
%         % Get all the frames
%         FrameBehaviourBox = read(BehaviourBoxVideo,BehaviourBoxIndx(i));
%         FrameMiniscope = read(MiniscopeVideo,MiniscopeIndx(i));
%         RGBFrameMiniscope = cat(3,FrameMiniscope,FrameMiniscope,FrameMiniscope);
%         ActivityFrame = getframe(f).cdata;
% 
%         % Concatenate all the frames in a funny way
%         FinalFrame = [FrameBehaviourBox [Border;RGBFrameMiniscope;Border]; ActivityFrame];
% 
%         % write frame to disk
%         disp("Writing video frame " + i + " / " + (BorisFrames(g,2)-BorisFrames(g,1)+200+1))
%         writeVideo(Writer,FinalFrame);
%     end
%     close(Writer)
% end
% disp("Done")