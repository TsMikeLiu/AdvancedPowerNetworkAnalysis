% 利用稀疏形式的矩阵LDU，进行前代回代运算，计算Ab=x
function x = ldusolveSparse(U,JU,IU,D,b)
    z=b;
    n=length(z);
    L=U;
    IL=JU;
    JL=IU;
    %前代过程
    for j=1:n-1
        for k=JL(j):JL(j+1)-1
           i=IL(k);
           z(i)=z(i)-L(k)*z(j);
        end
    end

    %除法运算
    for i=1:n
        y(i)=z(i)/D(i);
    end
    x=y;
    %回代运算
    for i=n-1:-1:1
        for k=IU(i+1)-1:-1:IU(i)
            j=JU(k);
            x(i)=x(i)-U(k)*x(j);
        end
    end
end