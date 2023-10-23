function old_index = Tinney2_index2(case_name)
    %节点出线度有变化才对
    mpc = loadcase(case_name);
    N_node = size(mpc.bus,1);
    N_branch = size(mpc.branch,1);
    Matrix_br = diag([1:N_node]);
    for i = 1:N_branch
        new_i = min(mpc.branch(i,1:2));
        new_j = max(mpc.branch(i,1:2));
        Matrix_br(new_i,new_j) = i;
        Matrix_br(new_j,new_i) = i;
    end
    delete_node = zeros(N_node,1);
    k = 1;
    flag = 1;  %直到上下三角无零元为止
    k_new_node = 1;
    while flag
       node_out = zeros(N_node,1);
       for i = 1:N_node-1
           if isempty(find(delete_node == i))   %如果不是被消去的节点
               for j = i+1:N_node
                    if Matrix_br(i,j) && isempty(find(delete_node == j))
                        node_out(i) = node_out(i) + 1;  %得到未被消除的各节点出线度
                    end
               end
           end
       end
       for j = 1:N_node-1
            for i = j+1:N_node
                if isempty(find(delete_node == i)) && isempty(find(delete_node == j))  %如果不是被消去的节点
                    if Matrix_br(i,j)
                        node_out(i) = node_out(i) + 1;  %得到未被消除的各节点出线度
                    end
                end
            end
       end
       choose_node_index = zeros(N_node-length(find(delete_node~=0)),1);
       p = 1;
       for i = 1:N_node
           if isempty(find(delete_node == i))
               choose_node_index(p) = i;
               p = p+1;
           end
       end
       temp_index = find(node_out(choose_node_index) == min(node_out(choose_node_index)));
       
       old_index(k_new_node) = choose_node_index(temp_index(1)); %找到出线度最小的节点  
       new_i = old_index(k_new_node);
       k_new_node = k_new_node + 1;
       %每个消去的节点是对应特定的支路添加
       %找到消去节点对应的(i,j),恢复相应置零的点
       k_i = 1;
       %在上三角搜索
       if new_i < N_node
           temp_i = zeros(N_node,1);
           for j = new_i+1:N_node
                if Matrix_br(new_i,j)
                    %存储对应的列号
                    temp_i(k_i) = j;
                    k_i = k_i+1;                  
                end
           end
       end
       %在下三角搜索
       for j = 1:N_node-1
            for i = j+1:N_node
                if i == new_i
                    if Matrix_br(new_i,j)
                     %非零，则存储对应的列号
                        temp_i(k_i) = j;
                        k_i = k_i+1;
                    end
                end
            end
            
       end
       %得到所有对应恢复添加的支路
       not_zero_index = find(temp_i~=0);
       if length(not_zero_index) > 1

            result = nchoosek(temp_i(not_zero_index),2);
           for landa = 1:size(result,1)
               if Matrix_br(result(landa,1),result(landa,2)) == 0 
                   Matrix_br(result(landa,1),result(landa,2)) = 100+k;
                   Matrix_br(result(landa,2),result(landa,1)) = 100+k;
               end
           end          
       end
       
       % 检验修改后的矩阵是否满足跳出循环的条件
       check = 1;
       for i = 1:length(choose_node_index)
           if choose_node_index(i) < N_node
               for j = choose_node_index(i)+1:N_node
                    if isempty(find(delete_node == j))
                        if Matrix_br(choose_node_index(i),j) == 0
                            check = 0;
                            break;
                        end
                    end
               end
           end
           for j = 1:N_node-1
               if isempty(find(delete_node == j))
                    for w = j+1:N_node
                        if w == choose_node_index(i)
                            if Matrix_br(w,j) == 0
                                check = 0;
                                break;
                            end
                        end
                    end
               end
           end
           if check == 0
               break;
           end
       end
       if check == 1
           flag = 0;
       end
       delete_node(k) = new_i;
       k = k+1;
    end
    final_len = length(choose_node_index);
    old_index(k_new_node-1:k_new_node+final_len-2) = choose_node_index;
end