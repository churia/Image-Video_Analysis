function [result Counts blockDist]=RGB_region_histogram(lastNum,DistThreshold,CountThreshold)
% use 4*4*4 bins histogram in 16 blocks.
% lastNum is the last Number of frame in the video data.
% Two threshold is used to detect great distances. 
% DistThreshold reprents the distance threshold between each block.
% CountThrehold means the count threhold in between each frame.
% Return the array of the number of the last frame in each shot. 
% Also return the array of block counts between each frame
% and block distances in consecutive frames to help user to adjust the thresholds.
tic;
blockHist=cell(4);
blockDist=zeros(16,lastNum);
Counts=zeros(1,lastNum);
for n=1 : lastNum
    int=num2str(n);
    jpg='.jpg';
    imgfile=[int jpg];
    RGB=floor(double(imread(imgfile))/64)+1;%divide RGB to 64 bins in 3D
    [p,q,l]=size(RGB);
    p=floor(p/4);
    q=floor(q/4);
    t=1;
    %compute histogram and distance in 16 blocks
    for i=1:4
        for j=1:4
            Histgram=initBins(4,4,4);
            block=RGB((i-1)*p+1:i*p,(j-1)*q+1:j*q,1:3);
            %compute histogram in 64bins
            [w,m,l]=size(block);
            for u=1:w
                for v=1:m
                    Histgram{block(u,v,1),block(u,v,2),block(u,v,3)}=Histgram{block(u,v,1),block(u,v,2),block(u,v,3)}+1;
                end
            end
            blockHist{i,j}=Histgram;
            %distance
            if(n>1)
                dist=0;
                for b=1:64
                    dist=dist+abs(blockHist{i,j}{b}-blockHist_old{i,j}{b});
                end
                blockDist(t,n-1)=dist;
            end
            t=t+1;
        end
    end
    if  n>1
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