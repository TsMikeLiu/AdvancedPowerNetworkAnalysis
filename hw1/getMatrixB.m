function MatB = getMatrixB(mpc) 
    TB = find(mpc.branch(:,11)==1);     % 树枝
    LK = find(mpc.branch(:,11)==0);     % 连枝
    Link_tn = mpc.branch(LK,2);         % 连枝末节点
    N_loop = size(Link_tn,1);           % 基本回路个数，等于连枝个数
    N_branch = size(mpc.branch,1);      % 支路个数

    MatB = zeros(N_loop,N_branch);

    % 遍历所有连枝的末节点，得到其对应的基本回路，且得到的回路的方向即连枝方向，即回路的正方向
    for i=1:N_loop
        loop = findBasicCycles(mpc,Link_tn(i));
        length_loop = numel(loop);
        for j=1:length_loop-1
            fn = loop(j);
            tn = loop(j+1);
            % 判断支路与回路方向是否相同，若相同则为1
            if ismember([fn, tn], mpc.branch(:,1:2), 'rows')
                br_id = find(mpc.branch(:,1)==fn & mpc.branch(:,2)==tn);
                MatB(i,br_id) = 1;
            end
            % 判断支路与回路反方向是否相同，若相同则为-1
            if ismember([tn, fn], mpc.branch(:,1:2), 'rows')
                br_id = find(mpc.branch(:,1)==tn & mpc.branch(:,2)==fn);
                MatB(i,br_id) = -1;
            end
        end
        % 回路对应的连枝，一定为正方向，为1
        fn = loop(end);
        tn = loop(1);
        br_id = find(mpc.branch(:,1)==fn & mpc.branch(:,2)==tn);
        MatB(i,br_id) = 1;
    end

end

% 输入算例信息和起始节点，给出基本回路，采用深度优先搜索算法DFS
function basicCycles = findBasicCycles(mpc,start_node)
    % 初始化结果数组
    basicCycles = [];

    % 获取图的节点数
    numNodes = size(mpc.bus,1);
    
    % 树枝和连枝
    TB = find(mpc.branch(:,11)==1);  % tree branch
    LK = find(mpc.branch(:,11)==0);  % link

    % 创建一个标志矩阵，用于标记节点是否已经访问过
    visited = false(1, numNodes);

    % 从起始点开始深度优先搜索
    startNode = start_node;
    visited(startNode) = true;
    path = startNode;
    
    % 定义深度优先搜索函数
    function dfs(node)
        if node == startNode && numel(path) > 2
            % 找到一个回路，将其添加到结果中
            basicCycles{end+1} = path;
            return;
        end

        % 找到邻居
        fn_br = find(mpc.branch(:,1)==node);
        tn_br = find(mpc.branch(:,2)==node);
        neighbors = [mpc.branch(fn_br,2);mpc.branch(tn_br,1)];

        for i = 1:numel(neighbors)
            neighbor = neighbors(i);
            if ~visited(neighbor) && (ismember([node, neighbor], mpc.branch(:,1:2), 'rows') || ismember([neighbor,node], mpc.branch(:,1:2), 'rows'))
                visited(neighbor) = true;
                path(end+1) = neighbor;
                dfs(neighbor);
                path(end) = [];
                visited(neighbor) = false;
            else
                if neighbor == startNode && numel(path) > 2 % 找到了一个循环
                    % 判断是否包含连枝
                    N_Link = 0;
                    for j = 1:numel(path)-1
                        fn = path(j);
                        tn = path(j+1);
                        if (ismember([fn, tn], mpc.branch(LK,1:2), 'rows') || ismember([tn,fn], mpc.branch(LK,1:2), 'rows'))
                            N_Link = N_Link+1;
                        end
                    end
                    if N_Link == 0
                        basicCycles = path;
                        return;
                    end
                    
                end 
            end
        end
    end

    % 从起点开始深度优先搜索
    dfs(startNode);
end
