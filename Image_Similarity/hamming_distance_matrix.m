function [Plist,Rlist]=hamming_distance_matrix(groud_truth,topic,featureSet)
%build the binary hashing matrix, and calculate the hamming distance
%then use the distance matrix to do ranking for different k
%return P,R list of 3

[n,d]=size(featureSet);
klist=[d,floor(d/2),floor(d/3)];%init k

for t=1:3
    k=klist(1,t);
    
    %built binary Matrix of n*k
    W=normrnd(0,1,k,d);
    binarySet=(sign(featureSet*W')+ones(n,k))/2;
 
    %calculate the hamming distance between target and query    
    for q=1:20
        query=binarySet(groud_truth(1,topic)*20+q,:);
        query=repmat(query,n,1);
        HammingMatrix(:,1)=sum(xor(binarySet,query),2);
        HammingMatrix(:,2)=linspace(1,n,n)';
        RankHammingMatrix{q,1}=sortrows(HammingMatrix,1);
    end
    
    [P,R]=PR(RankHammingMatrix,groud_truth,topic,n);
    
    Plist(t,:)=P;
    Rlist(t,:)=R;
    
end