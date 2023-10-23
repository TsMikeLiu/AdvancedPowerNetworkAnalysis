function A_xishu = xishu_tri_store(A)
    %LDU分解会注入新的非零元素！
    %A_name = {'U','JU','IU','L','IL','JL','D'};
    N = size(A,1);
    A_max = max(max(A));
    %% 为未来注入的元素预留位置
    for i = 1:N-1
        index = find(A(i,:)~=0);
        j_index = find(index>i);
        if length(j_index) > 1
            for k1 = 1:length(j_index)-1
                for k2 = k1+1:length(j_index)
                    new_i = min(index(j_index(k1)),index(j_index(k2)));
                    new_j = max(index(j_index(k1)),index(j_index(k2)));
                    if A(new_i,new_j) == 0
                        A(new_i,new_j) = A_max+1;
                        A(new_j,new_i) = A_max+1;
                    end
                end
            end
        end
    end
  
    flag_row = 0;
    for i = 1:N   %按行存储上三角
        index = find(A(i,:) ~= 0);
        up_index = find(index > i);
        if isempty(up_index)
            if flag_row == 0
                A_xishu.IU(i) = 0;
            else
                b_index = find(A(i-1,:) ~= 0);
                b_up_index = find(b_index > i-1);
                %fprintf('length(b_up_index):%d,num:%d,flag_row:%d\n',length(b_up_index),i,flag_row);
                A_xishu.IU(i) = A_xishu.IU(i-1) + length(b_up_index);
            end
        else
            if flag_row == 0
                A_xishu.U(1:length(up_index)) = A(i,index(up_index));
                A_xishu.JU(1:length(up_index)) = index(up_index);
                A_xishu.IU(i) = 1; 
            else        
                b_index = find(A(i-1,:) ~= 0);
                b_up_index = find(b_index > i-1);
                %fprintf('length(b_up_index):%d,num:%d\n',length(b_up_index),i);
                %b_up_index
                A_xishu.IU(i) = A_xishu.IU(i-1) + length(b_up_index);
                A_xishu.U(end+1:end+length(up_index)) = A(i,index(up_index));
                A_xishu.JU(end+1:end+length(up_index)) = index(up_index);
                                  
            end
            flag_row = i;
        end
    end
    A_xishu.U(find(A_xishu.U==A_max+1)) = 0;


    A_xishu.D = diag(A);


    flag_row = 0;
    A = A';
    for i = 1:N   %转置后按行存储下三角
        index = find(A(i,:) ~= 0);
        up_index = find(index > i);
        if isempty(up_index)
            if flag_row == 0
                A_xishu.JL(i) = 0;
            else
                b_index = find(A(i-1,:) ~= 0);
                b_up_index = find(b_index > i-1);
                A_xishu.JL(i) = A_xishu.JL(i-1) + length(b_up_index);

            end
        else
            if flag_row == 0
                A_xishu.L(1:length(up_index)) = A(i,index(up_index));
                A_xishu.IL(1:length(up_index)) = index(up_index);
                A_xishu.JL(i) = 1; 
              
            else  
                b_index = find(A(i-1,:) ~= 0);
                b_up_index = find(b_index > i-1);
                A_xishu.JL(i) = A_xishu.JL(i-1) + length(b_up_index);
                A_xishu.L(end+1:end+length(up_index)) = A(i,index(up_index));
                A_xishu.IL(end+1:end+length(up_index)) = index(up_index);
            end
            flag_row = i;
        end
    end

    A_xishu.L(find(A_xishu.L==A_max+1)) = 0;
end








