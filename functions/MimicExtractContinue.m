function [ Trainf,SBPf,DBPf ] = MimicExtractContinue( data,i )
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
   intervalLength=-minimalIndexRefb+minimaIndexRef;
    [M,I]=max(diff(ppgSCSA));
PATm=M;
PATP=maximaIndexRef-RpeakRef;
PATd=maximaIndexRef-minimalIndexRefb;
feature1=[PATP,PATm,PATd];
  
%    plot(ppgSCSA)
 
   ABPSegmentSample=abpSegment(round(minimalIndexRefb-0.1*intervalLength):round(minimaIndexRef+0.1*intervalLength));
   SBP=max(ABPSegmentSample);
   DBP=min(ABPSegmentSample);

   lll=length(ppgSCSA);
if lll<50
   [yscsa ,Nh,eig_v,eig_f] = scsa_build(0.5,ppgSCSA);
end
if lll>50 && lll<100
   [yscsa ,Nh,eig_v,eig_f] = scsa_build(0.5,ppgSCSA);
end
if lll>99
   [yscsa ,Nh,eig_v,eig_f] = scsa_build(0.5,ppgSCSA);
end
   Nh;
%    plot(yscsa)
%    hold on
%    plot(ppgSCSA)
    SF1=0;
    SF2=0;
    s1=eig_v(1,1);
    s2=eig_v(2,2);
    s3=eig_v(3,3);
    s4=eig_v(3,3);
    s6=eig_v(3,3);
    for kkk=1:min([size(eig_v,1)])
    s3=s3+eig_v(kkk,kkk);
    end
    s4=eig_v(1,1)+eig_v(2,2);
    s5=0;
    s6=0;
    for kkk=1:min([3,size(eig_v,1)])
    SF1=SF1+eig_v(kkk,kkk);
    SF2=SF2+eig_v(kkk,kkk)^3*4/3;
    end
    for j=min([3,size(eig_v,1)]):size(eig_v,1)
    s5=s5+eig_v(j,j);
    s6=s6+eig_v(j,j)^3*4/3;
    end
    n1=eig_v(end,end);
    n2=eig_v(end-1,end-1);
    TrainPPGS= [s1,s2,s3,s4,s5,s6,SF1,SF2,n1,n2];  
        Trainf=[Trainf;TrainPPGS];
    SBPf=[SBPf;SBP];
    DBPf=[DBPf;DBP];
   end

end

