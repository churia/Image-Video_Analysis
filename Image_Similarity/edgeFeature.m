function edgeSet=edgeFeature(DataSet,L,bin,angle)
%use PHOG to calculate the edge featrue.
%INPUT
% DataSet : image set, will be transform to gray image.
% L: number of pyramid levels, often 0-3
% bin : Number of bins on the histogram 
% angle : 180 or 360
%OUTPUT
%matrix of edge features of the whole data set.  
n=length(DataSet);
for i=1:n
    I = DataSet{i,1};
    [row,col,t]=size(I);
    roi = [1;row;1;col];%Region Of Interest (ytop,ybottom,xleft,xright)
    edgeFeature = anna_phog(I,bin,angle,L,roi);
    edgeSet(i,:) = edgeFeature';
end
