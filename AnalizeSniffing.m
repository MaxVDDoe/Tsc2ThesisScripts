function Mice = AnalizeSniffing(Mice)
% Variables for that stay the same over the loop
AllMice = fieldnames(Mice);
Conditions = ["Water","Almond","Citron","Home","Same","Diff"];

% For Loop that itterates over all mice names, and subsequently usses that in the loop
for CurrentMouse = string(AllMice)'
    if isfield(Mice.(CurrentMouse), 'Sniffing')
        %Mouse Specific Variables Initialisation
        Mice.(CurrentMouse).Sniffing.TotalSniffing = 0;
        Mice.(CurrentMouse).Sniffing.TotalNonSocial = 0;
        Mice.(CurrentMouse).Sniffing.TotalSocial = 0;
        for Condition = Conditions
            for n = 1:3
                Mice.(CurrentMouse).Sniffing.OverTime.(strcat(Condition, string(n))) = [];
            end
        end
        for i = 2:2:size(Mice.(CurrentMouse).Sniffing.Table,1)
            SniffingTime = Mice.(CurrentMouse).Sniffing.Table.Time(i) - Mice.(CurrentMouse).Sniffing.Table.Time(i-1);
            Mice.(CurrentMouse).Sniffing.TotalSniffing = Mice.(CurrentMouse).Sniffing.TotalSniffing + SniffingTime;
            for Condition = Conditions
                if startsWith(Mice.(CurrentMouse).Sniffing.Table.Condition(i),Condition)
                    Mice.(CurrentMouse).Sniffing.TotalNonSocial = Mice.(CurrentMouse).Sniffing.TotalNonSocial + SniffingTime;
                    for j = 1:3
                        if endsWith(Mice.(CurrentMouse).Sniffing.Table.Condition(i),string(j))
                            Mice.(CurrentMouse).Sniffing.OverTime.(strcat(Condition, string(j))) = [Mice.(CurrentMouse).Sniffing.OverTime.(strcat(Condition, string(j))) SniffingTime];
                        end
                    end
                end
            end
        end
    end
end

