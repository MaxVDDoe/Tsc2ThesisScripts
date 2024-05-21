function [SocialChamber, Mice] = AnalizeSC(Mice)
%% Variable initialization
% This for loop will create the Social Chamber variable
% ["WT", "Het"] will make it loop twice, one time to create the Wildtype
% varable, the second time to create the Heterozygous variable
for Genotype = ["WT", "Het"]
    SocialChamber.(Genotype).Object = [];
    SocialChamber.(Genotype).Middle = [];
    SocialChamber.(Genotype).Mouse = [];
    SocialChamber.(Genotype).NearObject = [];
    SocialChamber.(Genotype).NearMouse = [];
    SocialChamber.(Genotype).NearObjectRoom = [];
    SocialChamber.(Genotype).NearMouseRoom = [];
    SocialChamber.(Genotype).SocialIndex = [];
    SocialChamber.(Genotype).RowNames = {};
    SocialChamber.(Genotype).VariableNames = {'Object','Middle','Mouse','NearObject','NearMouse','NearObjectRoom','NearMouseRoom','Social Index'};

    SocialChamber.Male.(Genotype).Object = [];
    SocialChamber.Male.(Genotype).Middle = [];
    SocialChamber.Male.(Genotype).Mouse = [];
    SocialChamber.Male.(Genotype).NearObject = [];
    SocialChamber.Male.(Genotype).NearMouse = [];
    SocialChamber.Male.(Genotype).NearObjectRoom = [];
    SocialChamber.Male.(Genotype).NearMouseRoom = [];
    SocialChamber.Male.(Genotype).SocialIndex = [];
    SocialChamber.Male.(Genotype).RowNames = {};
    SocialChamber.Male.(Genotype).VariableNames = {'Object','Middle','Mouse','NearObject','NearMouse','NearObjectRoom','NearMouseRoom','Social Index'};

    SocialChamber.Female.(Genotype).Object = [];
    SocialChamber.Female.(Genotype).Middle = [];
    SocialChamber.Female.(Genotype).Mouse = [];
    SocialChamber.Female.(Genotype).NearObject = [];
    SocialChamber.Female.(Genotype).NearMouse = [];
    SocialChamber.Female.(Genotype).NearObjectRoom = [];
    SocialChamber.Female.(Genotype).NearMouseRoom = [];
    SocialChamber.Female.(Genotype).SocialIndex = [];
    SocialChamber.Female.(Genotype).RowNames = {};
    SocialChamber.Female.(Genotype).VariableNames = {'Object','Middle','Mouse','NearObject','NearMouse','NearObjectRoom','NearMouseRoom','Social Index'};
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
    if ~isfield(Mice.(CurrentMouse),'SocialChamber')
        disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Does not have a Social Chamber dateset'])
        continue
    end

    % The place of the Stranger mouse needs to be determent
    if Mice.(CurrentMouse).SocialChamber.Stranger == 'R'
        MouseIdnx = 1;
        ObjectIndx = 3;
        NearMouseIndx = 7;
        NearObjectIndx = 6;
    else
        MouseIdnx = 3;
        ObjectIndx = 1;
        NearMouseIndx = 6;
        NearObjectIndx = 7;

    end

    Mice.(CurrentMouse).SocialChamber.Results.TotalFrames = sum(Mice.(CurrentMouse).SocialChamber.Totalframes([1 2 3]));
    Mice.(CurrentMouse).SocialChamber.Results.Mouse = Mice.(CurrentMouse).SocialChamber.Totalframes(MouseIdnx) / Mice.(CurrentMouse).SocialChamber.Results.TotalFrames;
    Mice.(CurrentMouse).SocialChamber.Results.Middle = Mice.(CurrentMouse).SocialChamber.Totalframes(2) / Mice.(CurrentMouse).SocialChamber.Results.TotalFrames;
    Mice.(CurrentMouse).SocialChamber.Results.Object = Mice.(CurrentMouse).SocialChamber.Totalframes(ObjectIndx) / Mice.(CurrentMouse).SocialChamber.Results.TotalFrames;
    Mice.(CurrentMouse).SocialChamber.Results.NearMouse = Mice.(CurrentMouse).SocialChamber.Totalframes(NearMouseIndx) / Mice.(CurrentMouse).SocialChamber.Results.TotalFrames;
    Mice.(CurrentMouse).SocialChamber.Results.NearObject = Mice.(CurrentMouse).SocialChamber.Totalframes(NearObjectIndx) / Mice.(CurrentMouse).SocialChamber.Results.TotalFrames;
    Mice.(CurrentMouse).SocialChamber.Results.NearMouseRoom = Mice.(CurrentMouse).SocialChamber.Totalframes(NearMouseIndx) / Mice.(CurrentMouse).SocialChamber.Totalframes(MouseIdnx);
    Mice.(CurrentMouse).SocialChamber.Results.NearObjectRoom = Mice.(CurrentMouse).SocialChamber.Totalframes(NearObjectIndx) / Mice.(CurrentMouse).SocialChamber.Totalframes(ObjectIndx);
    Mice.(CurrentMouse).SocialChamber.Results.SocialIndex = Mice.(CurrentMouse).SocialChamber.Results.Mouse / Mice.(CurrentMouse).SocialChamber.Results.Object;

    SocialChamber.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
    SocialChamber.(Genotype).Object = [SocialChamber.(Genotype).Object Mice.(CurrentMouse).SocialChamber.Results.Object];
    SocialChamber.(Genotype).Middle = [SocialChamber.(Genotype).Middle Mice.(CurrentMouse).SocialChamber.Results.Middle];
    SocialChamber.(Genotype).Mouse = [SocialChamber.(Genotype).Mouse Mice.(CurrentMouse).SocialChamber.Results.Mouse];
    SocialChamber.(Genotype).NearObject = [SocialChamber.(Genotype).NearObject Mice.(CurrentMouse).SocialChamber.Results.NearObject];
    SocialChamber.(Genotype).NearMouse = [SocialChamber.(Genotype).NearMouse Mice.(CurrentMouse).SocialChamber.Results.NearMouse];
    SocialChamber.(Genotype).NearObjectRoom = [SocialChamber.(Genotype).NearObjectRoom Mice.(CurrentMouse).SocialChamber.Results.NearObjectRoom];
    SocialChamber.(Genotype).NearMouseRoom = [SocialChamber.(Genotype).NearMouseRoom Mice.(CurrentMouse).SocialChamber.Results.NearMouseRoom];
    SocialChamber.(Genotype).SocialIndex = [SocialChamber.(Genotype).SocialIndex Mice.(CurrentMouse).SocialChamber.Results.SocialIndex];

    if Mice.(CurrentMouse).Sex == "Male"
        SocialChamber.Male.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
        SocialChamber.Male.(Genotype).Object = [SocialChamber.Male.(Genotype).Object Mice.(CurrentMouse).SocialChamber.Results.Object];
        SocialChamber.Male.(Genotype).Middle = [SocialChamber.Male.(Genotype).Middle Mice.(CurrentMouse).SocialChamber.Results.Middle];
        SocialChamber.Male.(Genotype).Mouse = [SocialChamber.Male.(Genotype).Mouse Mice.(CurrentMouse).SocialChamber.Results.Mouse];
        SocialChamber.Male.(Genotype).NearObject = [SocialChamber.Male.(Genotype).NearObject Mice.(CurrentMouse).SocialChamber.Results.NearObject];
        SocialChamber.Male.(Genotype).NearMouse = [SocialChamber.Male.(Genotype).NearMouse Mice.(CurrentMouse).SocialChamber.Results.NearMouse];
        SocialChamber.Male.(Genotype).NearObjectRoom = [SocialChamber.Male.(Genotype).NearObjectRoom Mice.(CurrentMouse).SocialChamber.Results.NearObjectRoom];
        SocialChamber.Male.(Genotype).NearMouseRoom = [SocialChamber.Male.(Genotype).NearMouseRoom Mice.(CurrentMouse).SocialChamber.Results.NearMouseRoom];
        SocialChamber.Male.(Genotype).SocialIndex = [SocialChamber.Male.(Genotype).SocialIndex Mice.(CurrentMouse).SocialChamber.Results.SocialIndex];

        % SocialNoveltyMale.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
        % SocialNoveltyMale.(Genotype).Familiar = [SocialNoveltyMale.(Genotype).Familiar Mice.(CurrentMouse).SCN.Results.NovFamiliar];
        % SocialNoveltyMale.(Genotype).Middle = [SocialNoveltyMale.(Genotype).Middle Mice.(CurrentMouse).SCN.Results.NovMiddle];
        % SocialNoveltyMale.(Genotype).Novel = [SocialNoveltyMale.(Genotype).Novel Mice.(CurrentMouse).SCN.Results.NovNovel];
        % SocialNoveltyMale.(Genotype).NearFamilliar = [SocialNoveltyMale.(Genotype).NearFamilliar Mice.(CurrentMouse).SCN.Results.NovNearFamiliar];
        % SocialNoveltyMale.(Genotype).NearNovel = [SocialNoveltyMale.(Genotype).NearNovel Mice.(CurrentMouse).SCN.Results.NovNearNovel];
        % SocialNoveltyMale.(Genotype).NearFamilliarRoom = [SocialNoveltyMale.(Genotype).NearFamilliarRoom Mice.(CurrentMouse).SCN.Results.NovNearFamiliarRoom];
        % SocialNoveltyMale.(Genotype).NearNovelRoom = [SocialNoveltyMale.(Genotype).NearNovelRoom Mice.(CurrentMouse).SCN.Results.NovNearNovelRoom];
        % SocialNoveltyMale.(Genotype).SocialIndex = [SocialNoveltyMale.(Genotype).SocialIndex Mice.(CurrentMouse).SCN.Results.NovSocialIndex];

    elseif Mice.(CurrentMouse).Sex == "Female"
        SocialChamber.Female.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
        SocialChamber.Female.(Genotype).Object = [SocialChamber.Female.(Genotype).Object Mice.(CurrentMouse).SocialChamber.Results.Object];
        SocialChamber.Female.(Genotype).Middle = [SocialChamber.Female.(Genotype).Middle Mice.(CurrentMouse).SocialChamber.Results.Middle];
        SocialChamber.Female.(Genotype).Mouse = [SocialChamber.Female.(Genotype).Mouse Mice.(CurrentMouse).SocialChamber.Results.Mouse];
        SocialChamber.Female.(Genotype).NearObject = [SocialChamber.Female.(Genotype).NearObject Mice.(CurrentMouse).SocialChamber.Results.NearObject];
        SocialChamber.Female.(Genotype).NearMouse = [SocialChamber.Female.(Genotype).NearMouse Mice.(CurrentMouse).SocialChamber.Results.NearMouse];
        SocialChamber.Female.(Genotype).NearObjectRoom = [SocialChamber.Female.(Genotype).NearObjectRoom Mice.(CurrentMouse).SocialChamber.Results.NearObjectRoom];
        SocialChamber.Female.(Genotype).NearMouseRoom = [SocialChamber.Female.(Genotype).NearMouseRoom Mice.(CurrentMouse).SocialChamber.Results.NearMouseRoom];
        SocialChamber.Female.(Genotype).SocialIndex = [SocialChamber.Female.(Genotype).SocialIndex Mice.(CurrentMouse).SocialChamber.Results.SocialIndex];

        % SocialNoveltyFemale.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
        % SocialNoveltyFemale.(Genotype).Familiar = [SocialNoveltyFemale.(Genotype).Familiar Mice.(CurrentMouse).SCN.Results.NovFamiliar];
        % SocialNoveltyFemale.(Genotype).Middle = [SocialNoveltyFemale.(Genotype).Middle Mice.(CurrentMouse).SCN.Results.NovMiddle];
        % SocialNoveltyFemale.(Genotype).Novel = [SocialNoveltyFemale.(Genotype).Novel Mice.(CurrentMouse).SCN.Results.NovNovel];
        % SocialNoveltyFemale.(Genotype).NearFamilliar = [SocialNoveltyFemale.(Genotype).NearFamilliar Mice.(CurrentMouse).SCN.Results.NovNearFamiliar];
        % SocialNoveltyFemale.(Genotype).NearNovel = [SocialNoveltyFemale.(Genotype).NearNovel Mice.(CurrentMouse).SCN.Results.NovNearNovel];
        % SocialNoveltyFemale.(Genotype).NearFamilliarRoom = [SocialNoveltyFemale.(Genotype).NearFamilliarRoom Mice.(CurrentMouse).SCN.Results.NovNearFamiliarRoom];
        % SocialNoveltyFemale.(Genotype).NearNovelRoom = [SocialNoveltyFemale.(Genotype).NearNovelRoom Mice.(CurrentMouse).SCN.Results.NovNearNovelRoom];
        % SocialNoveltyFemale.(Genotype).SocialIndex = [SocialNoveltyFemale.(Genotype).SocialIndex Mice.(CurrentMouse).SCN.Results.NovSocialIndex];
    end

end
%% Create Tables
for Genotype = ["WT" "Het"]
    SocialChamber.(Genotype) = table( ...
        SocialChamber.(Genotype).Object', ...
        SocialChamber.(Genotype).Middle', ...
        SocialChamber.(Genotype).Mouse', ...
        SocialChamber.(Genotype).NearObject', ...
        SocialChamber.(Genotype).NearMouse', ...
        SocialChamber.(Genotype).NearObjectRoom', ...
        SocialChamber.(Genotype).NearMouseRoom', ...
        SocialChamber.(Genotype).SocialIndex', ...
        'VariableNames', SocialChamber.(Genotype).VariableNames, ...
        'Rownames', SocialChamber.(Genotype).RowNames);

    SocialChamber.Male.(Genotype) = table( ...
        SocialChamber.Male.(Genotype).Object', ...
        SocialChamber.Male.(Genotype).Middle', ...
        SocialChamber.Male.(Genotype).Mouse', ...
        SocialChamber.Male.(Genotype).NearObject', ...
        SocialChamber.Male.(Genotype).NearMouse', ...
        SocialChamber.Male.(Genotype).NearObjectRoom', ...
        SocialChamber.Male.(Genotype).NearMouseRoom', ...
        SocialChamber.Male.(Genotype).SocialIndex', ...
        'RowNames',SocialChamber.Male.(Genotype).RowNames, ...
        'VariableNames',SocialChamber.Male.(Genotype).VariableNames);

    SocialChamber.Female.(Genotype) = table( ...
        SocialChamber.Female.(Genotype).Object', ...
        SocialChamber.Female.(Genotype).Middle', ...
        SocialChamber.Female.(Genotype).Mouse', ...
        SocialChamber.Female.(Genotype).NearObject', ...
        SocialChamber.Female.(Genotype).NearMouse', ...
        SocialChamber.Female.(Genotype).NearObjectRoom', ...
        SocialChamber.Female.(Genotype).NearMouseRoom', ...
        SocialChamber.Female.(Genotype).SocialIndex', ...
        'RowNames', SocialChamber.Female.(Genotype).RowNames, ...
        'VariableNames', SocialChamber.Female.(Genotype).VariableNames);
end
end