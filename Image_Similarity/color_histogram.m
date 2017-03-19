function histSet=color_histogram(dataSet)
%calculate the region_histogram ( in HSV color space ) of 
%the whole data set for experiment convenience.
%the input is RGB image data set.
%divide the image into 4*4 blocks
%histogram the color feature into 18H*3S*3V bins

Length=length(dataSet);
histSet=cell(Length,16);

for n=1:Length
    HSV=rgb2hsv(dataSet{n,1});%change RGB image to HSV color space.
    H=mod(floor(HSV(:,:,1)*18),18)+1;%scale H to 1-18 
    S=floor(HSV(:,:,2)*2.99)+1;%scale S to 1-3 
    V=floor(HSV(:,:,3)*2.99)+1;%scale V to 1-3 
    [p,q,l]=size(HSV);
    pp=floor(p/4);
    qq=floor(q/4);
    HSV=[H S V];
    t=1;
    for row=1:4
        for col=1:4
            Histogram=initBins(18,3,3);%the histogram has 18*3*3=162 bins.
            %histgram each block into 162 bins
            for j=(row-1)*pp+1:row*pp
                for k=(col-1)*qq+1:col*qq
                    Histogram{HSV(j,k),HSV(j,k+q),HSV(j,k+2*q)}=Histogram{HSV(j,k),HSV(j,k+q),HSV(j,k+2*q)}+1;
                end
            end
            hist=zeros(1,162);
            for i=1:162
                hist(1,i)=Histogram{i};
            end
            %normalize and save each block's histogram
            histSet{n,t}=hist/sum(hist);
            t=t+1;
        end
    end
end

function Bin=initBins(x,y,z)
Bin=cell(x,y,z);
for b1=1:x
    for b2=1:y
        for b3=1:z
            Bin{b1,b2,b3}=0;
        end
    end
end