Dir = dir([uigetdir(),'\*.mat']);
FileNames = split(Dir(1).name,"_");
% ISD = FileNames{2,1};

for i = 1:size(Dir,1)
    load(strcat(Dir(i).folder,"\",Dir(i).name));
    Data = cell(size(Res.zone_names,2),4);
    Name = split(Dir(i).name,'_');
    Data{1,1} = [Name{1} ' ' Name{2}];
    Data{1,2} = Res.total_cms_travelled;
    Data{1,3} = Res.mean_body_speed;
    Data{1,4} = Res.median_body_speed;
    Data = horzcat(Data, transpose(Res.zone_names));
    Data = horzcat(Data, num2cell(Res.totalFramesZPbody));
    Data = horzcat(Data, num2cell(Res.totalTimeZPbody));
    %Data = horzcat(Data, num2cell(Res.pairwise_zone_pref_index_body));
    
    % if ISD == "ISD"
    %     %get logical masks for indexing
    %     two_min = Res.good_frame_times <= 120;
    %     four_min = Res.good_frame_times >= 120.04 & Res.good_frame_times <= 240;
    %     six_min = Res.good_frame_times >= 240.04 & Res.good_frame_times <= 360;
    %     eight_min = Res.good_frame_times >= 360.04 & Res.good_frame_times <= 480;
    %     ten_min = Res.good_frame_times >= 480.04;
    % 
    %     %Index and get the data for every two minutes
    %     TwoCumSum = Res.cumsumZPbody(:, two_min);
    %     TwoCumSum = TwoCumSum(:,end) - TwoCumSum(:,1);
    %     FourCumSum = Res.cumsumZPbody(:, four_min);
    %     FourCumSum = FourCumSum(:,end) - FourCumSum(:,1);
    %     SixCumSum = Res.cumsumZPbody(:, six_min);
    %     SixCumSum = SixCumSum(:,end) - SixCumSum(:,1);
    %     EightCumSum = Res.cumsumZPbody(:, eight_min);
    %     EightCumSum = EightCumSum(:,end) - EightCumSum(:,1);
    %     TenCumSum = Res.cumsumZPbody(:, ten_min);
    %     TenCumSum = TenCumSum(:,end) - TenCumSum(:,1);
    % 
    %     %Stitch all the data together
    %     Data = horzcat(Data, num2cell(TwoCumSum));
    %     Data = horzcat(Data, num2cell(FourCumSum));
    %     Data = horzcat(Data, num2cell(SixCumSum));
    %     Data = horzcat(Data, num2cell(EightCumSum));
    %     Data = horzcat(Data, num2cell(TenCumSum));
    % end

    % FileNameArray = split(Dir(i).name,"_");
    % load(Res.position_file);
    % Name = FileNameArray{1,1};
    % Stage = FileNameArray{3,1};
    % PositionsVariableNames = [Name+"_"+Stage+"_X", Name+"_"+Stage+"_Y"];
    % PositionData = array2table(position_results.mouseCOM,"VariableNames",PositionsVariableNames);
    
    if i == 1
        Results = Data;
        % PositionResults = PositionData;
    else
        Results = vertcat(Results,Data);
        % PositionResults = horzcat(PositionResults, PositionData);
    end
end

% if FileNameArray{2,1} == "ISD"
%     VarNames = ["Mouse Name","Total cm travelled","Mean body speed","Median body speed","Zone names","Total Frames","Total Time","CumSumTwo","CumSumFour","CumSumSix","CumSumEight","CumSumTen"];
% else
    VarNames = ["Mouse Name","Total cm travelled","Mean body speed","Median body speed","Zone names","Total Frames","Total Time"];
% end
Results = cell2table(Results,'VariableNames',VarNames);
Filename = split(Dir(1).folder,"\");
Filename = [Filename{end-1} ' ' Filename{end}];
writetable(Results,[Filename '.xls'], 'useExcel',true)
% writetable(PositionResults,[Filename ' Position.xls'], 'useExcel',true)

disp('Done!')