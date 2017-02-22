function v = admmmul(C, i,alpha1, alpha2)

% Solves the following problem via ADMM:
%   f(v) = v^T C_{rest} v +  \beta ||v^T C_i v - 1||_F^2 + \alpha_1  ||Dv||_1
%           + \alpha_2 ||v||_1
    
%% Global constants and defaults
MAX_ITER = 300;
rho1 = 10;
rho2 = 10;
Q = size(C{i},1);

% difference matrix
e = ones(Q,1);
D = spdiags([e -e], 0:1, Q,Q);
I = eye(Q);

%% calculkate C_{rest}
Q = size(C{i},1);
K = length(C);
if i==1
    j=2;
else
    j=1;
end

for k  = 1:K
    if k~=i || k~=j
        C{j} = C{j} + C{k};
    end
end
C{j} = C{j}/(K-1); 

%% ADMM solver
z = 0.1*randn(Q,1);
y = 0.1*randn(Q,1);
u1 = zeros(Q,1);
u2 = zeros(Q,1);
v = randn(Q,1);

R = chol(C{i},'upper');
invR = inv(R);
AtA = invR'*(C{j}+ rho1/2*(D'*D) + rho2/2*I)*invR;
[U,S,~] = svd(AtA);

for k = 1:MAX_ITER
        % v-update
        vold = v;
        Atb = 0.5*invR'*(rho1*D'*(z - u1)+rho2*(y - u2));         
        
        d = U'*Atb;
        lambda = findlam (S, d);       
        temp = diag( ones(Q,1)./( diag(S) - lambda * ones(Q,1)));
        v = invR *( U * (temp * d));
        
        % others
        z = shrinkage(D*v + u1, alpha1/rho1);
        y = shrinkage(v + u2, alpha2/rho2);  
        u1 = u1 + D*v - z;
        u2 = u2 + v - y;
 
        % stopping criterion
        if norm(v - vold)< 0.001
            break;
        end

end

    v(find(abs(v)<0.005))=0;
end


function y = shrinkage(a, kappa)
    y = max(0, a-kappa) - max(0, -a-kappa);
end

function lam = findlam (S,d)
[Q,~] = size(d);
lam = S(Q,Q)*0.9999;
diagS = ones(Q,1)./( diag(S) - lam * ones(Q,1));
flam = (diagS.^2)' * (d.^2)-1;

iter = 0;
temp3 = ones(Q,1);
temp4 = diag(S);
while abs(flam)>1e-5 && iter<30
    diagS = temp3./( temp4 - lam * temp3);
    temp1 = diagS.^2;
    temp2 = d.^2;
    flam = temp1' * temp2 - 1;
    gradlam = 2* ((temp1 .* diagS)'*temp2);
    lam = lam - flam/gradlam;
    iter = iter + 1;
end

end


