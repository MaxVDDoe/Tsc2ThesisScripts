MiniscopeVideo = "S:\Data\Miniscope Behaviour Combo\OLF\2024_03_13\16_30_33\My_V4_Miniscope\0.avi";
MiniscopeVideo = VideoReader(MiniscopeVideo);

v = VideoWriter("S:\Data\Miniscope Behaviour Combo\OLF\2024_03_13\16_30_33\My_V4_Miniscope\MiniscopeGray.Avi","Grayscale AVI");
open(v)

while hasFrame(MiniscopeVideo)
    Frame = rgb2gray(readFrame(MiniscopeVideo));
    writeVideo(v,Frame)
end

close(v)
disp("Done!")

%%

MiniscopeVideo1 = "S:\Data\Miniscope Behaviour Combo\OLF\2024_03_13\16_00_53\My_V4_Miniscope\MiniscopeGray.Avi";
MiniscopeVideo2 = "S:\Data\Miniscope Behaviour Combo\OLF\2024_03_13\16_30_33\My_V4_Miniscope\MiniscopeGray.Avi";

MiniscopeVideo1 = VideoReader(MiniscopeVideo1);
MiniscopeVideo2 = VideoReader(MiniscopeVideo2);

v = VideoWriter("S:\Data\Miniscope Behaviour Combo\OLF\MiniscopeGray.Avi","Grayscale AVI");
open(v)
disp("Video1")
while hasFrame(MiniscopeVideo1)
    Frame = readFrame(MiniscopeVideo1);
    writeVideo(v,Frame)
end
disp("Video2")
while hasFrame(MiniscopeVideo2)
    Frame = readFrame(MiniscopeVideo2);
    writeVideo(v,Frame)
end

close(v)
disp("Done!")

