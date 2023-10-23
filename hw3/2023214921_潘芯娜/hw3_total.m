
clc;clear
%% __________hw3_1__________
A =[2 -1 0 -1;-1 2 -1 0;0 -1 2 -1;-1 0 -1 4];
A1 = A;
D=diag(A);
n = length(A(:,1));
I = diag(ones(n,1));
% 得到按行存储的U
[U,JU,IU,NEXT_U]=rowsave2(A1);
[L,IL,JL,NEXT_L]=rowsave2(A1');
% LU分解
for i1=1:n-1
    k1=IU(i1);
    while(k1~=0)
        j1 = JU(k1);
        if(i1~=j1)
            U(k1) = U(k1)/D(i1);
            k2 =JL(i1);
            while(k2~=0)% search for the location of element(i2,j1) updated by U(i1,j1) and L(i2,i1)
                i2= IL(k2);
                if(i2~=i1)
                    if i2==j1%========update D========
                        D(i2) = D(i2) -U(k1)*L(k2);
                    elseif i2<j1%=====updata U========
                        % find the columns at row i2
                        flag =0;
                        q = IU(i2);
                        while q~=0
                            % find if there is column = j1;
                            if JU(q) == j1
                                U(q) = U(q)-U(k1)*L(k2);
                                flag = 1;
                            elseif JU(q) < j1
                                q_update = q;
                            end
                            q = NEXT_U(q);
                        end
                        if flag == 0 % didnot find q in the U
                            U =[U , -U(k1)*L(k2)];
                            JU =[JU, j1];
                            NEXT_U = [NEXT_U, NEXT_U(q_update)];
                            NEXT_U(q_update) = length(NEXT_U);
                        end
                    else %===========update L==========
                        % find the rows at column j1
                        flag =0;
                        q = JL(j1);
                        while q~=0
                            % find if there is row = i2;
                            if IL(q) == i2
                                L(q) = L(q)-U(k1)*L(k2);
                                flag = 1;
                            elseif IL(q) < i2
                                q_update = q;
                            end
                            q = NEXT_L(q);
                        end
                        if flag == 0 % didnot find q in the L
                            L =[L , -U(k1)*L(k2)];
                            IL =[IL, i2];
                            NEXT_L = [NEXT_L, NEXT_L(q_update)];
                            NEXT_L(q_update) = length(NEXT_L);
                        end
                    end
                end
                k2 = NEXT_L(k2);
            end
        end
        k1=NEXT_U(k1);
    end
end
% 展开为常规格式，方便查阅
U1 = rowsave_load2(U,JU,IU,NEXT_U);
for i=1:n
    U1(i,i) = 1;
end
[U,JU,IU,NEXT_U] = rowsave2(U1);
[L,IL,JL,NEXT_L] = rowsave2(U1);
% print out the results
fprintf('=======homework 3.1==========')
L1 =U1',D1=diag(D),U1
% fprintf('the Y, whose upper part is U , diagonal part is D and lower part is L');
% Y = U1+diag(D)+U1' -2*I


%% ____________hw3_2____________
% 严格上下三角
U3 =U1 -I;
[L2,IL2,JL2,NEXT_L2] = rowsave2(U3);
b=[0 1 0 0]';
z=b;
% 稀疏前代
for j=1:n-1
    if(z(j)~=0)
        k = JL2(j);
        while(k~=0)
            i =IL2(k);
            z(i)=z(i)-L2(k)*z(j);
            k =NEXT_L2(k);
        end
    end
end
% 稀疏规格化
y=z;
for i=1:n
    if(z(i)~=0)
        y(i) =z(i)/D(i);
    end
end
% 稀疏回代
x=y;
% 回代需要先按列后按行、从大到小检索元素，而U为行存储、从小到大。
% 以次对角线为轴，翻转U得到U4，检索关系对应为：U4先按行→U先按列；U4从小到大→U从大到小
U4 = flipud(U3);% 上下翻转
U4 = rot90(U4);% 逆时针旋转90°
[U2,JU2,IU2,NEXT_U2] = rowsave2(U4);
for i=1:n-1
    k=IU2(i);
    while k~=0
        j=JU2(k);
        x(n+1-j)=x(n+1-j)-U2(k)*x(n+1-i);
        k=NEXT_U2(k);
    end
end
fprintf('========homework 3.2==========')
x
%% ________hw3_5___________
mpc =case14;
br_ieee14 =mpc.branch(:,[1 2]);
[t1_ieee14 t2_ieee14] = tinney(br_ieee14);

mpb =case30;
br_ieee30 =mpb.branch(:,[1 2]);
[t1_ieee30 t2_ieee30] = tinney(br_ieee30);
% print the results
fprintf('========homework 3.5==========');
t1_ieee14 = t1_ieee14'
t2_ieee14 = t2_ieee14'
t1_ieee30 = t1_ieee30'
t2_ieee30 = t2_ieee30'

%% ________hw3_7___________
% 连续回代法,非稀疏格式
Z = getinv_LDU(A);
fprintf('========homework 3.7==========');
error = A^(-1) - Z

