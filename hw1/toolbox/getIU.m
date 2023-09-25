% 算例导入
mpc = case33bw_closed;

% 潮流计算
results = runpf(case33bw_closed);

% 列编号
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;

% 获取节点电压幅值和相角信息
voltage_magnitude = results.bus(:, VM); % 节点电压幅值
voltage_angle = results.bus(:, VA);     % 节点相角

% 获取节点导纳信息
Ybus = makeYbus(mpc.baseMVA, mpc.bus, mpc.branch); % 构建节点导纳矩阵

% 计算各个节点的注入电流（复数形式）
injection_current = Ybus * (voltage_magnitude .* exp(1i * deg2rad(voltage_angle)));

% 分别获取注入电流的实部和虚部
real_injection_current = real(injection_current);
imag_injection_current = imag(injection_current);
