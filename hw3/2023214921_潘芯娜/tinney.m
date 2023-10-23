function [tinney1 tinney2] = tinney(br)
a =unique(br);
n_nodes =length(a);
% tinney 1 
d1 = c_degree(br,n_nodes);
d1 =[(1:n_nodes)' d1];
[~,idx]=sort(d1(:,2));
d1 = d1(idx,:);
tinney1 =d1(:,1);
% tinney 2
tinney2 = [];
while(length(tinney2)~=n_nodes-2)
    d2 =c_degree(br,n_nodes);
    junk =find(d2 == 0);
    d2(junk) = 1000;
    [~,idx] =min(d2);
    tinney2 = [tinney2; idx];
        % delete the min degree nodes
        c2=[];
        junk =find(br(:,1) == idx);
        c2 =[c2;br(junk,2)];
        br(junk,:) =[];
        junk =find(br(:,2) == idx);
        c2 =[c2;br(junk,1)];
        br(junk,:) =[];   
        for j=1:length(c2)-1
            for k =j+1:length(c2)
                node1= c2(j); node2 =c2(k);
                flag =0;
                for p= 1:length(br(:,1))
                    if ((br(p,1)==node1 && br(p,2)==node2) ||(br(p,1)==node2 && br(p,2)==node1))
                        flag=1;
                    end
                end
                if flag ==0 %add branch
                    br =[br;node1 node2];
                end
            end
        end
end

tinney2 =[tinney2;br(:)];

end