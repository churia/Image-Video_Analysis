function [P R]=fusion(colorFeatureSet,edgeFeatureSet,n,groud_truth,topic,weight)
%combine the color feature and edge feature.
%return the P R

RankColorMatrix=color_matrix(groud_truth,topic,colorFeatureSet,weight(topic,:));
RankEdgeMatrix=edge_matrix(groud_truth,topic,edgeFeatureSet);

t=length(RankColorMatrix);
for q=1:t
    fusionRank=zeros(n,2);
    colorRank=RankColorMatrix{q};
    edgeRank=RankEdgeMatrix{q};
    for i=1:n
        if i==colorRank(1,2)
            fusionRank(i,1)=100;
        else
            %Use ¡®Borda Count¡¯ to describe similarity in each feature space,
            %and use weighted sum to calculate the combined similarity.
            fusionRank(colorRank(i,2),1)=fusionRank(colorRank(i,2))+1.5*(1-i/n);
            fusionRank(edgeRank(i,2),1)=fusionRank(edgeRank(i,2))+0.5*(1-i/n);
        end
    end
    fusionRank(:,2)=linspace(1,n,n)';
    RankFusion{q,1}=flipud(sortrows(fusionRank,1));
end
[P,R]=PR(RankFusion,groud_truth,topic,n);