%% Variables
disp("Initializing Variables...")
BehaviourBoxVideo = "S:\Data\Miniscope Behaviour Combo\SC\MI23-05952-05F_SC_Test.avi";
BehaviourBoxTimeStamps = "S:\Data\Miniscope Behaviour Combo\SC\MI23-05952-05F_SC_Test.csv";
MiniscopeVideo = "S:\Data\Miniscope Behaviour Combo\SC\SC_Test\My_V4_Miniscope\MiniscopeGray.Avi";
MiniscopeTimeStamps = "S:\Data\Miniscope Behaviour Combo\SC\SC_Test\My_V4_Miniscope\timeStamps.csv";
MiniscopeMetaData = "S:\Data\Miniscope Behaviour Combo\SC\SC_Test\metaData.json";

BorisTimeStamps = "S:\Data\Miniscope Behaviour Combo\SC\BorisResultsSCMouse05F.xlsx";

OutputPath = "S:\Behaviour Miniscope Combo\SC\Output";

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

Boris.begin = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Begin'));
Boris.Walking = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Walking'));
Boris.SniffingL = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'SniffingL'));
Boris.SniffingR = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'SniffingR'));
Boris.Grooming = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Grooming'));
Boris.Sitting = BorisTimeStamps.ImageIndex(contains(BorisTimeStamps.Behavior,'Sitting'));

%% Find the start of the Behaviour video
disp("Finding the smallest time differance between the videos...")

StartTimeBehaviourVideo = BehaviourBoxTimeStamps(Boris.begin);
TimeDifference = zeros(size(MiniscopeAbsTime,1),1);
MinTimeDifference = zeros(size(BehaviourBoxTimeStamps,1),1);
Indx_MinTimeDifference = zeros(size(BehaviourBoxTimeStamps,1),1);
for i = 1:size(BehaviourBoxTimeStamps,1)
    TimeDifference = milliseconds(abs(MiniscopeAbsTime - BehaviourBoxTimeStamps(i)));
    [MinTimeDifference(i), Indx_MinTimeDifference(i)] = min(TimeDifference);
end
disp("Done finding the minimal time differences")

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
AUCs.SniffingL = zeros(size(Boris.SniffingL,1)/2,1);
AUCs.SniffingR = zeros(size(Boris.SniffingR,1)/2,1);
AUCs.Grooming = zeros(size(Boris.Grooming,1)/2,1);
AUCs.Sitting = zeros(size(Boris.Sitting,1)/2,1);

for Behaviour = ["Walking" "SniffingL" "SniffingR" "Grooming" "Sitting"]
k = 1;
for i = 1:2:size(Boris.(Behaviour),1)
    BeginBehaviour = Boris.(Behaviour)(i);
    EndBehaviour = Boris.(Behaviour)(i+1);
    AUC = trapz(SyncedActivity(BeginBehaviour:EndBehaviour));
    AUCs.(Behaviour)(k) = AUC / length(BeginBehaviour:EndBehaviour);
    k = k + 1;
end
end

%% Unused
% figure
% k = 1;
% for i = 1:2:size(BorisFrames.Sniffing,1)
%     StartBehaviour = Indx_MinTimeDifference(BorisFrames.Sniffing(i));
%     EndBehaviour = Indx_MinTimeDifference(BorisFrames.Sniffing(i+1));
%     AUCSniffing(k,1) = trapz(Activity(StartBehaviour-49:StartBehaviour)) / 50;
%     AUCSniffing(k,2) = trapz(Activity(StartBehaviour:EndBehaviour)) / (EndBehaviour - StartBehaviour);
%     AUCSniffing(k,3) = trapz(Activity(EndBehaviour:EndBehaviour+49)) / 50;
%     subplot(6,6,k)
%     plot(Activity(StartBehaviour-49:EndBehaviour+49));
%     xline(49,'-')
%     xline(((EndBehaviour - StartBehaviour) / 2) + 49,'-')
%     xline(size(StartBehaviour:EndBehaviour,2) + 49,'-')
%     k = k+1;
% end
% disp("Done")
% 
% %% Check
% 
% Mean_AUCSniffing = mean(AUCSniffing);
% Mean_AUCWalking = mean(AUCWalking);
% 
% %% Combination plot
% f = figure;
% hold on
% Filter = 70;
% for i = 1:2:size(BorisFrames.Walking,1)
%     StartBehaviour = Indx_MinTimeDifference(BorisFrames.Walking(i));
%     EndBehaviour = Indx_MinTimeDifference(BorisFrames.Walking(i+1));
%     HighestValuePreBehaviour = max(Activity(StartBehaviour-100:StartBehaviour));
%     if HighestValuePreBehaviour >= Filter
%         continue
%     else
%         plot(Activity(StartBehaviour-100:EndBehaviour+100));
%     end
% end
% xlim([0 200])
% xline(100,'-')
% %exportgraphics(f,"S:\Alltraces.emf")
% 
% 
% %% Check everything
% 
% plot(Activity)
% for i = 1:size(BorisFrames.Walking,1)
%     if mod(i,2) == 0
%         xline(Indx_MinTimeDifference(BorisFrames.Walking(i)))
%     else
%         xline(Indx_MinTimeDifference(BorisFrames.Walking(i)),'-',"Walking")
%     end
% end
% for i = 1:size(BorisFrames.Sniffing,1)
%     if mod(i,2) == 0
%         xline(Indx_MinTimeDifference(BorisFrames.Sniffing(i)))
%     else
%         xline(Indx_MinTimeDifference(BorisFrames.Sniffing(i)),'-',"Sniffing")
%     end
% end