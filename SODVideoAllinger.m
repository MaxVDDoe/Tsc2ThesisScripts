%% Variables
disp("Initializing Variables...")
BehaviourBoxDir = "S:\Data\Miniscope Behaviour Combo\OLF";
BorisTimeStamps = "S:\Data\Miniscope Behaviour Combo\OLF\BorisResultsOLFMouse05F.xlsx";

MiniscopeVideo = "S:\Data\Miniscope Behaviour Combo\OLF\MiniscopeGray.Avi";

MiniscopeVideo1BeginTime = "S:\Data\Miniscope Behaviour Combo\OLF\2024_03_13\16_00_53\metaData.json";
MiniscopeVideo1TimeStamps = "S:\Data\Miniscope Behaviour Combo\OLF\2024_03_13\16_00_53\My_V4_Miniscope\timeStamps.csv";

MiniscopeVideo2BeginTime = "S:\Data\Miniscope Behaviour Combo\OLF\2024_03_13\16_30_33\metaData.json";
MiniscopeVideo2TimeStamps = "S:\Data\Miniscope Behaviour Combo\OLF\2024_03_13\16_30_33\My_V4_Miniscope\timeStamps.csv";

OutputPath = "S:\Data\Miniscope Behaviour Combo\OLF\Output";

%% Loading...
disp("Loading Data...")
% Behavior Box
BehaviourBoxVideosDir = dir(BehaviourBoxDir + "\*avi");
BehaviourBoxTimeStampsDir = dir(BehaviourBoxDir + "\*csv");

%Boris time stamps
BorisTimeStamps = readtable(BorisTimeStamps);

% Miniscope Videos
MiniscopeVideo = VideoReader(MiniscopeVideo);

% Miniscope TimeStamps
MiniscopeVideo1BeginTime = readstruct(MiniscopeVideo1BeginTime);
MiniscopeVideo1TimeStamps = readcell(MiniscopeVideo1TimeStamps,"Delimiter",",");
MiniscopeVideo2BeginTime = readstruct(MiniscopeVideo2BeginTime);
MiniscopeVideo2TimeStamps = readcell(MiniscopeVideo2TimeStamps,"Delimiter",",");

%% Transform time stamps
% Behaviour Box
Order = ["Water1" "Water2" "Water3" "Almond1" "Almond2" "Almond3" "Citron1" "Citron2" "Citron3" "Home1" "Home2" "Home3" "Same1" "Same2" "Same3" "Diff1" "Diff2" "Diff3"];

BehaviourBoxTimeStamps = [];
for i = Order
    Indx = find(contains({BehaviourBoxTimeStampsDir.name},i)==1);
    Temp = readtimetable(BehaviourBoxTimeStampsDir(Indx).folder + "\" + BehaviourBoxTimeStampsDir(Indx).name);
    BehaviourBoxTimeStamps = [BehaviourBoxTimeStamps; Temp.Time];
end

% Miniscope
MiniscopeVideo1BeginTime = datetime(MiniscopeVideo1BeginTime.recordingStartTime.year, ...
                     MiniscopeVideo1BeginTime.recordingStartTime.month, ...
                     MiniscopeVideo1BeginTime.recordingStartTime.day, ...
                     MiniscopeVideo1BeginTime.recordingStartTime.hour, ...
                     MiniscopeVideo1BeginTime.recordingStartTime.minute, ...
                     MiniscopeVideo1BeginTime.recordingStartTime.second, ...
                     MiniscopeVideo1BeginTime.recordingStartTime.msec,"Format","dd-MMM-uuuu HH:mm:ss.SSS");
MiniscopeVideo1AbsTime = cell(size(MiniscopeVideo1TimeStamps,1)-1,1);
for i = 1:size(MiniscopeVideo1TimeStamps,1)-1
    MiniscopeVideo1AbsTime{i} = MiniscopeVideo1BeginTime + milliseconds(MiniscopeVideo1TimeStamps{i+1,2});
end
MiniscopeVideo1AbsTime = [MiniscopeVideo1AbsTime{:}]';

MiniscopeVideo2BeginTime = datetime(MiniscopeVideo2BeginTime.recordingStartTime.year, ...
                     MiniscopeVideo2BeginTime.recordingStartTime.month, ...
                     MiniscopeVideo2BeginTime.recordingStartTime.day, ...
                     MiniscopeVideo2BeginTime.recordingStartTime.hour, ...
                     MiniscopeVideo2BeginTime.recordingStartTime.minute, ...
                     MiniscopeVideo2BeginTime.recordingStartTime.second, ...
                     MiniscopeVideo2BeginTime.recordingStartTime.msec,"Format","dd-MMM-uuuu HH:mm:ss.SSS");
MiniscopeVideo2AbsTime = cell(size(MiniscopeVideo2TimeStamps,1)-1,1);
for i = 1:size(MiniscopeVideo2TimeStamps,1)-1
    MiniscopeVideo2AbsTime{i} = MiniscopeVideo2BeginTime + milliseconds(MiniscopeVideo2TimeStamps{i+1,2});
end
MiniscopeVideo2AbsTime = [MiniscopeVideo2AbsTime{:}]';

MiniscopeVideoAbsTime = [MiniscopeVideo1AbsTime; MiniscopeVideo2AbsTime];

% Boris Frames
Order = ["Water1" "Water2" "Water3" "Almond1" "Almond2" "Almond3" "Citron1" "Citron2" "Citron3" "Home1" "Home2" "Home3" "Same1" "Same2" "Same3" "Diff1" "Diff2" "Diff3"];
BorisFrames = cell(size(BorisTimeStamps,1),3);

for i = 1:size(BorisTimeStamps,1)
    ConditionName = split(BorisTimeStamps.MediaFileName{i},'_');
    ConditionName = split(ConditionName(end),'.');
    BorisFrames(i,1) = ConditionName(1);
    MultipleFactor = find(contains(Order,ConditionName(1))==1);
    BorisFrames(i,2) = BorisTimeStamps.BehaviorType(i);
    BorisFrames{i,3} = BorisTimeStamps.ImageIndex(i) + (3750 * (MultipleFactor-1));
end

Boris.Water = BorisFrames(contains(BorisFrames(:,1),"Water")==1&~contains(BorisFrames(:,2),"POINT"),3);
Boris.Almond = BorisFrames(contains(BorisFrames(:,1),"Almond")==1&~contains(BorisFrames(:,2),"POINT"),3);
Boris.Citron = BorisFrames(contains(BorisFrames(:,1),"Citron")==1&~contains(BorisFrames(:,2),"POINT"),3);
Boris.Home = BorisFrames(contains(BorisFrames(:,1),"Home")==1&~contains(BorisFrames(:,2),"POINT"),3);
Boris.Same = BorisFrames(contains(BorisFrames(:,1),"Same")==1&~contains(BorisFrames(:,2),"POINT"),3);
Boris.Diff = BorisFrames(contains(BorisFrames(:,1),"Diff")==1&~contains(BorisFrames(:,2),"POINT"),3);

%% Find the start of the Behaviour video
disp("Finding the smallest time differance between the videos...")
%MinTimeDifference = zeros(size(BehaviourBoxTimeStamps,1),1);
Indx_MinTimeDifference = zeros(size(BehaviourBoxTimeStamps,1),1);
for i = 1:size(BehaviourBoxTimeStamps,1)
    TimeDifference = milliseconds(abs(MiniscopeVideoAbsTime - BehaviourBoxTimeStamps(i)));
    [~, Indx_MinTimeDifference(i)] = min(TimeDifference);
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
AUC.Water = zeros((length(find(contains(BorisFrames(:,1),"Water")==1))-3)/2,1);
AUC.Almond = zeros((length(find(contains(BorisFrames(:,1),"Almond")==1))-3)/2,1);
AUC.Citron = zeros((length(find(contains(BorisFrames(:,1),"Citron")==1))-3)/2,1);
AUC.Home = zeros((length(find(contains(BorisFrames(:,1),"Home")==1))-3)/2,1);
AUC.Same = zeros((length(find(contains(BorisFrames(:,1),"Same")==1))-3)/2,1);
AUC.Diff = zeros((length(find(contains(BorisFrames(:,1),"Diff")==1))-3)/2,1);

for Behaviour = ["Water" "Almond" "Citron" "Home" "Same" "Diff"]
k = 1;
for i = 1:2:size(Boris.(Behaviour),1)
    BeginBehaviour = Boris.(Behaviour){i};
    EndBehaviour = Boris.(Behaviour){i+1};
    AUC = trapz(SyncedActivity(BeginBehaviour:EndBehaviour));
    AUCs.(Behaviour)(k) = AUC / length(BeginBehaviour:EndBehaviour);
    k = k + 1;
end
end

%% Traces
f = figure;
hold on

Behaviour = "Almond";
AllTraces = zeros(length(1:2:length(Boris.(Behaviour))),100);
k = 1;
for i = 1:2:length(Boris.(Behaviour))
    BeginBehaviour = Boris.(Behaviour){i};
    EndBehaviour = BeginBehaviour + 50;
    AllTraces(k,:) = SyncedActivity((BeginBehaviour-49):EndBehaviour);
    k = k + 1;
end

Behaviour = "Citron";
AllTraces = [AllTraces; zeros(length(1:2:length(Boris.(Behaviour))),100)];
for i = 1:2:length(Boris.(Behaviour))
    BeginBehaviour = Boris.(Behaviour){i};
    EndBehaviour = BeginBehaviour + 50;
    AllTraces(k,:) = SyncedActivity((BeginBehaviour-49):EndBehaviour);
    k = k + 1;
end

% Behaviour = "Diff";
% AllTraces = [AllTraces; zeros(length(1:2:length(Boris.(Behaviour))),100)];
% for i = 1:2:length(Boris.(Behaviour))
%     BeginBehaviour = Boris.(Behaviour){i};
%     EndBehaviour = BeginBehaviour + 50;
%     AllTraces(k,:) = SyncedActivity((BeginBehaviour-49):EndBehaviour);
%     k = k + 1;
% end

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
title("Mean of all traces before and during Social Smells")
xline(50)
hold off