function Mice = AddBorisData(Mice, Data, Test)
AllMice = fieldnames(Mice);
for CurrentMouse = string(AllMice)'
    if ismember(Mice.(CurrentMouse).MouseName, Data.MouseName)
        Mice.(CurrentMouse).(Test).Table = Data(strcmp(Data.MouseName, Mice.(CurrentMouse).MouseName),:);
    else
        disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Does not have a ' char(Test) ' dataset'])
    end
end
end
