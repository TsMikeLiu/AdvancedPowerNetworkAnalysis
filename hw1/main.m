clc
clear
mpc= case33bw;
[n,~] = size(mpc.bus);%节点数
[L,~] = size(mpc.branch);%支路数

%% 树&补树
L_G_id = find(mpc.branch(:,11)==0);
L_G = mpc.branch(L_G_id,:);
[L_Gnum,~]=size(L_G);

%% 节支关联矩阵
MatA=getMatrixA(mpc);
MatAT=MatA(2:33,1:L-L_Gnum);
MatAL=MatA(2:33,L-L_Gnum+1:L);

%% 回支关联矩阵
MatB=getMatrixB(mpc);

%% 割支关联矩阵
MatQ=getMatrixQ(mpc);

%% 第四题验证关系
G=MatA*(MatB');
H=MatQ*(MatB');

%% 附加题
% 所有支路联通
mpc.branch(L_G_id,11) = 1;

% 潮流计算
results=runpf(mpc);

Um=results.bus(:,8);        % 电压幅值
Ua=results.bus(:,9);        % 电压相角
U=Um.*exp(1j*Ua/180*pi);    % 电压相量
P=results.branch(:,14);     % 支路首段有功
Q=results.branch(:,15);     % 支路首段无功

UB=MatA'*U;                 % 线电压

KVL=MatB*UB;                % KVL
S=P+1j*Q;                   % 注入视在功率
I=conj(S./UB);              % 注入电流
KCL=sum(MatA*I);            % KCL




