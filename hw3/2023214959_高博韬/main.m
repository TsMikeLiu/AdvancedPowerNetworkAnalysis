clc;clear;
A = [2 -1 0 -1;
    -1 2 -1 0;
    0 -1 2 -1;
    -1 0 -1 4];

N = size(A,1);
A_xishu = xishu_tri_store(A)
%% 题3.1
A_xishuLDU = LDU_Decom_xishu2(A_xishu,N)

%% 题3.2
b = [0,1,0,0]';
[x,y,z] = fore_back_compute_xishu(A_xishuLDU,b);

fprintf('x\t\t|  y\t\t| z\n');
for i = 1:size(A,1)
    fprintf('%.4f\t|  %.4f\t| %.4f\n',x(i),y(i),z(i));
end
%% 题3.7
%使用稀疏阻抗矩阵法求逆阵中对应原矩阵中非零的元素
%Z_SY即是所求，而Z_SU是逆阵中对应因子表中U元素非零的矩阵
%Z_ori为不使用稀疏阻抗矩阵法，仅连续回代过程求得的A的逆阵
[Z_SY,Z_SU,Z_ori] = xishu_max_cb_sub_pro_inv(A,A_xishuLDU)
Z_ori*A
%结果为单位阵
%% 题3.5
%case14
case_name = case14;
mpc = loadcase(case_name);
N_node = size(mpc.bus,1);
N_branch = size(mpc.branch,1);
%% 采用Tinney-1方法
node_seq.old = [1:N_node];
node_seq.Tinney1 = Tinney1_index(case_name);
%% 采用Tinney-2方法
node_seq.Tinney2 = Tinney2_index2(case_name);
fprintf('IEEE 14\n')
fprintf('Tinney-1\t\t\t\t\t|\tTinney-2\n');
for i = 1:N_node
    fprintf('旧节点编号:%d-->新节点编号:%d\t|\t',node_seq.Tinney1(i),i)
    fprintf('旧节点编号:%d-->新节点编号:%d\n',node_seq.Tinney2(i),i)
end

case_name = case30;
mpc = loadcase(case_name);
N_node = size(mpc.bus,1);
N_branch = size(mpc.branch,1);
%% 采用Tinney-1方法
node_seq.old = [1:N_node];
node_seq.Tinney1 = Tinney1_index(case_name);
%% 采用Tinney-2方法
node_seq.Tinney2 = Tinney2_index2(case_name);
fprintf('IEEE 30\n')
fprintf('Tinney-1\t\t\t\t\t|\tTinney-2\n');
for i = 1:N_node
    fprintf('旧节点编号:%d-->新节点编号:%d\t|\t',node_seq.Tinney1(i),i)
    fprintf('旧节点编号:%d-->新节点编号:%d\n',node_seq.Tinney2(i),i)
end



