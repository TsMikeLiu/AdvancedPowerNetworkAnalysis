% 采用稀疏形式的LDU，由连续回代法求Z
function Z = ldugetSparsez(U,JU,IU,D)
n=length(D);
Z=zeros(n);
Z(n,n)=1/D(n);
for i=n-1:-1:1
    for j=n:-1:i+1
        for l=IU(i+1)-1:-1:IU(i)
            m=JU(l);
            if m>j
                Z(i,j)=Z(i,j)-U(l)*Z(j,m);
            else
                Z(i,j)=Z(i,j)-U(l)*Z(m,j);
            end
        end
    end
    temp=0;
    for t=IU(i+1)-1:-1:IU(i)
        p=JU(t);
        temp=temp-U(t)*Z(i,p);
    end
    Z(i,i)=1/D(i)+temp;
end
Z = triu(Z,0) + tril(Z',-1);
end