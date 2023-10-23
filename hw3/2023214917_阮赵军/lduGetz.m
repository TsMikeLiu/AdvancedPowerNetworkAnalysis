% 非稀疏形式的LDU，采用连续回代法求Z
function Z = lduGetz(L,D,U)
[m,n]=size(D);
Z=zeros(n);
Z(n,n)=1/D(n,n);
for i=n-1:-1:1
    for j=n:-1:i+1
        for k=i+1:n
            if U(i,k)~=0&&j>k
                Z(i,j)=Z(i,j)-U(i,k)*Z(k,j);
            elseif U(i,k)~=0&&j<=k
                Z(i,j)=Z(i,j)-U(i,k)*Z(j,k);
            end
        end
    end
    temp=0;
    for k=i+1:n
        if U(i,k)~=0
            temp=temp-U(i,k)*Z(i,k);
        end
    end
    Z(i,i)=1/D(i,i)+temp;
    Z = triu(Z,0) + tril(Z',-1);
end