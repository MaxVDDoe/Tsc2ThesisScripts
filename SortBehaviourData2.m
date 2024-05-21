function [SocialChamber, SocialNovelty] = SortBehaviourData2(Mice)
%% Variable Initialization
for Genotype = ["WT", "Het"]
    SocialChamber.(Genotype).RatioPref = [];
    SocialChamber.(Genotype).RatioObject = [];
    SocialChamber.(Genotype).SocialIndex = [];
    SocialChamber.(Genotype).NearMouseTime = [];
    SocialChamber.(Genotype).NearObjectTime = [];
    SocialChamber.(Genotype).RowNames = {};
    SocialChamber.(Genotype).VariableNames = {'RatioPref', 'RatioObject', 'Social Index','NearMouseTime','NearObjectTime'};

    SocialNovelty.(Genotype).RatioNovel = [];
    SocialNovelty.(Genotype).RatioFamilier = [];
    SocialNovelty.(Genotype).SocialIndex = [];
    SocialChamber.(Genotype).NearNovelTime = [];
    SocialChamber.(Genotype).NearFamilierTime = [];
    SocialNovelty.(Genotype).RowNames = {};
    SocialNovelty.(Genotype).VariableNames = {'RatioNovel', 'RatioFamilier', 'Social Index'};
    
end

%% Sorting the data
AllMice = fieldnames(Mice);
for CurrentMouse = string(AllMice)'
    
    if isfield(Mice.(CurrentMouse), 'Genotype')
        Genotype = Mice.(CurrentMouse).Genotype;

        if isfield(Mice.(CurrentMouse), 'SCN')
            if Mice.(CurrentMouse).MouseSex == "Female"
                SocialChamber.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
                SocialChamber.(Genotype).RatioPref = [SocialChamber.(Genotype).RatioPref Mice.(CurrentMouse).SCN.Results.RatioPref];
                SocialChamber.(Genotype).RatioObject = [SocialChamber.(Genotype).RatioObject Mice.(CurrentMouse).SCN.Results.RatioObject]; 
                SocialChamber.(Genotype).SocialIndex = [SocialChamber.(Genotype).SocialIndex Mice.(CurrentMouse).SCN.Results.PrefSocialIndex];
                SocialChamber.(Genotype).NearMouseTime = [SocialChamber.(Genotype).NearMouseTime Mice.(CurrentMouse).SCN.Results.MouseInteractionTime];
                SocialChamber.(Genotype).NearObjectTime = [SocialChamber.(Genotype).NearObjectTime Mice.(CurrentMouse).SCN.Results.ObjectInteractionTime];

                SocialNovelty.(Genotype).RowNames{end+1} = Mice.(CurrentMouse).MouseName;
                SocialNovelty.(Genotype).RatioNovel = [SocialNovelty.(Genotype).RatioNovel Mice.(CurrentMouse).SCN.Results.RatioNovel];
                SocialNovelty.(Genotype).RatioFamilier = [SocialNovelty.(Genotype).RatioFamilier Mice.(CurrentMouse).SCN.Results.RatioFamilier];
                SocialNovelty.(Genotype).SocialIndex = [SocialNovelty.(Genotype).SocialIndex Mice.(CurrentMouse).SCN.Results.NovSocialIndex];
                SocialChamber.(Genotype).NearNovelTime = [SocialChamber.(Genotype).NearNovelTime Mice.(CurrentMouse).SCN.Results.NovelInteractionTime];
                SocialChamber.(Genotype).NearFamilierTime = [SocialChamber.(Genotype).NearFamilierTime Mice.(CurrentMouse).SCN.Results.FamilierInteractionTime];
            else
                disp(['Mouse ' Mice.(CurrentMouse).MouseName ' is a Male'])
            end
        else
            disp(['Mouse ' Mice.(CurrentMouse).MouseName ' does not have a social chamber dataset'])
        end
    else
        disp(['Mouse ' Mice.(CurrentMouse).MouseName ' Genotype could not be found'])
    end

end

%% Create Tables
for Genotype = ["WT" "Het"]
    
    SocialChamber.(Genotype) = table(SocialChamber.(Genotype).RatioPref', ...
                                     SocialChamber.(Genotype).RatioObject', ...
                                     SocialChamber.(Genotype).SocialIndex', ...
                                     SocialChamber.(Genotype).NearMouseTime', ...
                                     SocialChamber.(Genotype).NearObjectTime', ...
                                     'VariableNames', SocialChamber.(Genotype).VariableNames, ...
                                     'Rownames', SocialChamber.(Genotype).RowNames);

    SocialNovelty.(Genotype) = table(SocialNovelty.(Genotype).RatioNovel', ...
                                     SocialNovelty.(Genotype).RatioFamilier', ...
                                     SocialNovelty.(Genotype).SocialIndex', ...
                                     'VariableNames', SocialNovelty.(Genotype).VariableNames, ...
                                     'Rownames', SocialNovelty.(Genotype).RowNames);
end

end





















