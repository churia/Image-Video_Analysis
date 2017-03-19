function [result,Dists]=gray_base_histogram(lastNum,threshold)
% use gray-level 64-bins histogram.
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
    gray=rgb2gray(imread(imgfile)); %transfer to gray-level
    histogram=sum(hist(double(gray),64),2);%compute the histogram of the frame.
    if(i>1)
        %compute the distance with the histogram of last frame
        Dists(1,i-1)=sum(abs(histogram-histogram_old));
    end
    histogram_old=histogram;
end
%get the result
%deal with gradual transtion
%simply choose the last frame if there are a few consecutive frames
result=find(Dists>threshold);
p=length(result);
for n=1:p-1
    if result(1,n+1)-result(1,n)==1
        result(1,n)=0;
    end
end
[n,p,result]=find(result);%get the final result

toc;