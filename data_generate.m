function [A, Aa] = data_generate(M, P_PDG, W, N, r, b, K, Noise)
% play game with other players
player = zeros(M+1,N);
% estalish strategy for the players
for i = 1:N
    if rand <= 0.5
        player(1,i) = 1;
    else
        player(1,i) = 0;
    end
end
%% caculate payoff for each node
% F = zeros(1,N);
% initialize n players'profile through M rounds
G = zeros(M,N);
for t = 1:M
for i = 1:N
    if player(t,i) == 1
        s1 = [1 0]'; 
    else
        s1 = [0 1]';
    end
    for j = 1:N
        if player(t,j) == 0
            s2 = [0 1]'; 
        else
            s2 = [1 0]';
        end
        F(1,j) = s1'*P_PDG*s2;
    end
    A(t,:,i) = F;
    G(t,i) = F*W(:,i);
end
%% update strategies
for k = 1:N
    [s,~] = find(W(:,k) >= 1);
    if ~isempty(s)
    L = randperm(length(s));
    P = 1.0/(1+exp((G(t,k)-G(t,s(L(1))))/K));
    if rand <= P
        player(t+1,k) = player(t,s(L(1)));
    else
        player(t+1,k) = player(t,k);
    end
    else
        player(t+1,k) = player(t,k);
    end
end
end
% add noise for G
Aa = G + Noise*randn(M,N);
