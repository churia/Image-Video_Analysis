function [result,Dists]=YIQ_base_histogram(lastNum,threshold)
%same as RGB_base_histogram,but in YIQ color space, 16*4*4 bins
tic;
jpg='.jpg';
Dists=zeros(1,lastNum);
for i=1 : lastNum
    int=num2str(i);
    imgfile=[int jpg];
    %transtfer RGB to YIQ and scale Y I Q to 16,4,4
    YIQ=rgb2ntsc(imread(imgfile));
    Y=floor(YIQ(:,:,1)*15.99)+1;
    I=floor((YIQ(:,:,2)+0.5957)/(1.1914)*3.99)+1;
    Q=floor((YIQ(:,:,3)+0.5226)/(1.0452)*3.99)+1;
    [p,q,l]=size(YIQ);
    YIQ=[Y I Q];
    %compute histogram in 16*4*4 bins
    Histgram=initBins(16,4,4);
    for j=1:p
        for k=1:q
            Histgram{YIQ(j,k),YIQ(j,k+q),YIQ(j,k+2*q)}=Histgram{YIQ(j,k),YIQ(j,k+q),YIQ(j,k+2*q)}+1;
        end
    end
    %distance
    if(i>1)
        dist=0;
        for t=1:256
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
    

    