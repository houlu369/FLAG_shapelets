function C = comC(train, train_label,K )
%COMC computes covariance matrices
[N,Q] = size(train);
C = cell(K,1);
gamma = 0.001;

for i = 1:K 
    z = find(train_label == i);
    C{i} = train(z,:)'*train(z,:);
    C{i} = C{i}/length(z);
    C{i} = C{i} + gamma/Q*trace(C{i}) * eye(Q);
end

end


