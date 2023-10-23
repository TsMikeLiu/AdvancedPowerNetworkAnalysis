% 该函数根据得到的稀疏形式的矩阵，进行LDU分解，存储为稀疏形式的U矩阵和对角阵D（LDU=U'DU，故只存储U和D即可）
function [U,JU,IU,D] = lduSparse(U,JU,IU,D)
    n=length(D);
    L=U;
    IL=JU;
    JL=IU;
    for p=1:n-1
        for k=IU(p):IU(p+1)-1
            U(k)=U(k)/D(p);
            j=JU(k);
            for l=JL(p):JL(p+1)-1
                i=IL(l);
                if i==j
                    D(i)=D(i)-U(k)*L(l);
                elseif i<j
                    for m=IU(i):IU(i+1)-1
                        if j==JU(m)
                            U(m)=U(m)-U(k)*L(l);
                        elseif j>JU(m)
                            U=[U(1:m),-U(k)*L(l),U(m+1:end)];
                            JU=[JU(1:m),j,JU(m+1:end)];
                            IU=[IU(1:i),IU(i+1:end)+1];
                            continue
                        elseif j<JU(IU(l))
                            U=[U(1:IU(l)-1),-U(k)*L(l),U(IU(l):end)];
                            JU=[JU(1:IU(l)-1),j,JU(IU(l):end)];
                            IU=[IU(1:i),IU(i+1:end)+1];
                            continue
                        end
                    end                           
                else
                    for t=JL(j):JL(j+1)-1
                        if i==IL(t)
                            L(t)=L(t)-U(k)*L(l);
                        elseif i>IL(t)
                            L=[L(1:t),-U(k)*L(l),L(t+1:end)];
                            IL=[IL(1:t),i,IL(t+1:end)];
                            JL=[JL(1:j),JL(j+1:end)+1];
                            continue
                        elseif i<IL(JL(j))
                            L=[L(1:JL(j)-1),-U(k)*L(l),L(JL(j):end)];
                            IL=[IL(1:JL(j)-1),i,IL(JL(j):end)];
                            JL=[JL(1:j),JL(j+1:end)+1];
                            continue
                        end
                    end
                end
            end
        end
    end
end