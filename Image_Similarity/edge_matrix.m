function RankEdgeMatrix=edge_matrix(groud_truth,topic,edgeSet)
%calculate each distance matrix(D1) between the data set and the leave-out-out
%groud truth, and do ranking to the distance matrix
%INPUT
%groud_truth: is the vector of the index of four qeury topics.
%topic: is integer 1 to 4.
%edgeSet: is the edge_hitogram of the whole data set.
%OUTPUT
%return the rank set of 20 experiments for each topic

[n,p]=size(edgeSet);
EdgeMatrix=zeros(n,2);
%leave one out each for 20 times in one topic
for q=1:20
    for i=1:n
        query_edge=edgeSet(groud_truth(1,topic)*20+q,:);
        target_edge=edgeSet(i,:);
        %edge distance matrix(D1)
        %(:,1)contains distances between each target and query,
        %(:,2)contains the index of the image data for ranking and PR computation.
        EdgeMatrix(i,1)=sum(abs(target_edge-query_edge));%calculate L1 distance
        EdgeMatrix(i,2)=i;
    end
    RankEdgeMatrix{q,1}=sortrows(EdgeMatrix,1);
end
