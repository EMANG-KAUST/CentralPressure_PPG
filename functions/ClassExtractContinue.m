function [ Trainf,SBPf,DBPf ] = ClassExtractContinue( data,i )
Trainf=[];
SBPf=[];
DBPf=[];
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   ppg= data{i}(1,:);
   abp=data{i}(2,:);
   ecg=data{i}(3,:);
   indexRef=round(length(ppg)/2);
   ppgSegment=ppg(indexRef-2500:indexRef+2500);
   abpSegment=abp(indexRef-2500:indexRef+2500);
   ecgSegment=ecg(indexRef-2500:indexRef+2500);
   [PKS1,LOCS1,W1,P1] = findpeaks(ppgSegment);
   [PKS2,LOCS2,W2,P2] = findpeaks(-ppgSegment);
    [PKS5,LOCS5,W5,P5] = findpeaks(ecgSegment);
   for k=1:length(LOCS2)-3      
   maximaIndexRef=LOCS1(k+1);
   minimaIndexRef=0;
   for j=1:length(LOCS2)
       if LOCS2(j)>maximaIndexRef
           minimaIndexRef=LOCS2(j);
           break;
       end
   end
   j=j-1;
   minimaIndexRefb=0;
   while LOCS2(j)>maximaIndexRef
       j=j-1;
   end
   minimalIndexRefb=LOCS2(j);
   for mm=1:length(LOCS5)
       if LOCS5(mm)>maximaIndexRef
           RpeakRef=LOCS5(mm-1);
           break;
       end
    end
   ppgSCSA=ppgSegment(minimalIndexRefb:minimaIndexRef);
    [yscsa ,Nh,eig_v,eig_f] = scsa_build(0.5,ppgSCSA);
   intervalLength=-minimalIndexRefb+minimaIndexRef;
%    plot(ppgSCSA)
    
   ABPSegmentSample=abpSegment(round(minimalIndexRefb-0.1*intervalLength):round(minimaIndexRef+0.1*intervalLength));
   SBP=max(ABPSegmentSample);
   DBP=min(ABPSegmentSample);
[M,I]=max(diff(ppgSCSA));
PATm=M;
PATP=maximaIndexRef-RpeakRef;
PATd=maximaIndexRef-minimalIndexRefb;
feature1=[PATP,PATm,PATd];
HR=length(ppgSegment);
feature2=HR;
[PKS6,LOCS6,W6,P6] = findpeaks(ppgSegment);
if length(PKS6)>1
    feature3=PKS6(2)/PKS6(1);
    feature4=LOCS6(2)-LOCS6(1);
    S1=I;
    S2=LOCS6(1)-I;
    S3=feature3;
    S4=length(ppgSegment)-LOCS6(2);
    feature5=[S1,S2,S3,S4];
else
    feature3=0;
    feature4=0;
    S1=I;
    S2=LOCS6(1)-I;
    S3=0;
    S4=length(ppgSegment)-LOCS6(1);
    feature5=[S1,S2,S3,S4];
    error('error ')
end


%    hold on
%    plot(ppgSCSA)

   % TrainPPGS= [feature1,feature2,feature3,feature4,feature5];  
   TrainPPGS= [1/feature1(2)];
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   TrainPPGS=[];
       SF1=0;
    SF2=0;
    s1=eig_v(1,1);
    s2=eig_v(2,2);
    s3=eig_v(3,3);
    s4=eig_v(3,3);
    s6=eig_v(3,3);
    for k=1:min([size(eig_v,1)])
    s3=s3+eig_v(k,k);
    end
    s4=eig_v(1,1)+eig_v(2,2);
    s5=0;
    s6=0;
    for k=1:min([3,size(eig_v,1)])
    SF1=SF1+eig_v(k,k);
    SF2=SF2+eig_v(k,k)^3*4/3;
    end
    for j=min([3,size(eig_v,1)]):size(eig_v,1)
    s5=s5+eig_v(j,j);
    s6=s6+eig_v(j,j)^3*4/3;
    end
    n1=eig_v(end,end);
    n2=eig_v(end-1,end-1);
    TrainPPGS= [s1,s2,s3,s4,s5,s6,n1,n2];  
%     for i=1:size(eig_v,1)
%         TrainPPGS(end+1)=eig_v(i,i);
%     end
%     if length(TrainPPGS)<10
%         for j=1:10-length(TrainPPGS)
%             TrainPPGS(end+1)=0;
%         end
%     end
%     if length(TrainPPGS)>10
%         TrainPPGS=TrainPPGS(1:10);
%     end
         Trainf=[Trainf;TrainPPGS];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%test%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SBPf=[SBPf;SBP];
    DBPf=[DBPf;DBP];
   end
   
end

