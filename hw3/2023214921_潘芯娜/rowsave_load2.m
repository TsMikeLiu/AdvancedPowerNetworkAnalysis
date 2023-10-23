function Y = rowsave_load2(U,JU,IU,NEXT)
    n=length(IU)-1;
    Y=zeros(n,n);
    for i=1:n
        k=IU(i);
        while (k~=0)
            j = JU(k);
            Y(i,j) = U(k);
            k=NEXT(k);
        end
    end

end