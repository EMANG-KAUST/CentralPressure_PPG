function [ TrainPPGS,SBP,DBP ] = MimicExtract( data,i )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   ppg= data{i}(1,:);
   abp=data{i}(2,:);
   indexRef=round(length(ppg)/2);
   ppgSegment=ppg(indexRef-500:indexRef+500);
   
   [PKS1,LOCS1,W1,P1] = findpeaks(ppgSegment);
   [PKS2,LOCS2,W2,P2] = findpeaks(-ppgSegment);
   maximaIndexRef=LOCS1(round(length(LOCS1)/2));
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
   ppgSCSA=ppgSegment(minimalIndexRefb:minimaIndexRef);
%    plot(ppgSCSA)
   ppgSCSA=ppgSCSA;
   abpSegment=abp(indexRef-100:indexRef+100);
   [PKS1,LOCS1,W1,P1] = findpeaks(abpSegment);
   [PKS2,LOCS2,W2,P2] = findpeaks(-abpSegment);
   SBP=mean(PKS1);
   DBP=-mean(PKS2);
%    [ ho ] = hdeter( ppgSCSA )
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
   Nh
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
    TrainPPGS= [s5,s6,n1,n2];  
    %%%%%%%%%%%%%%%%%%below is for testing$$$$$$$$$$$$$$$$$$$$$$$$$$$$
    TrianPPGS=[];
    for i=1:size(eig_v,1)
        TrainPPGS(end+1)=eig_v(i,i);
    end
    if length(TrainPPGS)<10
        for j=1:10-length(TrainPPGS)
            TrainPPGS(end+1)=0;
        end
    end
    if length(TrainPPGS)>10
        TrainPPGS=TrainPPGS(1:10);
    end
    
     %TrainPPGS= [-minimalIndexRefb+maximaIndexRef,-minimalIndexRefb+minimaIndexRef,trapz(ppgSegment)];  


end

