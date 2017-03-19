function [result,Dists]=HSV_base_histogram(lastNum,threshold)
%same as RGB_base_histogram,but in HSV color space, 18*3*3 bins
tic;
jpg='.jpg';
Dists=zeros(1,lastNum);
for i=1 : lastNum
    int=num2str(i);
    imgfile=[int jpg];
    HSV=rgb2hsv(imread(imgfile));
    H=mod(floor(HSV(:,:,1)*18),18)+1;
    S=floor(HSV(:,:,2)*2.99)+1;
    V=floor(HSV(:,:,3)*2.99)+1;
    [p,q,l]=size(HSV);
    HSV=[H S V];
    Histgram=initBins(18,3,3);
    %histgram
    for j=1:p
        for k=1:q
            Histgram{HSV(j,k),HSV(j,k+q),HSV(j,k+2*q)}=Histgram{HSV(j,k),HSV(j,k+q),HSV(j,k+2*q)}+1;
        end
    end
    %distance
    if(i>1)
        dist=0;
        for t=1:162
            dist=dist+abs(Histgram{t}-Histgram_old{t});
        end
        Dists(1,i-1)=dist;
    end
    Histgram_old=Histgram;
end

result=find(Dists>threshold);
p=length(result);
for n=1:p-1
    if result(1,n+1)-result(1,n)==1
        result(1,n)=0;
    end
end
[n,p,result]=find(result);

toc;

function Bin=initBins(x,y,z)
Bin=cell(x,y,z);
for b1=1:x
    for b2=1:y
        for b3=1:z
            Bin{b1,b2,b3}=0;
        end
    end
end
    

    