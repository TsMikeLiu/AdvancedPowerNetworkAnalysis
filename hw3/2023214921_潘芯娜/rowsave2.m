function [U,JU,IU,NEXT]=rowsave2(A)
% add linkform 'NEXT' compared to function 'rowsave'
% get L,IL and JL while [L IL JL NEXT] = rowsave2(A');
    k=0; U=[];JU=[];IU=[];NEXT=[];
    n =length(A(:,1));
    
    for i=1:n
        IU(i)=k+1;
        IU(i+1) =k+2;% to get the final element for IU
        for j=i:n
            if(A(i,j)~=0)
                k=k+1;
                U(k)=A(i,j);
                JU(k)= j;
            end
        end
    end
    
    k=0;
    for i=1:n
        for j=IU(i):IU(i+1)-1
            k=k+1;
            if j <(IU(i+1)-1)
                NEXT(k) = k+1;
            else
                NEXT(k) = 0;
            end
        end
    end
    % if there
    NEXT = NEXT(1:length(U'));
    q =find(IU>(length(U')+1));
    IU(q) =[];

end