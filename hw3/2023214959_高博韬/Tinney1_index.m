function old_index = Tinney1_index(case_name)
    mpc = loadcase(case_name);
    N_node = size(mpc.bus,1);
    N_branch = size(mpc.branch,1);
    node_out = zeros(N_node,1);
    for i = 1:N_node
        for br = 1:N_branch
            if find(mpc.branch(br,1:2) == i)
                node_out(i) = node_out(i) + 1;
            end
        end
    end
    [new_seq,old_index] = sort(node_out);

end