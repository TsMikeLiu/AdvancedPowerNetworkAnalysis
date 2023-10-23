%% 利用稀疏矩阵因子表求解稀疏线性代数方程组
function [x,y,z] = fore_back_compute_xishu(A_xishu,b)
    %A_name = {'U','JU','IU','L','IL','JL','D'};
    N = size(A_xishu.D,1);
    z = zeros(N,1);
    y = zeros(N,1);
    x = zeros(N,1);
    %% z 前代过程
    z = b;
    for i = 1:N-1     %行号从小到大
        if z(i) ~= 0  
            for j = i+1:N   %对z从第二行开始前代
                for w = A_xishu.JL(i):A_xishu.JL(i+1)-1
                    if A_xishu.IL(w) == j
                        z(j) = z(j) - A_xishu.L(w)*z(i);
                    end
                end
            end
        end
    end
    %% y
    for i = 1:N  
        y(i) = z(i)/A_xishu.D(i);
    end
    %% x 回代运算
    x = y;
    for j = N:-1:2
        for i = j-1:-1:1
            for w = A_xishu.IU(i):A_xishu.IU(i+1)-1
                if A_xishu.JU(w) == j
                    x(i) = x(i) - A_xishu.U(w)*x(j);
                end
            end
        end
    end
end