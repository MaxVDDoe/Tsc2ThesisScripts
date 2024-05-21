function [OpenField, Mice] = AnalizeOF(Mice)


for CurrentMouse = string(fieldnames(Mice))'

    if isfield(Mice.(CurrentMouse),'OpenField')
        Mice.(CurrentMouse).OpenField.Results.TotalFrames = sum(Mice.(CurrentMouse).OpenField.Totalframes(1:2));
        
        Mice.(CurrentMouse).OpenField.Results.Inner = Mice.(CurrentMouse).OpenField.Totalframes(2) / Mice.(CurrentMouse).OpenField.Results.TotalFrames;
        Mice.(CurrentMouse).OpenField.Results.Outer = Mice.(CurrentMouse).OpenField.Totalframes(1) / Mice.(CurrentMouse).OpenField.Results.TotalFrames;

        Mice.(CurrentMouse).OpenField.Results.Corners = sum(Mice.(CurrentMouse).OpenField.Totalframes(3:6)) / Mice.(CurrentMouse).OpenField.Results.TotalFrames;
    else
        disp("")
    end
end

for Genotype = ["WT", "Het"]
    OpenField.(Genotype).Inner = [];
    OpenField.(Genotype).Outer = [];
    OpenField.(Genotype).Corners = [];
    OpenField.(Genotype).Distance = [];
    OpenField.(Genotype).Speed = [];
    OpenField.(Genotype).RowNames = {};
    OpenField.(Genotype).VariableNames = {'Inner','Outer','Corners','Distance','Speed'};

    OpenField.Male.(Genotype).Inner = [];
    OpenField.Male.(Genotype).Outer = [];
    OpenField.Male.(Genotype).Corners = [];
    OpenField.Male.(Genotype).Distance = [];
    OpenField.Male.(Genotype).Speed = [];
    OpenField.Male.(Genotype).RowNames = {};
    OpenField.Male.(Genotype).VariableNames = {'Inner','Outer','Corners','Distance','Speed'};

    OpenField.Female.(Genotype).Inner = [];
    OpenField.Female.(Genotype).Outer = [];
    OpenField.Female.(Genotype).Corners = [];
    OpenField.Female.(Genotype).Distance = [];
    OpenField.Female.(Genotype).Speed = [];
    OpenField.Female.(Genotype).RowNames = {};
    OpenField.Female.(Genotype).VariableNames = {'Inner','Outer','Corners','Distance','Speed'};
end

for CurrentMouse = string(fieldnames(Mice))'
    
    if isfield(Mice.(CurrentMouse), 'Genotype')
        Genotype = Mice.(CurrentMouse).Genotype;

        if isfield(Mice.(CurrentMouse), 'OpenField')
            OpenField.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
            OpenField.(Genotype).Inner = [OpenField.(Genotype).Inner Mice.(CurrentMouse).OpenField.Results.Inner];
            OpenField.(Genotype).Outer = [OpenField.(Genotype).Outer Mice.(CurrentMouse).OpenField.Results.Outer];
            OpenField.(Genotype).Corners = [OpenField.(Genotype).Corners Mice.(CurrentMouse).OpenField.Results.Corners];
            OpenField.(Genotype).Distance = [OpenField.(Genotype).Distance Mice.(CurrentMouse).OpenField.TotalCmTravelled];
            OpenField.(Genotype).Speed = [OpenField.(Genotype).Speed Mice.(CurrentMouse).OpenField.MeanBodySpeed];
            if Mice.(CurrentMouse).Sex == "Male"
                OpenField.Male.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
                OpenField.Male.(Genotype).Inner = [OpenField.Male.(Genotype).Inner Mice.(CurrentMouse).OpenField.Results.Inner];
                OpenField.Male.(Genotype).Outer = [OpenField.Male.(Genotype).Outer Mice.(CurrentMouse).OpenField.Results.Outer];
                OpenField.Male.(Genotype).Corners = [OpenField.Male.(Genotype).Corners Mice.(CurrentMouse).OpenField.Results.Corners];
                OpenField.Male.(Genotype).Distance = [OpenField.Male.(Genotype).Distance Mice.(CurrentMouse).OpenField.TotalCmTravelled];
                OpenField.Male.(Genotype).Speed = [OpenField.Male.(Genotype).Speed Mice.(CurrentMouse).OpenField.MeanBodySpeed];
            elseif Mice.(CurrentMouse).Sex == "Female"
                OpenField.Female.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
                OpenField.Female.(Genotype).Inner = [OpenField.Female.(Genotype).Inner Mice.(CurrentMouse).OpenField.Results.Inner];
                OpenField.Female.(Genotype).Outer = [OpenField.Female.(Genotype).Outer Mice.(CurrentMouse).OpenField.Results.Outer];
                OpenField.Female.(Genotype).Corners = [OpenField.Female.(Genotype).Corners Mice.(CurrentMouse).OpenField.Results.Corners];
                OpenField.Female.(Genotype).Distance = [OpenField.Female.(Genotype).Distance Mice.(CurrentMouse).OpenField.TotalCmTravelled];
                OpenField.Female.(Genotype).Speed = [OpenField.Female.(Genotype).Speed Mice.(CurrentMouse).OpenField.MeanBodySpeed];
            end
        else
            disp(['Mouse ' Mice.(CurrentMouse).MouseName ' does not have an openfield dataset'])
        end
    end
end
for Genotype = ["WT" "Het"]
    OpenField.(Genotype) = table(OpenField.(Genotype).Inner', ...
                                 OpenField.(Genotype).Outer', ...
                                 OpenField.(Genotype).Corners', ...
                                 OpenField.(Genotype).Distance', ...
                                 OpenField.(Genotype).Speed', ...
                                 'VariableNames', OpenField.(Genotype).VariableNames, ...
                                 'Rownames', OpenField.(Genotype).RowNames);
    OpenField.Male.(Genotype) = table(OpenField.Male.(Genotype).Inner', ...
                                 OpenField.Male.(Genotype).Outer', ...
                                 OpenField.Male.(Genotype).Corners', ...
                                 OpenField.Male.(Genotype).Distance', ...
                                 OpenField.Male.(Genotype).Speed', ...
                                 'VariableNames', OpenField.Male.(Genotype).VariableNames, ...
                                 'Rownames', OpenField.Male.(Genotype).RowNames);
    OpenField.Female.(Genotype) = table(OpenField.Female.(Genotype).Inner', ...
                                 OpenField.Female.(Genotype).Outer', ...
                                 OpenField.Female.(Genotype).Corners', ...
                                 OpenField.Female.(Genotype).Distance', ...
                                 OpenField.Female.(Genotype).Speed', ...
                                 'VariableNames', OpenField.Female.(Genotype).VariableNames, ...
                                 'Rownames', OpenField.Female.(Genotype).RowNames);
end
end

