% 将稀疏形式的矩阵还原为非稀疏形式，便于检验
function [L1,D1,U1] = generateA(U,JU,IU,D)
    D1=diag(D);
    n=length(D);
    U1=eye(n);
    for i=1:n-1
        for k=IU(i):IU(i+1)-1
            U1(i,JU(k))=U(k);
        end
    end
    L1=U1';
end