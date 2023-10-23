% 采用非稀疏形式，计算Ax=b
function x = lduSolve(L,D,U,b)
    z=b;
    n=length(z);
    %前代过程
    for i=1:n-1
        if z(i)~=0
            for j=i+1:n
                if L(j,i)~=0
                    z(j)=z(j)-L(j,i)*z(i);
                end
            end
        end
    end

    %除法运算
    dd=diag(D);
    for i=1:n
        y(i)=z(i)/dd(i);
    end
    x=y;
    %回代运算
    for j=n:-1:2
        for i=j-1:-1:1
            x(i)=x(i)-U(i,j)*x(j);
        end
    end
end