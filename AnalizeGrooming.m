function Mice = AnalizeGrooming(Mice)

for CurrentMouse = string(fieldnames(Mice))'
    
    if isfield(Mice.(CurrentMouse), 'Grooming')
        Mice.(CurrentMouse).Grooming.OffSetFrames = Mice.(CurrentMouse).Grooming.Frames - Mice.(CurrentMouse).Grooming.VideoStartFrame;
        Mice.(CurrentMouse).Grooming.Bouts = [];
        Mice.(CurrentMouse).Grooming.OverTime = zeros(1,45749);
        for i = 2:2:size(Mice.(CurrentMouse).Grooming.OffSetFrames)
            Mice.(CurrentMouse).Grooming.Bouts = [Mice.(CurrentMouse).Grooming.Bouts (Mice.(CurrentMouse).Grooming.OffSetFrames(i) - Mice.(CurrentMouse).Grooming.OffSetFrames(i-1))];
            Mice.(CurrentMouse).Grooming.OverTime(Mice.(CurrentMouse).Grooming.OffSetFrames(i-1):Mice.(CurrentMouse).Grooming.OffSetFrames(i)) = 1;
        end
        Mice.(CurrentMouse).Grooming.TotalFrames = sum(Mice.(CurrentMouse).Grooming.Bouts);
        Mice.(CurrentMouse).Grooming.AverageLength = mean(Mice.(CurrentMouse).Grooming.Bouts);
        Mice.(CurrentMouse).Grooming.NumberOfBouts = size(Mice.(CurrentMouse).Grooming.Bouts,2);
        Mice.(CurrentMouse).Grooming.ShortBouts = size(Mice.(CurrentMouse).Grooming.Bouts(:,Mice.(CurrentMouse).Grooming.Bouts<=25),2);
        Mice.(CurrentMouse).Grooming.LongBouts = size(Mice.(CurrentMouse).Grooming.Bouts(:,Mice.(CurrentMouse).Grooming.Bouts>25),2);
        
    else
        disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Does not have a grooming dataset'])
    end
end