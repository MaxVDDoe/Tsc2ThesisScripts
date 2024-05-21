%% 
%Variables
Path = 'S:\Documents\RMNeuroscience\Research Project\';
MasterSheet = 'Tsc2 Master scheet.xlsx';

% Cear the console
clc

% Loading In all the data
disp("Loading Data")

% Loading data
disp("Checking to see if a Mice.json exists")
if isfile([Path 'Mice.json'])
    Awnser = questdlg('Json file found, do you want to update?');
end

switch Awnser
    case 'Yes'
        disp('Updating Json file')
        Mice = JsonGenerator(Path, MasterSheet);
    case 'No'
        disp('Loading json file')
        Mice = readstruct([Path 'Mice.json']);
    case 'Cancel'
        disp('Canceling...')
        return
    otherwise
        Mice = JsonGenerator(Path, MasterSheet);
end

%% Analize the data
[OpenField, Mice] = AnalizeOF(Mice);
[ElevatedPlusMaze, Mice] = AnalizeEPM(Mice);
[SocialChamber, Mice] = AnalizeSC(Mice);
[SocialNovelty, Mice] = AnalizeSN(Mice);
[AffectiveState, Mice] = AnalizeADT(Mice);
Mice = AnalizeGrooming(Mice);
% Mice = AnalizeSniffing(Mice);
% 
%% Sort all the data into there respective variabes
% [OpenField, OpenFieldMale, OpenFieldFemale, ElevatedPlusMaze, ElevatedPlusMazeMale, ElevatedPlusMazeFemale, SocialChamber, SocialChamberMale, SocialChamberFemale, SocialNovelty, SocialNoveltyMale, SocialNoveltyFemale, AffectiveStateDiscriminationTask, AffectiveStateDiscriminationTaskMale, AffectiveStateDiscriminationTaskFemale, Grooming, Sniffing] = SortBehaviourData(Mice);
