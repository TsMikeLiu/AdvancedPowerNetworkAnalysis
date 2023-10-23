%%
clear
clc
%% 读取A矩阵，并保存为稀疏形式
A=[2 -1 0 -1;-1 2 -1 0;0 -1 2 -1;-1 0 -1 4]
[U,JU,IU,D] = sparseMat(A)

%% 由稀疏形式的A矩阵，进行LDU分解，再将其还原为非稀疏形式的LDU
[U,JU,IU,D] = lduSparse(U,JU,IU,D);
[L1,D1,U1] = generateA(U,JU,IU,D)
A1=L1*D1*U1

%% 由非稀疏形式的A矩阵，进行LDU分解
[L2,D2,U2] = lduFactorization(A)
A2=L2*D2*U2

%% 由稀疏形式的LDU计算Ax=b
b=[0;1;0;0];
x1 = ldusolveSparse(U,JU,IU,D,b)

%% 由非稀疏形式的LDU计算Ax=b
b=[0;1;0;0];
x2 = lduSolve(L2,D2,U2,b)

%% 由稀疏形式的LDU，连续回代法求Z(3.7的纸质版作业上次已经提交，这次就没有提交)
Z1 = ldugetSparsez(U,JU,IU,D)

%% 由非稀疏形式的LDU，连续回代法求Z
Z2 = lduGetz(L1,D1,U1)

%% Tinney1 and Tinney2
clc
clear
% Case14
%Tinny1
[F1_BUS,T1_BUS,comIndex1]=Tinney1(case14);
G1=graph(F1_BUS,T1_BUS);
disp('Tinney1(Case14):')
comIndex1

%Tinney2
[F2_BUS,T2_BUS,comIndex2]=Tinney2(case14);
G2=graph(F2_BUS,T2_BUS);
disp('Tinney2(Case14):')
comIndex2

%Original
mpc=loadcase(case14);
F_BUS=mpc.branch(:,1);
T_BUS=mpc.branch(:,2);
G=graph(F_BUS,T_BUS);

figure(1)
subplot(1,3,1)
plot(G)
title('Case14 Original')
subplot(1,3,2)
plot(G1)
title('Case14 Tinney1')
subplot(1,3,3)
plot(G2)
title('Case14 Tinney2')
%%
clear
% Case30
%Tinny1
[F1_BUS,T1_BUS,comIndex1]=Tinney1(case30);
G1=graph(F1_BUS,T1_BUS);
disp('Tinney1(Case30):')
comIndex1

%Tinney2
[F2_BUS,T2_BUS,comIndex2]=Tinney2(case30);
G2=graph(F2_BUS,T2_BUS);
disp('Tinney2(Case30):')
comIndex2

%Original
mpc=loadcase(case30);
F_BUS=mpc.branch(:,1);
T_BUS=mpc.branch(:,2);
G=graph(F_BUS,T_BUS);

figure(1)
subplot(1,3,1)
plot(G)
title('Case30 Original')
subplot(1,3,2)
plot(G1)
title('Case30 Tinney1')
subplot(1,3,3)
plot(G2)
title('Case30 Tinney2')