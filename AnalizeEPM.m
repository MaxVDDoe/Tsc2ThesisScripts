function [ElevatedPlusMaze, Mice] = AnalizeEPM(Mice)
%% Variable initialization
% This for loop will create the Elevated Plus maze variable
% ["WT", "Het"] will make it loop twice, one time to create the Wildtype
% varable, the second time to create the Heterozygous variable
for Genotype = ["WT", "Het"]
    ElevatedPlusMaze.(Genotype).Open = [];
    ElevatedPlusMaze.(Genotype).Closed = [];
    ElevatedPlusMaze.(Genotype).Middle = [];
    ElevatedPlusMaze.(Genotype).Distance = [];
    ElevatedPlusMaze.(Genotype).Speed = [];
    ElevatedPlusMaze.(Genotype).RatioOpenClosed = [];
    ElevatedPlusMaze.(Genotype).RatioClosedOpen = [];
    ElevatedPlusMaze.(Genotype).RowNames = {};
    ElevatedPlusMaze.(Genotype).VariableNames = {'Open','Middle','Closed','Distance','Speed','RatioOpenClosed','RatioClosedOpen'};

    ElevatedPlusMaze.Male.(Genotype).Open = [];
    ElevatedPlusMaze.Male.(Genotype).Closed = [];
    ElevatedPlusMaze.Male.(Genotype).Middle = [];
    ElevatedPlusMaze.Male.(Genotype).Distance = [];
    ElevatedPlusMaze.Male.(Genotype).Speed = [];
    ElevatedPlusMaze.Male.(Genotype).RatioOpenClosed = [];
    ElevatedPlusMaze.Male.(Genotype).RatioClosedOpen = [];
    ElevatedPlusMaze.Male.(Genotype).RowNames = {};
    ElevatedPlusMaze.Male.(Genotype).VariableNames = {'Open','Middle','Closed','Distance','Speed','RatioOpenClosed','RatioClosedOpen'};

    ElevatedPlusMaze.Female.(Genotype).Open = [];
    ElevatedPlusMaze.Female.(Genotype).Closed = [];
    ElevatedPlusMaze.Female.(Genotype).Middle = [];
    ElevatedPlusMaze.Female.(Genotype).Distance = [];
    ElevatedPlusMaze.Female.(Genotype).Speed = [];
    ElevatedPlusMaze.Female.(Genotype).RatioOpenClosed = [];
    ElevatedPlusMaze.Female.(Genotype).RatioClosedOpen = [];
    ElevatedPlusMaze.Female.(Genotype).RowNames = {};
    ElevatedPlusMaze.Female.(Genotype).VariableNames = {'Open','Middle','Closed','Distance','Speed','RatioOpenClosed','RatioClosedOpen'};
end

%% Calculate 
% Here it lopps over all mice within the Mice variable
for CurrentMouse = string(fieldnames(Mice))'

    % First we test if there is a genotype associated with the current
    % mouse that is being tested. When true we store That variable for later
    if isfield(Mice.(CurrentMouse), 'Genotype')
        Genotype = Mice.(CurrentMouse).Genotype;

        % Next we test if this mouse has a Elevated plus maze data set
        % associated with it
        if isfield(Mice.(CurrentMouse),'ElevatedPlusMaze')

            % Calculate the data points and store them back in the mice struct
            Mice.(CurrentMouse).ElevatedPlusMaze.Results.TotalFrames = sum(Mice.(CurrentMouse).ElevatedPlusMaze.Totalframes);
            Mice.(CurrentMouse).ElevatedPlusMaze.Results.Open = sum(Mice.(CurrentMouse).ElevatedPlusMaze.Totalframes([3 5])) / Mice.(CurrentMouse).ElevatedPlusMaze.Results.TotalFrames;
            Mice.(CurrentMouse).ElevatedPlusMaze.Results.Closed = sum(Mice.(CurrentMouse).ElevatedPlusMaze.Totalframes([2 4])) / Mice.(CurrentMouse).ElevatedPlusMaze.Results.TotalFrames;
            Mice.(CurrentMouse).ElevatedPlusMaze.Results.Middle = Mice.(CurrentMouse).ElevatedPlusMaze.Totalframes(1)/ Mice.(CurrentMouse).ElevatedPlusMaze.Results.TotalFrames;
            Mice.(CurrentMouse).ElevatedPlusMaze.Results.RatioOpenClosed = Mice.(CurrentMouse).ElevatedPlusMaze.Results.Open / Mice.(CurrentMouse).ElevatedPlusMaze.Results.Closed;
            Mice.(CurrentMouse).ElevatedPlusMaze.Results.RatioClosedOpen = Mice.(CurrentMouse).ElevatedPlusMaze.Results.Closed / Mice.(CurrentMouse).ElevatedPlusMaze.Results.Open;
        
            % Collact the data point calculated above and store them in the
            % appropriate output varable. At the same time, split the data 
            % in male and female
            ElevatedPlusMaze.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
            ElevatedPlusMaze.(Genotype).Open = [ElevatedPlusMaze.(Genotype).Open Mice.(CurrentMouse).ElevatedPlusMaze.Results.Open];
            ElevatedPlusMaze.(Genotype).Closed = [ElevatedPlusMaze.(Genotype).Closed Mice.(CurrentMouse).ElevatedPlusMaze.Results.Closed];
            ElevatedPlusMaze.(Genotype).Middle = [ElevatedPlusMaze.(Genotype).Middle Mice.(CurrentMouse).ElevatedPlusMaze.Results.Middle];
            ElevatedPlusMaze.(Genotype).Distance = [ElevatedPlusMaze.(Genotype).Distance Mice.(CurrentMouse).ElevatedPlusMaze.TotalCmTravelled];
            ElevatedPlusMaze.(Genotype).Speed = [ElevatedPlusMaze.(Genotype).Speed Mice.(CurrentMouse).ElevatedPlusMaze.MeanBodySpeed];
            ElevatedPlusMaze.(Genotype).RatioOpenClosed = [ElevatedPlusMaze.(Genotype).RatioOpenClosed Mice.(CurrentMouse).ElevatedPlusMaze.Results.RatioOpenClosed];
            ElevatedPlusMaze.(Genotype).RatioClosedOpen = [ElevatedPlusMaze.(Genotype).RatioClosedOpen Mice.(CurrentMouse).ElevatedPlusMaze.Results.RatioClosedOpen];
            if Mice.(CurrentMouse).Sex == "Male"
                ElevatedPlusMaze.Male.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
                ElevatedPlusMaze.Male.(Genotype).Open = [ElevatedPlusMaze.Male.(Genotype).Open Mice.(CurrentMouse).ElevatedPlusMaze.Results.Open];
                ElevatedPlusMaze.Male.(Genotype).Closed = [ElevatedPlusMaze.Male.(Genotype).Closed Mice.(CurrentMouse).ElevatedPlusMaze.Results.Closed];
                ElevatedPlusMaze.Male.(Genotype).Middle = [ElevatedPlusMaze.Male.(Genotype).Middle Mice.(CurrentMouse).ElevatedPlusMaze.Results.Middle];
                ElevatedPlusMaze.Male.(Genotype).Distance = [ElevatedPlusMaze.Male.(Genotype).Distance Mice.(CurrentMouse).ElevatedPlusMaze.TotalCmTravelled];
                ElevatedPlusMaze.Male.(Genotype).Speed = [ElevatedPlusMaze.Male.(Genotype).Speed Mice.(CurrentMouse).ElevatedPlusMaze.MeanBodySpeed];
                ElevatedPlusMaze.Male.(Genotype).RatioOpenClosed = [ElevatedPlusMaze.Male.(Genotype).RatioOpenClosed Mice.(CurrentMouse).ElevatedPlusMaze.Results.RatioOpenClosed];
                ElevatedPlusMaze.Male.(Genotype).RatioClosedOpen = [ElevatedPlusMaze.Male.(Genotype).RatioClosedOpen Mice.(CurrentMouse).ElevatedPlusMaze.Results.RatioClosedOpen];
            elseif Mice.(CurrentMouse).Sex == "Female"
                ElevatedPlusMaze.Female.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
                ElevatedPlusMaze.Female.(Genotype).Open = [ElevatedPlusMaze.Female.(Genotype).Open Mice.(CurrentMouse).ElevatedPlusMaze.Results.Open];
                ElevatedPlusMaze.Female.(Genotype).Closed = [ElevatedPlusMaze.Female.(Genotype).Closed Mice.(CurrentMouse).ElevatedPlusMaze.Results.Closed];
                ElevatedPlusMaze.Female.(Genotype).Middle = [ElevatedPlusMaze.Female.(Genotype).Middle Mice.(CurrentMouse).ElevatedPlusMaze.Results.Middle];
                ElevatedPlusMaze.Female.(Genotype).Distance = [ElevatedPlusMaze.Female.(Genotype).Distance Mice.(CurrentMouse).ElevatedPlusMaze.TotalCmTravelled];
                ElevatedPlusMaze.Female.(Genotype).Speed = [ElevatedPlusMaze.Female.(Genotype).Speed Mice.(CurrentMouse).ElevatedPlusMaze.MeanBodySpeed];
                ElevatedPlusMaze.Female.(Genotype).RatioOpenClosed = [ElevatedPlusMaze.Female.(Genotype).RatioOpenClosed Mice.(CurrentMouse).ElevatedPlusMaze.Results.RatioOpenClosed];
                ElevatedPlusMaze.Female.(Genotype).RatioClosedOpen = [ElevatedPlusMaze.Female.(Genotype).RatioClosedOpen Mice.(CurrentMouse).ElevatedPlusMaze.Results.RatioClosedOpen];
            end
        else % When no dataset has been found, give a responce to the user
            disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Does not have a EPM dateset'])
        end
    else % When no genotype is found give a responce to the user
        disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Genotype could not be found'])
    end
end

%% Table conversion
% To conclude, the collected data points are converted into tables for ease
% of reading
for Genotype = ["WT" "Het"]
    ElevatedPlusMaze.(Genotype) = table(ElevatedPlusMaze.(Genotype).Open', ...
                                        ElevatedPlusMaze.(Genotype).Middle', ...
                                        ElevatedPlusMaze.(Genotype).Closed', ...
                                        ElevatedPlusMaze.(Genotype).Distance', ...
                                        ElevatedPlusMaze.(Genotype).Speed', ...
                                        ElevatedPlusMaze.(Genotype).RatioOpenClosed', ...
                                        ElevatedPlusMaze.(Genotype).RatioClosedOpen', ...
                                        'VariableNames', ElevatedPlusMaze.(Genotype).VariableNames, ...
                                        'RowNames', ElevatedPlusMaze.(Genotype).RowNames);
    
    ElevatedPlusMaze.Male.(Genotype) = table(ElevatedPlusMaze.Male.(Genotype).Open', ...
                                            ElevatedPlusMaze.Male.(Genotype).Middle', ...
                                            ElevatedPlusMaze.Male.(Genotype).Closed', ...
                                            ElevatedPlusMaze.Male.(Genotype).Distance', ...
                                            ElevatedPlusMaze.Male.(Genotype).Speed', ...
                                            ElevatedPlusMaze.Male.(Genotype).RatioOpenClosed', ...
                                            ElevatedPlusMaze.Male.(Genotype).RatioClosedOpen', ...
                                            'RowNames',ElevatedPlusMaze.Male.(Genotype).RowNames, ...
                                            'VariableNames',ElevatedPlusMaze.Male.(Genotype).VariableNames);
    
    ElevatedPlusMaze.Female.(Genotype) = table(ElevatedPlusMaze.Female.(Genotype).Open', ...
                                              ElevatedPlusMaze.Female.(Genotype).Middle', ...
                                              ElevatedPlusMaze.Female.(Genotype).Closed', ...
                                              ElevatedPlusMaze.Female.(Genotype).Distance', ...
                                              ElevatedPlusMaze.Female.(Genotype).Speed', ...
                                              ElevatedPlusMaze.Female.(Genotype).RatioOpenClosed', ...
                                              ElevatedPlusMaze.Female.(Genotype).RatioClosedOpen', ...
                                              'RowNames',ElevatedPlusMaze.Female.(Genotype).RowNames, ...
                                              'VariableNames',ElevatedPlusMaze.Female.(Genotype).VariableNames);
end
end