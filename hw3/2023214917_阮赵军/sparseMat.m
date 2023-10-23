%该函数形成对称矩阵的稀疏储存形式（此处对称故将矩阵A存储成上三角矩阵U和对角阵D）
function [U,JU,IU,D] = sparseMat(A)
[m,n]=size(A);
U=[];
JU=[];
IU=[];
for i=1:n-1
    flag=1;
    for j=i+1:n
        if A(i,j)~=0
            U(end+1)=A(i,j);
            JU(end+1)=j;
            if flag==1
                IU(end+1)=length(U);
            end
            flag=0;
        end
    end
end
IU(end+1)=IU(end)+1;
D=diag(A);
end