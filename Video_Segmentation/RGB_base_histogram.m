function [result,Dists]=RGB_base_histogram(lastNum,threshold)
% use RGB 64-bins histogram.
% lastNum is the last Number of frame in the video data.
% One threshold is used to detect great distances. 
% Return the array of the number of the last frame in each shot. 
% Also return the array of distances in consecutive frames to help user to
% adjust the threshold.
tic;
jpg='.jpg';
Dists=zeros(1,lastNum);
for i=1 : lastNum
    int=num2str(i);
    imgfile=[int jpg];
    RGB=floor(double(imread(imgfile))/64)+1;%divide RGB to 64 bins in 3D
    
    %compute histogram in 64bins
    Histogram=initBins(4,4,4);
    [p,q,l]=size(RGB);
    for j=1:p
        for k=1:q
            Histogram{RGB(j,k,1),RGB(j,k,2),RGB(j,k,3)}=Histogram{RGB(j,k,1),RGB(j,k,2),RGB(j,k,3)}+1;
        end
    end
    
    %compute the distance with the histogram of last frame
    if(i>1)
        dist=0;
        for t=1:64
            dist=dist+abs(Histogram{t}-Histogram_old{t});
        end
        Dists(1,i-1)=dist;
    end
    Histogram_old=Histogram;
end
%get the result
result=find(Dists>threshold);
%deal with gradual transtion
%simply choose the last frame if there are a few consecutive frames
p=length(result);
for n=1:p-1
    if result(1,n+1)-result(1,n)==1 %
        result(1,n)=0;
    end
end
[n,p,result]=find(result);%get the final result

toc;

function Bin=initBins(x,y,z)
%initialize a 4*4*4 cell
Bin=cell(x,y,z);
for b1=1:x
    for b2=1:y
        for b3=1:z
            Bin{b1,b2,b3}=0;
        end
    end
end
    

    