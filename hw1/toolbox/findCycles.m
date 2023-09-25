%% 该程序采用深度搜索树DFS来寻找回路，可帮助大家写B矩阵
clear
mpc = case33bw;
start_node = 18;    % 此处仅为示例
cycle = findBasicCycles(mpc,start_node)

%% 函数
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

        % find neighbors
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
                if neighbor == startNode && numel(path) > 2 % find a loop
                    % judge NO link
                    N_Link = 0;
                    for j = 1:numel(path)-1
                        fn = path(j);
                        tn = path(j+1);
                        if (ismember([fn, tn], mpc.branch(LK,1:2), 'rows') || ismember([tn,fn], mpc.branch(LK,1:2), 'rows'))
                            N_Link = N_Link+1;
                        end
                    end
                    if N_Link == 0
                        basicCycles{end+1} = path;
                        return;
                    end
                    
                end 
            end
        end
    end

    % 从起点开始深度优先搜索
    dfs(startNode);
end

