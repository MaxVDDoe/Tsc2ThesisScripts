%% Variable initialization
Path = 'S:\Data\Max_van_der_Doe\Testing\Furr_Ball\customEntValHere';
TiffFileName = 'MI23-05952-05_2_08-03-2024.tiff';

%% Excecution
% get directory information
disp('Looking for files')
DirPath = uigetdir(Path);
Dir = dir([DirPath '\*avi']);
disp(strcat("Found ", string(length(Dir)), " Video files:"))
for k = 1:length(Dir)
    disp(['  ' Dir(k).name])
end

% Set up the tiff object
disp('Setting up TIFF object')
t = Tiff([Path '\' TiffFileName],"w");

tagstruct.ImageLength = 600;
tagstruct.ImageWidth = 600;
tagstruct.BitsPerSample = 8;
tagstruct.SamplesPerPixel = 1;
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.Compression = Tiff.Compression.PackBits;
tagstruct.Software = 'MATLAB';
setTag(t,tagstruct)

%% Save the image's
disp('Saving TIFF Files')
for k = 1:length(Dir)
    disp(strcat("opening file ", string(k), "/", string(length(Dir)), ": ", string(Dir(k).name)));
    v = VideoReader([Dir(k).folder '\' Dir(k).name]);
    Frame = readFrame(v);
    Frame = rgb2gray(Frame);
    write(t,squeeze(im2uint8(Frame)));
    while hasFrame(v)
        Frame = readFrame(v);
        Frame = rgb2gray(Frame);
        writeDirectory(t);
        setTag(t,tagstruct);
        write(t,squeeze(im2uint8(Frame)));
    end
end
close(t)