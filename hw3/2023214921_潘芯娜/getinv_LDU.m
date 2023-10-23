function Z = getinv_LDU(A)
% 连续回代法求逆矩阵
    n = length(A(1,:));
    I =diag(ones(n,1));
    [L,D,U] = LDU(A);
    U =U-I;
    Z = D^(-1);
    for i=n-1:-1:1
        for j=n:-1:i+1
            sum1=0;
            for k=i+1:n
                if(k<=j)
                    sum1 =sum1+ U(i,k)*Z(k,j);
                else
                    sum1 =sum1+U(i,k)*Z(j,k);
                    % IMPORTANT！In p46/47 of book (p58/59 of pdf) it says 
                    % use Z(N-1,N) to replace Z(N,N-1) for calculation.
                    % It's because Z(N-1,N) is in the upper triangle 
                    % and Z(N,N-1) is in the lower trianlge, and only the 
                    % upper part of Z is accurate. 
                end
            end
            Z(i,j) = - sum1;
        end
        sum2=0;
        for k=i+1:n
            sum2= sum2+U(i,k)*Z(i,k);
        end
        Z(i,i) = 1/D(i,i)-sum2;
      
    end
    Z=Z'+Z -diag(diag(Z));
end