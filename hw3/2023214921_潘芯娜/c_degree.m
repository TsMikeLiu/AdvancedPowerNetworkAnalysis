function degree =c_degree(br,n_nodes)
n_br =length(br(:,1));
degree =zeros(n_nodes,1);
for i= 1:n_br
    degree(br(i,1)) = degree(br(i,1))+1;
    degree(br(i,2)) = degree(br(i,2))+1;
end
end