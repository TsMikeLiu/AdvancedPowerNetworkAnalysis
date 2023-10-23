function [L,D,U] = LDU(A)
    n = length(A(:,1));
    for p =1:n-1
        for j=p+1:n
            A(p,j) = A(p,j)/A(p,p);
            for i=p+1:n
                A(i,j) = A(i,j)-A(i,p)*A(p,j);
            end
        end
    end
    % 取L
    for i=1:n
        for j=1:i
            L(i,j)=A(i,j);
        end
    end
    % L规格化
    D=diag(A);
    D=diag(D);
    L= L*D^(-1);
    U=L';
end