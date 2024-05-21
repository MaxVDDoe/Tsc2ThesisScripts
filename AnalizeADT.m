function [AffectiveState, Mice] = AnalizeADT(Mice)
%% Variable initialization
% This for loop will create the Social Chamber variable
% ["WT", "Het"] will make it loop twice, one time to create the Wildtype
% varable, the second time to create the Heterozygous variable
for Genotype = ["WT", "Het"]
    AffectiveState.(Genotype).Stress = [];
    AffectiveState.(Genotype).Middle = [];
    AffectiveState.(Genotype).Neutral = [];
    AffectiveState.(Genotype).NearStress = [];
    AffectiveState.(Genotype).NearNeutral = [];
    AffectiveState.(Genotype).NearStressRoom = [];
    AffectiveState.(Genotype).NearNeutralRoom = [];
    AffectiveState.(Genotype).SocialIndex = [];
    AffectiveState.(Genotype).RowNames = {};
    AffectiveState.(Genotype).VariableNames = {'Stress','Middle','Neutral','NearStress','NearNeutral','NearStressRoom','NearNeutralRoom','Social Index'};

    AffectiveState.Male.(Genotype).Stress = [];
    AffectiveState.Male.(Genotype).Middle = [];
    AffectiveState.Male.(Genotype).Neutral = [];
    AffectiveState.Male.(Genotype).NearStress = [];
    AffectiveState.Male.(Genotype).NearNeutral = [];
    AffectiveState.Male.(Genotype).NearStressRoom = [];
    AffectiveState.Male.(Genotype).NearNeutralRoom = [];
    AffectiveState.Male.(Genotype).SocialIndex = [];
    AffectiveState.Male.(Genotype).RowNames = {};
    AffectiveState.Male.(Genotype).VariableNames = {'Stress','Middle','Neutral','NearStress','NearNeutral','NearStressRoom','NearNeutralRoom','Social Index'};

    AffectiveState.Female.(Genotype).Stress = [];
    AffectiveState.Female.(Genotype).Middle = [];
    AffectiveState.Female.(Genotype).Neutral = [];
    AffectiveState.Female.(Genotype).NearStress = [];
    AffectiveState.Female.(Genotype).NearNeutral = [];
    AffectiveState.Female.(Genotype).NearStressRoom = [];
    AffectiveState.Female.(Genotype).NearNeutralRoom = [];
    AffectiveState.Female.(Genotype).SocialIndex = [];
    AffectiveState.Female.(Genotype).RowNames = {};
    AffectiveState.Female.(Genotype).VariableNames = {'Stress','Middle','Neutral','NearStress','NearNeutral','NearStressRoom','NearNeutralRoom','Social Index'};
end
%% Calculate
% Here it loops over all mice within the Mice variable
for CurrentMouse = string(fieldnames(Mice))'
    
    % First we test if there is a genotype associated with the current
    % mouse that is being tested. When no Genotype can be found, report to
    % the user and contiue to the next mouse. Else, store the associated
    % genotype for later.
    if ~isfield(Mice.(CurrentMouse), 'Genotype')
        disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Genotype could not be found'])
        continue
    else
        Genotype = Mice.(CurrentMouse).Genotype;
    end
    
    if ~isfield(Mice.(CurrentMouse),'AffectiveState')
        disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Does not have a Affective state dateset'])
        continue
    end

    if Mice.(CurrentMouse).AffectiveState.Stranger == 'R'
        StressIdnx = 1;
        NeutralIndx = 3;
        NearStressIndx = 7;
        NearNeutralIndx = 6;
    else
        StressIdnx = 3;
        NeutralIndx = 1;
        NearStressIndx = 6;
        NearNeutralIndx = 7;
    end

    Mice.(CurrentMouse).AffectiveState.Results.TotalTime = sum(Mice.(CurrentMouse).AffectiveState.Totalframes(1:3));
    Mice.(CurrentMouse).AffectiveState.Results.Stress = Mice.(CurrentMouse).AffectiveState.Totalframes(StressIdnx) / Mice.(CurrentMouse).AffectiveState.Results.TotalTime;
    Mice.(CurrentMouse).AffectiveState.Results.Middle = Mice.(CurrentMouse).AffectiveState.Totalframes(2) / Mice.(CurrentMouse).AffectiveState.Results.TotalTime;
    Mice.(CurrentMouse).AffectiveState.Results.Neutral = Mice.(CurrentMouse).AffectiveState.Totalframes(NeutralIndx) / Mice.(CurrentMouse).AffectiveState.Results.TotalTime;
    Mice.(CurrentMouse).AffectiveState.Results.NearStress = Mice.(CurrentMouse).AffectiveState.Totalframes(NearStressIndx) / Mice.(CurrentMouse).AffectiveState.Results.TotalTime;
    Mice.(CurrentMouse).AffectiveState.Results.NearNeutral = Mice.(CurrentMouse).AffectiveState.Totalframes(NearNeutralIndx) / Mice.(CurrentMouse).AffectiveState.Results.TotalTime;
    Mice.(CurrentMouse).AffectiveState.Results.NearStressRoom = Mice.(CurrentMouse).AffectiveState.Totalframes(NearStressIndx) / Mice.(CurrentMouse).AffectiveState.Totalframes(StressIdnx);
    Mice.(CurrentMouse).AffectiveState.Results.NearNeutralRoom = Mice.(CurrentMouse).AffectiveState.Totalframes(NearNeutralIndx) / Mice.(CurrentMouse).AffectiveState.Totalframes(NeutralIndx);
    Mice.(CurrentMouse).AffectiveState.Results.SocialIndex = Mice.(CurrentMouse).AffectiveState.Results.Stress / Mice.(CurrentMouse).AffectiveState.Results.Neutral;

    AffectiveState.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
    AffectiveState.(Genotype).Stress = [AffectiveState.(Genotype).Stress Mice.(CurrentMouse).AffectiveState.Results.Stress];
    AffectiveState.(Genotype).Middle = [AffectiveState.(Genotype).Middle Mice.(CurrentMouse).AffectiveState.Results.Middle];
    AffectiveState.(Genotype).Neutral = [AffectiveState.(Genotype).Neutral Mice.(CurrentMouse).AffectiveState.Results.Neutral];
    AffectiveState.(Genotype).NearStress = [AffectiveState.(Genotype).NearStress Mice.(CurrentMouse).AffectiveState.Results.NearStress];
    AffectiveState.(Genotype).NearNeutral = [AffectiveState.(Genotype).NearNeutral Mice.(CurrentMouse).AffectiveState.Results.NearNeutral];
    AffectiveState.(Genotype).NearStressRoom = [AffectiveState.(Genotype).NearStressRoom Mice.(CurrentMouse).AffectiveState.Results.NearStressRoom];
    AffectiveState.(Genotype).NearNeutralRoom = [AffectiveState.(Genotype).NearNeutralRoom Mice.(CurrentMouse).AffectiveState.Results.NearNeutralRoom];
    AffectiveState.(Genotype).SocialIndex = [AffectiveState.(Genotype).SocialIndex Mice.(CurrentMouse).AffectiveState.Results.SocialIndex];
    
    if Mice.(CurrentMouse).Sex == "Male"
        AffectiveState.Male.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
        AffectiveState.Male.(Genotype).Stress = [AffectiveState.Male.(Genotype).Stress Mice.(CurrentMouse).AffectiveState.Results.Stress];
        AffectiveState.Male.(Genotype).Middle = [AffectiveState.Male.(Genotype).Middle Mice.(CurrentMouse).AffectiveState.Results.Middle];
        AffectiveState.Male.(Genotype).Neutral = [AffectiveState.Male.(Genotype).Neutral Mice.(CurrentMouse).AffectiveState.Results.Neutral];
        AffectiveState.Male.(Genotype).NearStress = [AffectiveState.Male.(Genotype).NearStress Mice.(CurrentMouse).AffectiveState.Results.NearStress];
        AffectiveState.Male.(Genotype).NearNeutral = [AffectiveState.Male.(Genotype).NearNeutral Mice.(CurrentMouse).AffectiveState.Results.NearNeutral];
        AffectiveState.Male.(Genotype).NearStressRoom = [AffectiveState.Male.(Genotype).NearStressRoom Mice.(CurrentMouse).AffectiveState.Results.NearStressRoom];
        AffectiveState.Male.(Genotype).NearNeutralRoom = [AffectiveState.Male.(Genotype).NearNeutralRoom Mice.(CurrentMouse).AffectiveState.Results.NearNeutralRoom];
        AffectiveState.Male.(Genotype).SocialIndex = [AffectiveState.Male.(Genotype).SocialIndex Mice.(CurrentMouse).AffectiveState.Results.SocialIndex];

    elseif Mice.(CurrentMouse).Sex == "Female"
        AffectiveState.Female.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
        AffectiveState.Female.(Genotype).Stress = [AffectiveState.Female.(Genotype).Stress Mice.(CurrentMouse).AffectiveState.Results.Stress];
        AffectiveState.Female.(Genotype).Middle = [AffectiveState.Female.(Genotype).Middle Mice.(CurrentMouse).AffectiveState.Results.Middle];
        AffectiveState.Female.(Genotype).Neutral = [AffectiveState.Female.(Genotype).Neutral Mice.(CurrentMouse).AffectiveState.Results.Neutral];
        AffectiveState.Female.(Genotype).NearStress = [AffectiveState.Female.(Genotype).NearStress Mice.(CurrentMouse).AffectiveState.Results.NearStress];
        AffectiveState.Female.(Genotype).NearNeutral = [AffectiveState.Female.(Genotype).NearNeutral Mice.(CurrentMouse).AffectiveState.Results.NearNeutral];
        AffectiveState.Female.(Genotype).NearStressRoom = [AffectiveState.Female.(Genotype).NearStressRoom Mice.(CurrentMouse).AffectiveState.Results.NearStressRoom];
        AffectiveState.Female.(Genotype).NearNeutralRoom = [AffectiveState.Female.(Genotype).NearNeutralRoom Mice.(CurrentMouse).AffectiveState.Results.NearNeutralRoom];
        AffectiveState.Female.(Genotype).SocialIndex = [AffectiveState.Female.(Genotype).SocialIndex Mice.(CurrentMouse).AffectiveState.Results.SocialIndex];

    end
end
for Genotype = ["WT" "Het"]
    AffectiveState.(Genotype) = table( ...
        AffectiveState.(Genotype).Stress', ...
        AffectiveState.(Genotype).Middle', ...
        AffectiveState.(Genotype).Neutral', ...
        AffectiveState.(Genotype).NearStress', ...
        AffectiveState.(Genotype).NearNeutral', ...
        AffectiveState.(Genotype).NearStressRoom', ...
        AffectiveState.(Genotype).NearNeutralRoom', ...
        AffectiveState.(Genotype).SocialIndex', ...
        'VariableNames', AffectiveState.(Genotype).VariableNames, ...
        'Rownames', AffectiveState.(Genotype).RowNames);

    AffectiveState.Male.(Genotype) = table( ...
        AffectiveState.Male.(Genotype).Stress', ...
        AffectiveState.Male.(Genotype).Middle', ...
        AffectiveState.Male.(Genotype).Neutral', ...
        AffectiveState.Male.(Genotype).NearStress', ...
        AffectiveState.Male.(Genotype).NearNeutral', ...
        AffectiveState.Male.(Genotype).NearStressRoom', ...
        AffectiveState.Male.(Genotype).NearNeutralRoom', ...
        AffectiveState.Male.(Genotype).SocialIndex', ...
        'VariableNames', AffectiveState.Male.(Genotype).VariableNames, ...
        'Rownames', AffectiveState.Male.(Genotype).RowNames);

    AffectiveState.Female.(Genotype) = table( ...
        AffectiveState.Female.(Genotype).Stress', ...
        AffectiveState.Female.(Genotype).Middle', ...
        AffectiveState.Female.(Genotype).Neutral', ...
        AffectiveState.Female.(Genotype).NearStress', ...
        AffectiveState.Female.(Genotype).NearNeutral', ...
        AffectiveState.Female.(Genotype).NearStressRoom', ...
        AffectiveState.Female.(Genotype).NearNeutralRoom', ...
        AffectiveState.Female.(Genotype).SocialIndex', ...
        'VariableNames', AffectiveState.Female.(Genotype).VariableNames, ...
        'Rownames', AffectiveState.Female.(Genotype).RowNames);
end
end