function RankColorMatrix=color_matrix(groud_truth,topic,histSet,weight)
%calculate each distance matrix(D1 with weighting) between the data set 
%and the leave-out-out groud truth, and do ranking to the distance matrix
%INPUT
%groud_truth: is the vector of the index of four qeury topics.
%topic: is integer 1 to 4.
%histSet: is the region_hitogram of the whole data set.
%weight: is the weight vector of each region.
%OUTPUT
%return the rank set of 20 experiments for each topic

n=length(histSet);
%color distance matrix(D1)
%(:,1)contains distances between each target and query,
%(:,2)contains the index of the image data for ranking and PR computation.
ColorMatrix=zeros(n,2);
%leave one out each for 20 times in one topic
leave_one_out=20;
for query=1:leave_one_out
    for i=1:n
        for j=1:16
            query_histogram=histSet{groud_truth(1,topic)*20+query,j};
            target_histogram=histSet{i,j};
            %compute the D1 region_histogram distance with region weight
            blockDist=sum(abs(target_histogram-query_histogram));
            ColorMatrix(i,1)=ColorMatrix(i,1)+weight(1,j)*blockDist;
        end
        ColorMatrix(i,2)=i;
    end
    %rank the matrix by distance and calculate the P-R
    RankColorMatrix{query,1}=sortrows(ColorMatrix,1);
end
