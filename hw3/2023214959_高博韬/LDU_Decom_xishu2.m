function A_xishu = LDU_Decom_xishu2(A_xishu,N)
    %A_name = {'U','JU','IU','L','IL','JL','D'};
    for p = 1:N-1
        for k = A_xishu.IU(p):A_xishu.IU(p+1)-1
            A_xishu.U(k) =  A_xishu.U(k)/A_xishu.D(p);
            j = A_xishu.JU(k);
            for l = A_xishu.JL(p):A_xishu.JL(p+1)-1
                i = A_xishu.IL(l);
                %fprintf('%d,%d\n',i,j);
                if i == j
                    A_xishu.D(i) = A_xishu.D(i) - A_xishu.U(k)*A_xishu.L(l);
                else if i < j
                    for w = A_xishu.IU(i):A_xishu.IU(i+1)-1
                        if A_xishu.JU(w) == j
                            A_xishu.U(w) = A_xishu.U(w) - A_xishu.U(k)*A_xishu.L(l);
                        end
                    end
                else
                    for w = A_xishu.JL(j):A_xishu.JL(j+1)-1    %要写成j
                        if A_xishu.IL(w) == i
                            A_xishu.L(w) = A_xishu.L(w) - A_xishu.U(k)*A_xishu.L(l);
                        end
                    end
                end
                end

            end
        end
    end

    %    %再对L进行 列规格化
    % for j = 1:N-1
    %     for i = j+1:N
    %         A(i,j) = A(i,j)/A(j,j);
    %     end
    %     %A(j+1:end,j) = A(j+1:end,j)/A(j,j);
    % end

    for j = 1:N-1   %列号
        for w = A_xishu.JL(j):A_xishu.JL(j+1)-1    %要写成j(下三角中对应这一列的各行）
            A_xishu.L(w) = A_xishu.L(w)/A_xishu.D(j);
        end
    end
end
