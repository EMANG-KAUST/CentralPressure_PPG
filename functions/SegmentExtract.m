function [featureV] = SegmentExtract(PPGSegment)
ymax=max(PPGSegment);
h=1/pi*sqrt(ymax);
[yscsa ,Nh,eig_v,eig_f] = scsa_build(h,PPGSegment);
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
    featureV= [s1,s2,s3,s4,s5,s6,SF1,SF2,n1,n2];  
end

