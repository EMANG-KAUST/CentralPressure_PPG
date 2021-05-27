function [Traindata,SBPTarget,DBPTarget]= test(name)
Traindata=[];
SBPTarget=[];
DBPTarget=[];
sum=0;
l=[];
for i=1:3000
    
    try
    [ TrainPPGS,SBP,DBP ]=MimicExtract(name ,i);
    Traindata=[Traindata;TrainPPGS];
    SBPTarget=[SBPTarget;SBP];
    DBPTarget=[DBPTarget;DBP];
    catch 
        continue
    end
end
plot(l)
pause(30)
while 1
    len=length(SBPTarget);
for i=1:length(SBPTarget)
    SBP=SBPTarget(i);
    DBP=DBPTarget(i);
    if SBP>180|SBP<80|DBP>130|DBP<60
     Traindata(i,:)=[];   
     SBPTarget(i,:)=[];
     DBPTarget(i,:)=[];
     break
    end
        
end
if length(SBPTarget)==len
    break
end
end
end

