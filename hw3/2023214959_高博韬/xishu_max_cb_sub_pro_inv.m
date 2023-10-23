%% Y即题中的A
function [Z_SY,Z_SU,Z_ori] = xishu_max_cb_sub_pro_inv(A,A_xishu)
    %A_name = {'U','JU','IU','L','IL','JL','D'};
    N = size(A,1);
    Z = zeros(size(A));
    Z(N,N) = 1/A_xishu.D(N);

    Z_ori = zeros(size(A));
    Z_ori(N,N) = 1/A_xishu.D(N);
    for i = N-1:-1:1
        for w1 = A_xishu.IU(i+1)-1:-1:A_xishu.IU(i)
            j = A_xishu.JU(w1);
            for w2 = A_xishu.IU(i+1)-1:-1:A_xishu.IU(i)
                k = A_xishu.JU(w2);
                Z(i,j) = Z(i,j) - A_xishu.U(w2)*Z(min(k,j),max(k,j));    %仅求上三角矩阵，确保列号大于行号
            end
        end

        % 求Z的所有元素，即 Z_ori
        for j = N:-1:i+1
            for w2 = A_xishu.IU(i+1)-1:-1:A_xishu.IU(i)
                k = A_xishu.JU(w2);
                Z_ori(i,j) = Z_ori(i,j) - A_xishu.U(w2)*Z_ori(min(k,j),max(k,j));    %仅求上三角矩阵，确保列号大于行号
            end
        end


        temp_var = 0;
        for w = A_xishu.IU(i):A_xishu.IU(i+1)-1
            k = A_xishu.JU(w);
            temp_var = temp_var + A_xishu.U(w)*Z(i,k);
        end
        
        Z(i,i) = 1/A_xishu.D(i) - temp_var;
        Z_ori(i,i) = 1/A_xishu.D(i) - temp_var;
    end
    %Z的逆阵（所有元素）
    Z_ori = Z_ori+triu(Z_ori,1)';
    %Z对应U中不为零的元素
    Z_SU = Z+triu(Z,1)';
    for i = 1:N-1
        for j = i+1:N
            if A(i,j) == 0
                Z(i,j) = 0;
            end
        end
    end
    %Z对应Y中不为零的元素
    Z_SY = Z+triu(Z,1)';
end