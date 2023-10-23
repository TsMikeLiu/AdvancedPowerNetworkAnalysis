function  [F_BUS,T_BUS,comIndex]= Tinney1(casenum)
mpc=loadcase(casenum);
FB=mpc.branch(:,1);
TB=mpc.branch(:,2);
branchnum=length(FB);
busnum=length(mpc.bus(:,1));
for i=1:busnum
    busDegree(i)=length(find(FB==i))+length(find(TB==i));
end
[~,index]=sortrows(busDegree');
for i=1:branchnum
    F_BUS(i,1)=find(index==FB(i));
    T_BUS(i,1)=find(index==TB(i));
end
comIndex=[(1:busnum)',index];
end