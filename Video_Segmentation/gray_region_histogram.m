function [result Counts blockDist]=gray_region_histogram(lastNum,DistThreshold,CountThreshold)
% use gray-level 64-bins histogram in 16 blocks.
% lastNum is the last Number of frame in the video data.
% Two threshold is used to detect great distances. 
% DistThreshold reprents the distance threshold between each block.
% CountThrehold means the count threhold in between each frame.
% Return the array of the number of the last frame in each shot. 
% Also return the array of block counts between each frame
% and block distances in consecutive frames to help user to adjust the thresholds.
tic;
blockHist=cell(4);%to save each hitogram in 16 blocks.
blockDist=zeros(16,lastNum);%to save block distances.
Counts=zeros(1,lastNum);%to save block counts between each frame
for n=1 : lastNum
    int=num2str(n);
    jpg='.jpg';
    imgfile=[int jpg];
    gray=rgb2gray(imread(imgfile));
    [p,q]=size(gray);
    p=floor(p/4);
    q=floor(q/4);
    t=1;
    %compute histogram and distance in 16 blocks
    for i=1:4
        for j=1:4
            block=gray((i-1)*p+1:i*p,(j-1)*q+1:j*q);%divide to 16 blocks
            blockHist{i,j}=sum(hist(double(block),64),2);%histogram
            if(n>1)
                blockDist(t,n-1)=sum(abs(blockHist{i,j}-blockHist_old{i,j}));%distance
            end
            t=t+1;
        end
    end
    if n>1
        %compute the block counts that greater than the distance threshold
        Counts(1,n-1)=length(find(blockDist(:,n-1)>DistThreshold));
    end
    blockHist_old=blockHist;
end
%get result
result=find(Counts>CountThreshold);
%deal with gradual transition
p=length(result);
for n=1:p-1
    if result(1,n+1)-result(1,n)==1
        result(1,n)=0;
    end
end
[n,p,result]=find(result);

toc;