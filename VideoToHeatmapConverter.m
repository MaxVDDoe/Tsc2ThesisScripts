%% Loading...
disp("Loading Data...")
MiniscopeVideo = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\My_V4_Miniscope\Merged.Avi";
MiniscopeVideo = VideoReader(MiniscopeVideo);
VideoNumFrames = MiniscopeVideo.NumFrames;
Activity = zeros(VideoNumFrames,1);
parfor i = 1:VideoNumFrames
    disp(i + " / " + VideoNumFrames)
    Activity(i) = mean(read(MiniscopeVideo,i),"all")
end

[MinimalValue, MinimalIndex] = min(Activity);
[MaximalValue, MaximalIndex] = max(Activity);

disp("Minimal value found was: "+MinimalValue+" At Index: "+MinimalIndex)
disp("Maximal value found was: "+MaximalValue+" At Index: "+MaximalIndex)

MinimalFrame = read(MiniscopeVideo,MinimalIndex);
MaximalFrame = read(MiniscopeVideo, MaximalIndex);

%% Make images
MinimalFigure = figure;
imshow(MinimalFrame);
colormap("jet");
colorbar;
MinimalColor = getframe(gcf);
imwrite(MinimalColor.cdata,"S:\OpenfieldMinimalColormap.jpeg");

MaximalFigure = figure;
imshow(MaximalFrame);
colormap("jet");
colorbar;
MaximalColor = getframe(gcf);
imwrite(MaximalColor.cdata,"S:\OpenfieldMaximalColormap.jpeg");

%% Convert Full Video to heat map

disp("Loading Data...")
MiniscopeVideo = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\My_V4_Miniscope\Merged.Avi";
MiniscopeVideo = VideoReader(MiniscopeVideo);
MiniscopeVideoWriter = VideoWriter("S:\OpenFieldColoured.Avi","Motion JPEG AVI");
open(MiniscopeVideoWriter)

VideoNumFrames = MiniscopeVideo.NumFrames;
ChuckSize = 50;
VideoLength = 450000;

colorFrames = zeros(600,600,3,ChuckSize);

for i = 1:ChuckSize:VideoLength
    disp("Chuck "+i+" Reading")
    for j = i:i+ChuckSize-1
        frame = read(MiniscopeVideo,j);
        colorFrames(:,:,:,j-(i-1)) = ind2rgb(frame,jet);
    end
    disp("Writing "+i+" Writting")
    writeVideo(MiniscopeVideoWriter,colorFrames)
end

close(MiniscopeVideoWriter)