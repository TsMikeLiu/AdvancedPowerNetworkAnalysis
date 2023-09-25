function MatA=getMatrixA(mpc)
    N_node = size(mpc.bus,1);
    N_branch = size(mpc.branch,1);
    MatA = zeros(N_node,N_branch);

    for i=1:N_branch
        fn = mpc.branch(i,1);
        tn = mpc.branch(i,2);
        MatA(fn,i) = 1;
        MatA(tn,i) = -1;
    end
end