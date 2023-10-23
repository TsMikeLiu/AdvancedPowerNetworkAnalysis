%非稀疏形式将A分解为LDU
function [L,D,U] = lduFactorization(A)
    [m, n]=size(A);
    for p=1:n-1
        for j=p+1:n
            A(p,j)=A(p,j)/A(p,p);
            for i=p+1:n
                A(i,j)=(A(i,j)-A(i,p)*A(p,j));
            end
        end
    end
    L=tril(A);
    D=diag(diag(A));
    U=triu(A,1)+eye(n);
    for p=1:n-1
        for i=p+1:n
            L(i,p)=L(i,p)/L(p,p);
        end
    end
    L=tril(L,-1)+eye(n);
end