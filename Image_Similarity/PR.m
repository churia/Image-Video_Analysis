function [P,R]=PR(rank,groud_truth,topic,n)
%compute the average Precision and Recall
%INPUT
%groud_truth: is the vector of the index of four qeury topics.
%topic: is integer 1 to 4.
%n: is the size of data set.
for t=1:20
    PrecisionCount=0;
    RecallCount=0;
    for i=2:n %the first rank is the query image itself
        matrix=rank{t};
        if matrix(i,2)>=groud_truth(1,topic)*20+1 && matrix(i,2)<=groud_truth(1,topic)*20+20
            PrecisionCount=PrecisionCount+1;
            RecallCount=RecallCount+1;
        end
        P(i-1,t)=PrecisionCount/(i-1);%compute precision
        R(i-1,t)=RecallCount/19;%compute recall
    end
end
%get average of 20
P=mean(P,2);
R=mean(R,2);