function Mice = JsonGenerator(Path, MasterSheet)
    %% Loading in all the data
    % Supress annoyng warnings
    warning('off','MATLAB:table:ModifiedAndSavedVarnames')
    disp('Loading mice...')
    MiceData = readtable([Path MasterSheet],Sheet='Mice',Range='B:K');
    disp('Loading meta mice...')
    MetaData = readtable([Path MasterSheet], Sheet='Behaviour', Range='B:S');
    disp('Loading Open Field...')
    OFData = readtable([Path MasterSheet], Sheet='OF Results', Range='A:H');
    disp('Loading Elevated Plus Maze...')
    EPMData = readtable([Path MasterSheet], Sheet='EPM Results', Range='A:H');
    disp('Loading Social Chamber...')
    SCNData = readtable([Path MasterSheet], Sheet='SCN Results', Range='A:I');
    disp('Loading Affective State...')
    ADTData = readtable([Path MasterSheet], Sheet="ADT Results", Range='A:N');
    disp('Loading Grooming data...')
    GroomingData = readtable([Path MasterSheet],Sheet='Grooming Results',Range='B:I');
    disp('Loading Grooming meta data')
    GroomingMetaData = readtable([Path MasterSheet],Sheet='Grooming Times',Range='B:F');
    disp('Loading Sniffing data...')
    SniffingData = readtable([Path, MasterSheet], Sheet='Sniffing Results', Range='A:E');
    %% Creating the struct
    disp('Creating mice struct...')
    for i = 1:size(MiceData.Mouse_Number,1)
        CurrentMouse = matlab.lang.makeValidName(MiceData.Mouse_Number{i});
        disp(strcat("Mouse ", CurrentMouse, " is being processed"))
        Mice.(CurrentMouse).MouseName = MiceData.Mouse_Number{i};
        Mice.(CurrentMouse).Sex = MiceData.Sex{i};
        Mice.(CurrentMouse).Strain = MiceData.Strain{i};
        Mice.(CurrentMouse).Genotype = MiceData.Genotype{i};
        Mice.(CurrentMouse).DateOfBirth = MiceData.DOB(i);
        
        if isnat(MiceData.DateEuthanized(i))
            Mice.(CurrentMouse).AgeDays = caldays(between(MiceData.DOB(62), datetime('today'), "days"));
            Mice.(CurrentMouse).AgeWeeks = calweeks(between(MiceData.DOB(62), datetime('today'), "weeks"));
            Mice.(CurrentMouse).DateOfEuthanasia = 'Alive';
        else
            Mice.(CurrentMouse).AgeDays = caldays(between(MiceData.DOB(62), MiceData.DateEuthanized(i), "days"));
            Mice.(CurrentMouse).AgeWeeks = calweeks(between(MiceData.DOB(62), MiceData.DateEuthanized(i), "weeks"));
            Mice.(CurrentMouse).DateOfEuthanasia = MiceData.DateEuthanized(i);
        end
    end
    
    %% Add OF Date to the struct
    disp('Adding Open field data...')
    for CurrentMouse = string(fieldnames(Mice))'
        [Found,indx] = ismember(Mice.(CurrentMouse).MouseName, OFData.MouseName);
        if Found
            Mice.(CurrentMouse).OpenField.TotalCmTravelled = OFData.TotalCmTravelled(indx);
            Mice.(CurrentMouse).OpenField.MeanBodySpeed = OFData.MeanBodySpeed(indx);
            Mice.(CurrentMouse).OpenField.MedianBodySpeed = OFData.MedianBodySpeed(indx);
            Mice.(CurrentMouse).OpenField.NumberOfGoodFrames = OFData.NumberOfGoodFrames(indx);
            Mice.(CurrentMouse).OpenField.ZoneName = OFData.ZoneNames(indx:indx+5);
            Mice.(CurrentMouse).OpenField.Totalframes = OFData.TotalFrames(indx:indx+5);
            Mice.(CurrentMouse).OpenField.TotalTime = OFData.TotalTime(indx:indx+5);
        else
            disp(strcat('Openfield data of ', CurrentMouse, ' could not be found'))
        end
    end

    %% Add EPM Date to the struct
    disp('Adding Elevated Plus Maze data...')
    for CurrentMouse = string(fieldnames(Mice))'
        [Found,indx] = ismember(Mice.(CurrentMouse).MouseName, EPMData.MouseName);
        if Found
            Mice.(CurrentMouse).ElevatedPlusMaze.TotalCmTravelled = EPMData.TotalCmTravelled(indx);
            Mice.(CurrentMouse).ElevatedPlusMaze.MeanBodySpeed = EPMData.MeanBodySpeed(indx);
            Mice.(CurrentMouse).ElevatedPlusMaze.MedianBodySpeed = EPMData.MedianBodySpeed(indx);
            Mice.(CurrentMouse).ElevatedPlusMaze.NumberOfGoodFrames = EPMData.NumberOfGoodFrames(indx);
            Mice.(CurrentMouse).ElevatedPlusMaze.ZoneName = EPMData.ZoneNames(indx:indx+4);
            Mice.(CurrentMouse).ElevatedPlusMaze.Totalframes = EPMData.TotalFrames(indx:indx+4);
            Mice.(CurrentMouse).ElevatedPlusMaze.TotalTime = EPMData.TotalTime(indx:indx+4);
        else
            disp(strcat('Elevated plus maze data of ', CurrentMouse, ' could not be found'))
        end
    end
    %% Add SCN Date to the struct
    disp('Adding Social Chamber data...')
    for CurrentMouse = string(fieldnames(Mice))'
        [Found,indx] = ismember(Mice.(CurrentMouse).MouseName,SCNData.MouseName);
        ChamberIndx = indx + 10;
        NoveltyIndx = indx + 3;
        if Found
            Mice.(CurrentMouse).SocialChamber.TotalCmTravelled = SCNData.TotalCmTravelled(ChamberIndx);
            Mice.(CurrentMouse).SocialChamber.MeanBodySpeed = SCNData.MeanBodySpeed(ChamberIndx);
            Mice.(CurrentMouse).SocialChamber.MedianBodySpeed = SCNData.MedianBodySpeed(ChamberIndx);
            Mice.(CurrentMouse).SocialChamber.NumberOfGoodFrames = SCNData.NumberOfGoodFrames(ChamberIndx);
            Mice.(CurrentMouse).SocialChamber.ZoneName = SCNData.ZoneNames(ChamberIndx:ChamberIndx+6);
            Mice.(CurrentMouse).SocialChamber.Totalframes = SCNData.TotalFrames(ChamberIndx:ChamberIndx+6);
            Mice.(CurrentMouse).SocialChamber.TotalTime = SCNData.TotalTime(ChamberIndx:ChamberIndx+6);
            
            Mice.(CurrentMouse).SocialNovelty.TotalCmTravelled = SCNData.TotalCmTravelled(NoveltyIndx);
            Mice.(CurrentMouse).SocialNovelty.MeanBodySpeed = SCNData.MeanBodySpeed(NoveltyIndx);
            Mice.(CurrentMouse).SocialNovelty.MedianBodySpeed = SCNData.MedianBodySpeed(NoveltyIndx);
            Mice.(CurrentMouse).SocialNovelty.NumberOfGoodFrames = SCNData.NumberOfGoodFrames(NoveltyIndx);
            Mice.(CurrentMouse).SocialNovelty.ZoneName = SCNData.ZoneNames(NoveltyIndx:NoveltyIndx+6);
            Mice.(CurrentMouse).SocialNovelty.Totalframes = SCNData.TotalFrames(NoveltyIndx:NoveltyIndx+6);
            Mice.(CurrentMouse).SocialNovelty.TotalTime = SCNData.TotalTime(NoveltyIndx:NoveltyIndx+6);
            [Found,indx] = ismember(Mice.(CurrentMouse).MouseName,MetaData.Var1);
            if Found
                Mice.(CurrentMouse).SocialChamber.Stranger = MetaData.Var5{indx};
                Mice.(CurrentMouse).SocialNovelty.Stranger = MetaData.Var7{indx};
            else
                disp(strcat('Social Chamber stranger data of ', CurrentMouse, ' could not be found'))
            end
        else
            disp(strcat('Social Chamber data of ', CurrentMouse, ' could not be found'))
        end
        
    end

    %% Add ADT Date to the struct
    disp('Adding Affective state data...')
    for CurrentMouse = string(fieldnames(Mice))'
        [Found,indx] = ismember(Mice.(CurrentMouse).MouseName, ADTData.MouseName);
        indx = indx + 3;
        if Found
            Mice.(CurrentMouse).AffectiveState.TotalCmTravelled = ADTData.TotalCmTravelled(indx);
            Mice.(CurrentMouse).AffectiveState.MeanBodySpeed = ADTData.MeanBodySpeed(indx);
            Mice.(CurrentMouse).AffectiveState.MedianBodySpeed = ADTData.MedianBodySpeed(indx);
            Mice.(CurrentMouse).AffectiveState.NumberOfGoodFrames = ADTData.NumberOfGoodFrames(indx);
            Mice.(CurrentMouse).AffectiveState.ZoneName = ADTData.ZoneNames(indx:indx+6);
            Mice.(CurrentMouse).AffectiveState.Totalframes = ADTData.TotalFrames(indx:indx+6);
            Mice.(CurrentMouse).AffectiveState.TotalTime = ADTData.TotalTime(indx:indx+6);
            [Found,indx] = ismember(Mice.(CurrentMouse).MouseName,MetaData.Var1);
            if Found
                Mice.(CurrentMouse).AffectiveState.Stranger = MetaData.Var16{indx};
            else
                disp(strcat('Affective State stranger data of ', CurrentMouse, ' could not be found'))
            end
        else
            disp(strcat('Affctive State data of ', CurrentMouse, ' could not be found'))
        end
    end

    %% Add Grooming data to the struct
    disp('Adding Grooming data...')
    for CurrentMouse = string(fieldnames(Mice))'
        [Found] = ismember(Mice.(CurrentMouse).MouseName, GroomingData.MouseName);
        if Found
            Data = GroomingData(strcmp(GroomingData.MouseName,Mice.(CurrentMouse).MouseName),:);
            Mice.(CurrentMouse).Grooming.Times = Data.Time;
            Mice.(CurrentMouse).Grooming.Frames = Data.FrameIndex;
            Mice.(CurrentMouse).Grooming.StartStop = Data.Status;
        else
            disp(strcat('Grooming data of ', CurrentMouse, ' could not be found'))
        end
    end

    %% Add Meta Grooming data
    disp('Adding Grooming meta data...')
    for CurrentMouse = string(fieldnames(Mice))'
        [Found,indx] = ismember(Mice.(CurrentMouse).MouseName, GroomingMetaData.MouseName);
        if Found
            Mice.(CurrentMouse).Grooming.VideoStartFrame = GroomingMetaData.VideoStartFrame(indx);
            Mice.(CurrentMouse).Grooming.TestStartFrame = GroomingMetaData.TestStartFrame(indx);
            Mice.(CurrentMouse).Grooming.TestEndFrame = GroomingMetaData.TestEndFrame(indx);
            Mice.(CurrentMouse).Grooming.VideoEndFrame = GroomingMetaData.VideoEndFrame(indx);
        else
            disp(strcat('Grooming data of ', CurrentMouse, ' could not be found'))
        end
    end

    %% Add Sniffing data to the struct
    disp('Adding Sniffing data...')
    for CurrentMouse = string(fieldnames(Mice))'
        [Found] = ismember(Mice.(CurrentMouse).MouseName, SniffingData.MouseName);
        if Found
            Data = SniffingData(strcmp(SniffingData.MouseName,Mice.(CurrentMouse).MouseName),:);
            Mice.(CurrentMouse).Sniffing.Times = Data.Time;
            Mice.(CurrentMouse).Sniffing.Condition = Data.Condition;
            Mice.(CurrentMouse).Sniffing.StartStop = Data.StartStop;
        else
            disp(strcat("Sniffing data of ", CurrentMouse, " could not be found"))
        end
    end

    %% Write Struct
    disp('Writing Struct to disk...')
    writestruct(Mice,[Path 'Mice.json'])
end
















