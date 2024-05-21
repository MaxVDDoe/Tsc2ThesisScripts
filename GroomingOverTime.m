function SquareGrooming = GroomingOverTime(Mice)

SquareGrooming.WT = zeros(1,45749);
SquareGrooming.Het = zeros(1,45749);
for CurrentMouse = string(fieldnames(Mice))'
    if isfield(Mice.(CurrentMouse), 'Genotype')
        Genotype = Mice.(CurrentMouse).Genotype;
        if isfield(Mice.(CurrentMouse), 'Grooming')
            SquareGrooming.(Genotype) = SquareGrooming.(Genotype) + Mice.(CurrentMouse).Grooming.OverTime;
        end
    end
end

SmoothSquareGrooming.WT = movmean(SquareGrooming.WT,1000);
figure
plot(SquareGrooming.WT)
hold on
plot(SmoothSquareGrooming.WT,LineWidth=5)
hold off

figure
Fs = 25;
L = 45749;
FourierSmoothSquareGrooming.WT = fft(SmoothSquareGrooming.WT);
plot(Fs/L*(0:L-1),abs(FourierSmoothSquareGrooming.WT),"LineWidth",3)

SmoothSquareGrooming.Het = movmean(SquareGrooming.Het,1000);
figure
plot(SquareGrooming.Het)
hold on
plot(SmoothSquareGrooming.Het,LineWidth=5)
hold off

figure
FourierSmoothSquareGrooming.Het = fft(SmoothSquareGrooming.Het);
plot(Fs/L*(0:L-1),abs(FourierSmoothSquareGrooming.Het),"LineWidth",3)
end