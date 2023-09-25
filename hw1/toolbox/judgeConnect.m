%% 该程序采用染色的方法来判断联通性，可帮助大家写Q矩阵
clear
mpc = case33bw;

% 列索引
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

N_br = size(mpc.branch,1);
N_node = size(mpc.bus,1);

% 判断联通性
sel_br = [12 14];       % 选择断开的支路，此处仅为示例！
mark = (1:N_node)';     % 染色标记
for i=1:N_br
    if ~ismember(i,sel_br)
        fn = mpc.branch(i,1);
        tn = mpc.branch(i,2);
        min_mark = min(mark(fn),mark(tn));
        max_mark = max(mark(fn),mark(tn));
        mark([fn,tn]) = min_mark;
        mark(mark==max_mark) = min_mark;
    end
end
if mark==1
    disp('Connect')
end

