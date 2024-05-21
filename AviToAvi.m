Path = "S:\Data\Miniscope Behaviour Combo\OF\MI23-05952-05F\Miniscope Recording\14_44_39\My_V4_Miniscope";

% get directory information
disp('Looking for files')
DirPath = Path;
Dir = dir(DirPath + "\*avi");
disp("Found " + length(Dir) + " Video files:")
for k = 1:length(Dir)
    disp(['  ' Dir(k).name])
end

%% Set up the Videowriter object
v = VideoWriter(Path + "\Merged.Avi","Grayscale AVI");
open(v)

%% Write Files to disk
for File = 0:size(Dir,1)-1
    disp("Video file: " + File + ".avi")
    [~, FileIndex] = ismember(File + ".avi", {Dir.name});
    Vid = VideoReader([Dir(FileIndex).folder '\' Dir(FileIndex).name]);
    
    disp("Writing frames")
    while hasFrame(Vid)
        Frame = rgb2gray(readFrame(Vid));
        writeVideo(v,Frame)
    end
end

close(v)
disp("Done!")