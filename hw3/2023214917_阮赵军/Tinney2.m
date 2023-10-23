function  [F_BUS, T_BUS, comIndex]= Tinney2(casenum)
mpc=loadcase(casenum);
FB=mpc.branch(:,1);
TB=mpc.branch(:,2);
branchnum=length(FB);
busnum=length(mpc.bus(:,1));
index=[];
for i=1:busnum
    busDegree(i)=length(find(FB==i))+length(find(TB==i));
end
adjacencyMat=zeros(busnum);
for j=1:busnum
    adjacencyMat(TB(find(FB==j)),j)=1;
    adjacencyMat(FB(find(TB==j)),j)=1;
end
k=min(busDegree);
flagindex=zeros(1,busnum);
while 1
    if k==1
       colnum=find(busDegree==k);
       for l=colnum
           rownum=find(adjacencyMat(:,l)==1);
           adjacencyMat(l,rownum)=0;
           adjacencyMat(rownum,l)=0;
           busDegree=sum(adjacencyMat,1);
           index(end+1)=l;
           flagindex(l)=1;
       end
    else
       colnum=find(busDegree==k);
       l=colnum(1);
       rownum=find(adjacencyMat(:,l)==1);
       adjacencyMat(l,rownum)=0;
       adjacencyMat(rownum,l)=0;
       index(end+1)=l;
       flagindex(l)=1;
       for n=rownum'
           adjacencyMat(n,setdiff(rownum,n))=1;
       end
       busDegree=sum(adjacencyMat,1);
    end
    k=min(busDegree(find(busDegree-min(busDegree))));
    if length(find(flagindex==0))==1
       index(end+1)=find(flagindex==0);
       flagindex(find(flagindex==0))=1;
    end
    if flagindex==1
        break
    end
end
for i=1:branchnum
    F_BUS(i,1)=find(index==FB(i));
    T_BUS(i,1)=find(index==TB(i));
end
comIndex=[(1:busnum)',index'];
end