%% Variables
disp("Initializing Variables...")
BehaviourBoxVideo = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\MI23-05952-05F_OF_Miniscope.avi";
BehaviourBoxTimeStamps = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\MI23-05952-05F_OF_Miniscope_TimeStamps.csv";
MiniscopeVideo = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\My_V4_Miniscope\Merged.Avi";
MiniscopeTimeStamps = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\My_V4_Miniscope\timeStamps.csv";
MiniscopeMetaData = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\metaData.json";

BorisTimeStamps = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\OF Events.xlsx";

OutputPath = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\output";

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

Boris.Begin = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Begin'));
Boris.Walking = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Walking'));
Boris.Sniffing = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Sniffing'));
Boris.Grooming = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Grooming'));
Boris.Sitting = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Sitting'));


%% Find the start of the Behaviour video
disp("Finding the start of the behaviour video...")
TimeDifference = zeros(size(MiniscopeAbsTime,1),1);
MinTimeDifference = zeros(size(BehaviourBoxTimeStamps,1),1);
Indx_MinTimeDifference = zeros(size(BehaviourBoxTimeStamps,1),1);
fprintf(1,'Caculating time differences: %d / %d\n',size(BehaviourBoxTimeStamps,1), 0)
parfor i = 1:size(BehaviourBoxTimeStamps,1)
    fprintf(1,'\b\b%d\n', i)
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
MinimalFrame = read(MiniscopeVideo,MinimalIndex);

mask = MaximalFrame >= (BrightestPixel - round(BrightestPixel/3.5));

%% Check calibration (Optional)
figure;
imshow(MinimalFrame);
colormap turbo
clim([0 BrightestPixel])
colorbar

figure;
imshow(MaximalFrame);
colormap turbo
clim([0 BrightestPixel])
colorbar

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

%% Sync Activity
SyncedActivity = zeros(size(Indx_MinTimeDifference,1),1);
for i = 1:size(Indx_MinTimeDifference,1)
    SyncedActivity(i) = Activity(Indx_MinTimeDifference(i));
end
%% Boris

AUCs.Walking = zeros(size(Boris.Walking,1)/2,1);
AUCs.Sniffing = zeros(size(Boris.Sniffing,1)/2,1);
AUCs.Grooming = zeros(size(Boris.Grooming,1)/2,1);
AUCs.Sitting = zeros(size(Boris.Sitting,1)/2,1);

for Behaviour = ["Walking" "Sniffing" "Grooming" "Sitting"]
k = 1;
for i = 1:2:size(Boris.(Behaviour),1)
    BeginBehaviour = Boris.(Behaviour)(i);
    EndBehaviour = Boris.(Behaviour)(i+1);
    AUC = trapz(SyncedActivity(BeginBehaviour:EndBehaviour));
    AUCs.(Behaviour)(k) = AUC / length(BeginBehaviour:EndBehaviour);
    k = k + 1;
end
end

%% Traces
Behaviour = "Grooming";
AllTraces = zeros(length(1:2:length(Boris.(Behaviour))),100);
f = figure;
hold on
k = 1;
for i = 1:2:length(Boris.(Behaviour))
    BeginBehaviour = Boris.(Behaviour)(i);
    EndBehaviour = BeginBehaviour + 50;
    AllTraces(k,:) = SyncedActivity((BeginBehaviour-49):EndBehaviour);
    k = k + 1;
end
MeanAllTraces = mean(AllTraces);
STD_AllTraces = std(AllTraces);
% x = 1:100;
% y1 = MeanAllTraces+STD_AllTraces;
% y2 = MeanAllTraces-STD_AllTraces;
% %patch([x fliplr(x)], [y1 fliplr(y2)], [.5 .5 .5])
for i = 1:size(AllTraces,1)
    plot(AllTraces(i,:),':b')
end
plot(MeanAllTraces,'r')
f.Theme = "Light";
title("Mean of all traces before and during Walking")
xline(50)
hold off

%%
% figure
% AUCGrooming = zeros(size(BorisFrames,1),3);
% for i = 1:size(BorisFrames,1)
%     StartBehaviour = Indx_MinTimeDifference(BorisFrames(i,1));
%     EndBehaviour = Indx_MinTimeDifference(BorisFrames(i,2));
%     AUCGrooming(i,1) = trapz(Activity(StartBehaviour-100:StartBehaviour)) / 100;
%     AUCGrooming(i,2) = trapz(Activity(StartBehaviour:EndBehaviour)) / (EndBehaviour - StartBehaviour);
%     AUCGrooming(i,3) = trapz(Activity(EndBehaviour:EndBehaviour+100)) / 100;
%     subplot(6,6,i)
%     plot(Activity(StartBehaviour-100:EndBehaviour+100));
%     xline(100,'-',{AUCGrooming(i,1)})
%     xline(((EndBehaviour - StartBehaviour) / 2) + 100,'-',{AUCGrooming(i,2)})
%     xline(size(StartBehaviour:EndBehaviour,2)+100,'-',{AUCGrooming(i,3)})
% end
% %figure
% %bar(["before" "During" "After"],[mean(AUCGrooming(:,1)) mean(AUCGrooming(:,2)) mean(AUCGrooming(:,3))])
% 
% %% Combination plot
% f = figure;
% hold on
% Filter = 70;
% for i = 1:size(BorisFrames,1)
%     StartBehaviour = Indx_MinTimeDifference(BorisFrames(i,1));
%     EndBehaviour = Indx_MinTimeDifference(BorisFrames(i,2));
%     HighestValuePreBehaviour = max(Activity(StartBehaviour-100:StartBehaviour));
%     if HighestValuePreBehaviour >= Filter
%         continue
%     else
%         plot(Activity(StartBehaviour-100:EndBehaviour+100));
%     end
% end
% xlim([0 200])
% xline(100,'-')
% exportgraphics(f,"S:\Alltraces.emf")
% 
% %% Save The Video's
% 
% % Screen information
% ScreenSizePixels = get(0,'screensize');
% ScreenSizeWidth = ScreenSizePixels(3);
% ScreenSizeHight = ScreenSizePixels(4);
% FigureWidth = BehaviourBoxVideo.Width + MiniscopeVideo.Width;
% FigureHight = FigureWidth/3;
% 
% % Create a figure for plotting
% f = figure(Resize="off");
% f.Position = [(ScreenSizeWidth/2)-(FigureWidth/2),(ScreenSizeHight/2)-(FigureHight/2),FigureWidth,FigureHight];
% 
% % Border
% Border = zeros((BehaviourBoxVideo.Height-MiniscopeVideo.Height)/2,MiniscopeVideo.Width,3);
% 
% for g = 1:size(BorisFrames,1)
%     disp("Opening " + g + ".avi")
%     Writer = VideoWriter(OutputPath + "\" + g + ".avi","Motion JPEG AVI");
%     Writer.FrameRate = 25;
%     open(Writer)
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
% %% Figures only
% % Screen information
% ScreenSizePixels = get(0,'screensize');
% ScreenSizeWidth = ScreenSizePixels(3);
% ScreenSizeHight = ScreenSizePixels(4);
% FigureWidth = BehaviourBoxVideo.Width + MiniscopeVideo.Width;
% FigureHight = FigureWidth/3;
% 
% % Create a figure for plotting
% f = figure(Resize="off");
% f.Position = [(ScreenSizeWidth/2)-(FigureWidth/2),(ScreenSizeHight/2)-(FigureHight/2),FigureWidth,FigureHight];
% 
% for g = 1:size(BorisFrames,1)
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
%     title("ActivityGraph: " + g)
%     xlabel('Time')
%     ylabel('Activity')
%     disp("Exporting graphic: " + g)
%     exportgraphics(f,OutputPath + "\" + "ActivityGraph " + g + ".emf")
% end
% 
% %% Test code
% 
% imax = 100;
% prog = 0;
% fprintf(1,'Computation Progress: %3d%%\n',prog);
% for k = 1:1:imax
% 	prog = ( 100*(k/imax) );
% 	fprintf(1,'\b\b\b\b%3.0f%%',prog); pause(0.1); % Deleting 4 characters (The three digits and the % symbol)
% end
% fprintf('\n'); % To go to a new line after reaching 100% progress
% 
% %% Calculate frame rate
% disp("Calculating frame rate...")
% 
% % Miniscope frame rate
% InterFrameTimeMiniscope = zeros(size(MiniscopeTimeStamps,1)-3,1);
% MiniScopeFrameRate = zeros(size(MiniscopeTimeStamps,1)-3,1);
% for i = 4:size(MiniscopeTimeStamps,1)
%     InterFrameTimeMiniscope(i-3) = MiniscopeTimeStamps{i,2} - MiniscopeTimeStamps{i-1,2};
%     MiniScopeFrameRate(i-3) = 1 / (InterFrameTimeMiniscope(i-3)/1000);
% end
% 
% % Behaviourbox frame rate
% InterFrameTimeBehaviourBox = zeros(size(BehaviourBoxTimeStamps,1)-1,1);
% BehaviourBoxFrameRate = zeros(size(BehaviourBoxTimeStamps,1)-1,1);
% for i = 2:size(BehaviourBoxTimeStamps,1)
%     InterFrameTimeBehaviourBox(i-1) = milliseconds(BehaviourBoxTimeStamps(i) - BehaviourBoxTimeStamps(i-1));
%     BehaviourBoxFrameRate(i-1) = 1 / (InterFrameTimeBehaviourBox(i-1)/1000);
% end
% 
% %% Unused code 
% %% Play video
% f = figure;
% ax_BehaviourBox = subplot(2,2,1);
% ax_Miniscope = subplot(2,2,2);
% ax_Activity = subplot(2,2,3:4);
% h = plot(Activity(1:1000),'r',Parent=ax_Activity);
% xLine_handle = xline(i,Parent=ax_Activity);
% for i = 1:3000
%     % tic
% 
%     % Image show the two video streams
%     FrameMiniscope = read(MiniscopeVideo,i);
%     imshow(FrameMiniscope,Parent=ax_Miniscope);
%     ax_Miniscope.Visible = 'off';
%     FrameBehaviourBox = read(BehaviourBoxVideo,i);
%     imshow(FrameBehaviourBox,Parent=ax_BehaviourBox);
%     ax_BehaviourBox.Visible = 'off';
% 
%     % Move the activity in time
%     if i <= 200
%     delete(xLine_handle)
%     xLine_handle = xline(i,Parent=ax_Activity);
%     else
%         set(h,YData=Activity(i-199:i+800))
%     end
%     % delta = toc;
%     pause((1/60))
% end
%%%%
% 
% %% Fun
% Indx_Change = zeros(size(Indx_MinTimeDifference)-1);
% for i = 1:size(Indx_MinTimeDifference)-1
%     Indx_Change(i) =  Indx_MinTimeDifference(i+1) - Indx_MinTimeDifference(i);
% end
% plot(Indx_Change)