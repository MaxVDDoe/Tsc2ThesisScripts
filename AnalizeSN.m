function [SocialNovelty, Mice] = AnalizeSN(Mice)
%% Variable initialization
% This for loop will create the Social Chamber variable
% ["WT", "Het"] will make it loop twice, one time to create the Wildtype
% varable, the second time to create the Heterozygous variable
for Genotype = ["WT", "Het"]
    SocialNovelty.(Genotype).Familiar = [];
    SocialNovelty.(Genotype).Middle = [];
    SocialNovelty.(Genotype).Novel = [];
    SocialNovelty.(Genotype).NearFamilliar = [];
    SocialNovelty.(Genotype).NearNovel = [];
    SocialNovelty.(Genotype).NearFamilliarRoom = [];
    SocialNovelty.(Genotype).NearNovelRoom = [];
    SocialNovelty.(Genotype).SocialIndex = [];
    SocialNovelty.(Genotype).RowNames = {};
    SocialNovelty.(Genotype).VariableNames = {'Familier','Middle','Novel','NearFamilier','NearNovel','NearFamilierRoom','NearNovelRoom','Social Index'};

    SocialNovelty.Male.(Genotype).Familiar = [];
    SocialNovelty.Male.(Genotype).Middle = [];
    SocialNovelty.Male.(Genotype).Novel = [];
    SocialNovelty.Male.(Genotype).NearFamilliar = [];
    SocialNovelty.Male.(Genotype).NearNovel = [];
    SocialNovelty.Male.(Genotype).NearFamilliarRoom = [];
    SocialNovelty.Male.(Genotype).NearNovelRoom = [];
    SocialNovelty.Male.(Genotype).SocialIndex = [];
    SocialNovelty.Male.(Genotype).RowNames = {};
    SocialNovelty.Male.(Genotype).VariableNames = {'Familier','Middle','Novel','NearFamilier','NearNovel','NearFamilierRoom','NearNovelRoom','Social Index'};

    SocialNovelty.Female.(Genotype).Familiar = [];
    SocialNovelty.Female.(Genotype).Middle = [];
    SocialNovelty.Female.(Genotype).Novel = [];
    SocialNovelty.Female.(Genotype).NearFamilliar = [];
    SocialNovelty.Female.(Genotype).NearNovel = [];
    SocialNovelty.Female.(Genotype).NearFamilliarRoom = [];
    SocialNovelty.Female.(Genotype).NearNovelRoom = [];
    SocialNovelty.Female.(Genotype).SocialIndex = [];
    SocialNovelty.Female.(Genotype).RowNames = {};
    SocialNovelty.Female.(Genotype).VariableNames = {'Familier','Middle','Novel','NearFamilier','NearNovel','NearFamilierRoom','NearNovelRoom','Social Index'};
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
    
    % Next we test if this mouse has a social chamber data set.
    % If not, report to the user and continue to the next mouse
    if ~isfield(Mice.(CurrentMouse),'SocialNovelty')
        disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Does not have a Social Novelty dateset'])
        continue
    end
    
    if Mice.(CurrentMouse).SocialNovelty.Stranger == 'L'
            NovelIdnx = 3;
            FamilierIndx = 1;
            NearNovelIndx = 6;
            NearFamilierIndx = 7;
    else
            NovelIdnx = 1;
            FamilierIndx = 3;
            NearNovelIndx = 7;
            NearFamilierIndx = 6;
    end

    Mice.(CurrentMouse).SocialNovelty.Results.TotalFrames = sum(Mice.(CurrentMouse).SocialNovelty.Totalframes([1 2 3]));
    Mice.(CurrentMouse).SocialNovelty.Results.Novel = Mice.(CurrentMouse).SocialNovelty.Totalframes(NovelIdnx) / Mice.(CurrentMouse).SocialNovelty.Results.TotalFrames;
    Mice.(CurrentMouse).SocialNovelty.Results.Middle = Mice.(CurrentMouse).SocialNovelty.Totalframes(2) / Mice.(CurrentMouse).SocialNovelty.Results.TotalFrames;
    Mice.(CurrentMouse).SocialNovelty.Results.Familiar = Mice.(CurrentMouse).SocialNovelty.Totalframes(FamilierIndx) / Mice.(CurrentMouse).SocialNovelty.Results.TotalFrames;
    Mice.(CurrentMouse).SocialNovelty.Results.NearNovel = Mice.(CurrentMouse).SocialNovelty.Totalframes(NearNovelIndx) / Mice.(CurrentMouse).SocialNovelty.Results.TotalFrames;
    Mice.(CurrentMouse).SocialNovelty.Results.NearFamiliar = Mice.(CurrentMouse).SocialNovelty.Totalframes(NearFamilierIndx) / Mice.(CurrentMouse).SocialNovelty.Results.TotalFrames;
    Mice.(CurrentMouse).SocialNovelty.Results.NearNovelRoom = Mice.(CurrentMouse).SocialNovelty.Totalframes(NearNovelIndx) / Mice.(CurrentMouse).SocialNovelty.Totalframes(NovelIdnx);
    Mice.(CurrentMouse).SocialNovelty.Results.NearFamiliarRoom = Mice.(CurrentMouse).SocialNovelty.Totalframes(NearFamilierIndx) / Mice.(CurrentMouse).SocialNovelty.Totalframes(FamilierIndx);
    Mice.(CurrentMouse).SocialNovelty.Results.SocialIndex = Mice.(CurrentMouse).SocialNovelty.Results.Novel / Mice.(CurrentMouse).SocialNovelty.Results.Familiar;

    SocialNovelty.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
    SocialNovelty.(Genotype).Familiar = [SocialNovelty.(Genotype).Familiar Mice.(CurrentMouse).SocialNovelty.Results.Familiar];
    SocialNovelty.(Genotype).Middle = [SocialNovelty.(Genotype).Middle Mice.(CurrentMouse).SocialNovelty.Results.Middle];
    SocialNovelty.(Genotype).Novel = [SocialNovelty.(Genotype).Novel Mice.(CurrentMouse).SocialNovelty.Results.Novel];
    SocialNovelty.(Genotype).NearFamilliar = [SocialNovelty.(Genotype).NearFamilliar Mice.(CurrentMouse).SocialNovelty.Results.NearFamiliar];
    SocialNovelty.(Genotype).NearNovel = [SocialNovelty.(Genotype).NearNovel Mice.(CurrentMouse).SocialNovelty.Results.NearNovel];
    SocialNovelty.(Genotype).NearFamilliarRoom = [SocialNovelty.(Genotype).NearFamilliarRoom Mice.(CurrentMouse).SocialNovelty.Results.NearFamiliarRoom];
    SocialNovelty.(Genotype).NearNovelRoom = [SocialNovelty.(Genotype).NearNovelRoom Mice.(CurrentMouse).SocialNovelty.Results.NearNovelRoom];
    SocialNovelty.(Genotype).SocialIndex = [SocialNovelty.(Genotype).SocialIndex Mice.(CurrentMouse).SocialNovelty.Results.SocialIndex];
    
    if Mice.(CurrentMouse).Sex == "Male"
        SocialNovelty.Male.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
        SocialNovelty.Male.(Genotype).Familiar = [SocialNovelty.Male.(Genotype).Familiar Mice.(CurrentMouse).SocialNovelty.Results.Familiar];
        SocialNovelty.Male.(Genotype).Middle = [SocialNovelty.Male.(Genotype).Middle Mice.(CurrentMouse).SocialNovelty.Results.Middle];
        SocialNovelty.Male.(Genotype).Novel = [SocialNovelty.Male.(Genotype).Novel Mice.(CurrentMouse).SocialNovelty.Results.Novel];
        SocialNovelty.Male.(Genotype).NearFamilliar = [SocialNovelty.Male.(Genotype).NearFamilliar Mice.(CurrentMouse).SocialNovelty.Results.NearFamiliar];
        SocialNovelty.Male.(Genotype).NearNovel = [SocialNovelty.Male.(Genotype).NearNovel Mice.(CurrentMouse).SocialNovelty.Results.NearNovel];
        SocialNovelty.Male.(Genotype).NearFamilliarRoom = [SocialNovelty.Male.(Genotype).NearFamilliarRoom Mice.(CurrentMouse).SocialNovelty.Results.NearFamiliarRoom];
        SocialNovelty.Male.(Genotype).NearNovelRoom = [SocialNovelty.Male.(Genotype).NearNovelRoom Mice.(CurrentMouse).SocialNovelty.Results.NearNovelRoom];
        SocialNovelty.Male.(Genotype).SocialIndex = [SocialNovelty.Male.(Genotype).SocialIndex Mice.(CurrentMouse).SocialNovelty.Results.SocialIndex];

    elseif Mice.(CurrentMouse).Sex == "Female"
        SocialNovelty.Female.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
        SocialNovelty.Female.(Genotype).Familiar = [SocialNovelty.Female.(Genotype).Familiar Mice.(CurrentMouse).SocialNovelty.Results.Familiar];
        SocialNovelty.Female.(Genotype).Middle = [SocialNovelty.Female.(Genotype).Middle Mice.(CurrentMouse).SocialNovelty.Results.Middle];
        SocialNovelty.Female.(Genotype).Novel = [SocialNovelty.Female.(Genotype).Novel Mice.(CurrentMouse).SocialNovelty.Results.Novel];
        SocialNovelty.Female.(Genotype).NearFamilliar = [SocialNovelty.Female.(Genotype).NearFamilliar Mice.(CurrentMouse).SocialNovelty.Results.NearFamiliar];
        SocialNovelty.Female.(Genotype).NearNovel = [SocialNovelty.Female.(Genotype).NearNovel Mice.(CurrentMouse).SocialNovelty.Results.NearNovel];
        SocialNovelty.Female.(Genotype).NearFamilliarRoom = [SocialNovelty.Female.(Genotype).NearFamilliarRoom Mice.(CurrentMouse).SocialNovelty.Results.NearFamiliarRoom];
        SocialNovelty.Female.(Genotype).NearNovelRoom = [SocialNovelty.Female.(Genotype).NearNovelRoom Mice.(CurrentMouse).SocialNovelty.Results.NearNovelRoom];
        SocialNovelty.Female.(Genotype).SocialIndex = [SocialNovelty.Female.(Genotype).SocialIndex Mice.(CurrentMouse).SocialNovelty.Results.SocialIndex];
    end
end
%% Create Tables
for Genotype = ["WT" "Het"]
    SocialNovelty.(Genotype) = table( ...
        SocialNovelty.(Genotype).Familiar', ...
        SocialNovelty.(Genotype).Middle', ...
        SocialNovelty.(Genotype).Novel', ...
        SocialNovelty.(Genotype).NearFamilliar', ...
        SocialNovelty.(Genotype).NearNovel', ...
        SocialNovelty.(Genotype).NearFamilliarRoom', ...
        SocialNovelty.(Genotype).NearNovelRoom', ...
        SocialNovelty.(Genotype).SocialIndex', ...
        'VariableNames', SocialNovelty.(Genotype).VariableNames, ...
        'Rownames', SocialNovelty.(Genotype).RowNames);

    SocialNovelty.Male.(Genotype) = table( ...
        SocialNovelty.Male.(Genotype).Familiar', ...
        SocialNovelty.Male.(Genotype).Middle', ...
        SocialNovelty.Male.(Genotype).Novel', ...
        SocialNovelty.Male.(Genotype).NearFamilliar', ...
        SocialNovelty.Male.(Genotype).NearNovel', ...
        SocialNovelty.Male.(Genotype).NearFamilliarRoom', ...
        SocialNovelty.Male.(Genotype).NearNovelRoom', ...
        SocialNovelty.Male.(Genotype).SocialIndex', ...
        'VariableNames', SocialNovelty.Male.(Genotype).VariableNames, ...
        'Rownames', SocialNovelty.Male.(Genotype).RowNames);

    SocialNovelty.Female.(Genotype) = table( ...
        SocialNovelty.Female.(Genotype).Familiar', ...
        SocialNovelty.Female.(Genotype).Middle', ...
        SocialNovelty.Female.(Genotype).Novel', ...
        SocialNovelty.Female.(Genotype).NearFamilliar', ...
        SocialNovelty.Female.(Genotype).NearNovel', ...
        SocialNovelty.Female.(Genotype).NearFamilliarRoom', ...
        SocialNovelty.Female.(Genotype).NearNovelRoom', ...
        SocialNovelty.Female.(Genotype).SocialIndex', ...
        'VariableNames', SocialNovelty.Female.(Genotype).VariableNames, ...
        'Rownames', SocialNovelty.Female.(Genotype).RowNames);
end
end