function block = extracts( v)
%EXTRACTS blocks from shapelet indicator v
Q = size(v,1); 
local = ones(Q,1); 
z = find(abs(v)<1e-3);
v(z) = 0;
local(z) = 0;

mark = 10000*ones(100,1);
j = 1;
if local(1)==1
    mark(1)  =0;
    j = j+1;
end

for  k =1:Q-1
        if abs(local(k) -local(k+1))==1
        mark(j) = k;  
        j = j+1;
        end
end

if rem(j,2)==0
    mark(j) = Q;
    numofblock = int16(j/2);
else
    numofblock = int16((j-1)/2);
end


num =0;
for k = 1:numofblock
    if mark(2*k) - mark(2*k-1) ==1 || mark(2*k) - mark(2*k-1) ==2
       num = num+1;
       v(mark(2*k-1)+1:mark(2*k))=0;
       mark(2*k-1:2*k) = 10000;
    end       
end

z= find(mark~=10000);
mark = mark(z);
numofblock = numofblock - num;

block = zeros(numofblock,Q);

for k = 1:numofblock
    mask = zeros(Q,1);
    mask (mark(k*2-1)+1:mark(2*k))=1;
    block(k,:) = v'.*mask';
end


end

