function MatQ=getMatrixQ(mpc)
    TB = find(mpc.branch(:,11)==1);  % 树枝
    LK = find(mpc.branch(:,11)==0);  % 连枝
    TB_branch = mpc.branch(TB,:);
    LK_branch = mpc.branch(LK,:);
    N_branch = size(mpc.branch,1);
    N_node = size(mpc.bus,1);
    N_tree = size(TB,1);
    N_link = size(LK,1);
    
    MatQ = zeros(N_tree,N_branch);
    
    for i=1:N_tree
        fn_tree = TB_branch(i,1);
        tn_tree = TB_branch(i,2);
        mark = (1:N_node)';     % 染色标记
        for j=1:size(TB_branch,1)
            if j~=i
                fn = TB_branch(j,1);
                tn = TB_branch(j,2);
                min_mark = min(mark(fn),mark(tn));  
                max_mark = max(mark(fn),mark(tn));  
                mark([fn,tn]) = min_mark;           % 染色标记为小的一方
                mark(mark==max_mark) = min_mark;    % 与染色标记更大的一方相同的所有染色标记，都变为相同的min_mark
            end
        end
        MatQ(i,i)=1;
        unique_mark = unique(mark);
        if numel(unique_mark)==2
            for k=1:size(LK_branch,1)
                fn = LK_branch(k,1);
                tn = LK_branch(k,2);
                if mark(fn) == mark(fn_tree) && mark(tn) == mark(tn_tree)
                    MatQ(i,N_tree+k) = 1;
                else
                    if mark(fn) == mark(tn_tree) && mark(tn) == mark(fn_tree)
                        MatQ(i,N_tree+k) = -1;
                    end
                end
            end
        end
    end

    % 得到所有连枝子集，利用二进制，同时这种排列方式自动按由少到多的顺序排列，因此一旦找到一个割集，必定是最小割集
%     Link_set = cell(2^N_link,1);
%     for i = 1:2^N_link
%         subset = LK(bitget(i-1, 1:N_link) == 1);
%         Link_set{i} = subset;
%     end
    
%     % 遍历各个树枝和所有连枝子集的组合，判断是否为割集，由于连枝子集的顺序排列，第一个找到的割集必然是最小割集
%     for i = 1:N_tree
%         sel_tree = TB(i);
%         for j = 1:2^N_link
%             sel_links = Link_set{j};
%             sel_br = [sel_tree;sel_links];
%             mark = (1:N_node)';     % 染色标记
%             for k=1:N_branch
%                 if ~ismember(k,sel_br)
%                     fn = mpc.branch(k,1);
%                     tn = mpc.branch(k,2);
%                     min_mark = min(mark(fn),mark(tn));  
%                     max_mark = max(mark(fn),mark(tn));  
%                     mark([fn,tn]) = min_mark;           % 染色标记为小的一方
%                     mark(mark==max_mark) = min_mark;    % 与染色标记更大的一方相同的所有染色标记，都变为相同的min_mark
%                 end
%             end
%             unique_mark = unique(mark);
%             % 如果染色标记只有两种，说明联通图被分为两个子图。树枝的方向为正方向，因此只需要判断每一个连枝的末节点和树枝末节点的染色标记是否相同，相同则表示方向相同，反之不同
%             if numel(unique_mark)==2
%                 % 赋值
%                 MatQ(i,i)=1;
%                 sel_tree_tn = mpc.branch(sel_tree,2);
%                 for k=1:numel(sel_links)
%                     sel_link = sel_links(k);
%                     sel_link_tn = mpc.branch(sel_link,2);
%                     if mark(sel_tree_tn) == mark(sel_link_tn)
%                         MatQ(i,sel_link) = 1;
%                     else
%                         MatQ(i,sel_link) = -1;
%                     end
%                 end
%                 break
%             end
% 
% 
%         end
%     end
end