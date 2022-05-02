function [ Trainf,SBPf,DBPf ] = PPGExtractNew(data,i )
Trainf=[];
SBPf=[];
DBPf=[];
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
   ppg= data{i}(1,:);
   abp=data{i}(2,:);
   ecg=data{i}(3,:);
   indexRef=round(length(ppg)/2);
   ppgSegment=ppg(indexRef-5000:indexRef+5000);
   abpSegment=abp(indexRef-5000:indexRef+5000);
   ecgSegment=ecg(indexRef-5000:indexRef+5000);
   ecgSegment=resample(ecgSegment,200,125);
   ecgSegment=smooth(ecgSegment);
   plot( ppgSegment)
   [ footIndex1, systolicIndex1, notchIndex1, dicroticIndex1, time1, bpwaveformppg ]=BP_annotate( ppgSegment, 125, 1, 'mmHg', 1);
   [ footIndex2, systolicIndex2, notchIndex2, dicroticIndex2, time2, bpwaveformabp ]=BP_annotate( abpSegment, 125, 1, 'mmHg', 1);
   
%%%%%%%now: 8000 samples%%%%%%%%%%%%%%%%%%%%%%%%%

for ii=3:length(systolicIndex1)-3
   for jj=1:length(footIndex1)
       if footIndex1(jj)>systolicIndex1(ii)
    maxtemp=footIndex1(jj);
    mintemp=footIndex1(jj-1);
    break;
       end
   end
   
    if jj==length(footIndex1)
            maxtemp=footIndex1(jj);
    mintemp=footIndex1(jj-1);
    end
    
    ppgSegment=bpwaveformppg(mintemp:maxtemp);
    ppgSCSA=ppgSegment;
    for kk=1:length(footIndex2)
        if footIndex2(kk)>footIndex1(ii)
            ABPlow=footIndex2(kk);
            ABPlowb=footIndex2(kk+1);
            break;
        end
    end
    
    if kk==length(footIndex2)
    ABPlow=footIndex2(kk-1);
    ABPlowb=footIndex2(kk);
    end
    
    SBP=max(bpwaveformabp(ABPlow:ABPlowb));
   DBP=bpwaveformabp(ABPlow);
 
   
   [qrspeaks,locs5] = findpeaks(ecgSegment,'MinPeakHeight',0.35,...
    'MinPeakDistance',0.150);
   for ll=1:length(locs5)
       if locs5(ll)>systolicIndex1(ii)
    RpeakRef=locs5(ll);
    break;
       end
   end
   
    if ll==length(locs5)
   RpeakRef=locs5(ll);
    end
    
      [M,I]=max(diff(ppgSCSA));
    PATm=M;
    PATP=maxtemp-RpeakRef;
PATd=maxtemp-mintemp;
feature1=[PATP,PATm,PATd];
HR=length(ppgSCSA);
feature2=HR;
 
   for mm=1:length(notchIndex1)
       if notchIndex1(mm)>systolicIndex1(ii)
           notchloctemp=notchIndex1(mm);
           break;
       end
   end
   if mm==length(notchIndex1)
       notchloctemp=notchIndex1(mm);
   end
   
      for nn=1:length(dicroticIndex1)
       if dicroticIndex1(nn)>systolicIndex1(ii)
           dioloctemp=dicroticIndex1(nn);
           break;
       end
   end
   if nn==length(dicroticIndex1)
       dioloctemp=dicroticIndex1(nn);
   end
       
     PKS62=bpwaveformppg(notchloctemp)  
     PKS61=bpwaveformppg(systolicIndex1(ii))
     feature3=PKS62/PKS61;
     feature4=dioloctemp-systolicIndex1(ii);
     S1=I;
    S2=systolicIndex1(ii)-mintemp-I;
    S3=feature3;
    S4=maxtemp-notchIndex1(mm);
    feature5=[S1,S2,S3,S4];
       A=trapz(ppgSegment);
    B=length(ppgSegment)*0.25;
C=S2;
    TrainPPGS= [feature1,feature2,feature3,feature4,feature5];  
        Trainf=[Trainf;TrainPPGS];
    SBPf=[SBPf;SBP];
    DBPf=[DBPf;DBP];


end
end


