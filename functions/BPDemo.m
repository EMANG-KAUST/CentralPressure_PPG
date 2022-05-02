function [SBP,SBPT,DBP,DBPT] = BPDemo(filename,patientIndex,RatioT)
% SBP,SBPT,DBP,DBPT is the predictions and ground truths respectively
%   RatioT is the number of elements for testing

%Output
SBP=[];
SBPT=[];
DBP=[];
DBPT=[];

%Train
TrainT=[];
ST=[];
DT=[];


%Test
TrainP=[];
SP=[];
DP=[];

data = importdata(filename);

nl = length(data);

while 1
try
    [ Trainf,SBPf,DBPf ] = ClassExtractContinue( data, patientIndex );
    break
catch
    warning('error in SCSA decomposition, selecting another patient...')
    patientIndex = randi([1 nl]);
    continue
end
end



c=floor(length(SBPf)*RatioT/100);

%Train set for NN training
TrainT=Trainf(1:c,:);
ST=SBPf(1:c);
DT=DBPf(1:c);

%Test set for NN training
TrainP=Trainf(c+1:end,:);
SP=SBPf(c+1:end);
DP=DBPf(c+1:end);

% Train the Network
[netS,netD] = ModelGen(TrainT',ST',DT');

% Test the Network
SBP = netS(TrainP');
DBP = netD(TrainP');
SBPT=SP;
DBPT=DP;

plot(SBP,'r','LineWidth',2)
hold on
plot(DBP,'g','LineWidth',2)
plot(SBPT,'b','LineWidth',2)
plot(DBPT,'y','LineWidth',2)
legend('SBP','DBP','True SBP','True DBP')
title('Blood Pressure (SBP&DBP) estimations','FontSize',10)

end

