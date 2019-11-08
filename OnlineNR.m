function OnlineNR
% <algorithm>
% Online network reconstruction framework
%------------------------------- Reference --------------------------------
% Kai Wu, Jing Liu, Xingxing Hao, Penghui Liu and Fang Shen,
% Online Reconstruction of Complex Networks from Time Series,
% submitted to IEEE Transactions on Cybernetics.
%------------------------------- Copyright --------------------------------
%  OnlineNR.m 
%  Copyright (C) 2019 Kai Wu
% 
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%  Author of this Code: 
%   Kai Wu <kaiwu@stu.xidian.edu.cn> 
%
%  Date of publication: 08.11.2019 
%  Last Update: 08.11.2019 
%--------------------------------------------------------------------------

%% Predefined Parameter starting-------------------
%No. of corresponding state vector sequence
M = 3;
lambdaV = 2.^0;
le = length(lambdaV);
beta = 1;tryCount=1;
r = 0.7;b = 1.2;K = 0.1;
P_PDG = [1 0;b 0];Noise = 0;
%% cycle
for Nsize = 1:2
    if Nsize == 1
        load('karate.txt');
        W = karate;
    elseif Nsize == 2
        load('football.txt');
        W = football;    
    end
    %Number of nodes
    T = size(W,1);
    for re = 1:1
        SV = 6;
        % the part for generate EG data
        y = [];AA = [];
        for i = 1:SV
            [A, Aa] = data_generate(M, P_PDG, W, T, r, b, K, Noise);
            y = [y;Aa];AA = [AA;A];
        end
        for l1 = 7:7
            lambda1 = lambdaV(l1);
            for l2 = 5:5%4
                lambda2 = lambdaV(l2);
                for a1 = 1:le
                    alpha = lambdaV(a1);                  
                    % %-the proposed OnlineNR starting
                    for tryIndex = 1:tryCount
                        Wlearn = zeros(T,T);
                        for index = 1:T
                            A_temp = AA(:,:,index);
                            Wlearn(:,index) = subONR(A_temp,y(:,index),alpha,beta,lambda1,lambda2);
                        end
                        % store useful information
                        savefile=sprintf('ONR-node_%d_SV_%d_a1_%d',T,SV,a1);
                        save(savefile,'W','Wlearn');
                    end
                end
            end
        end
    end
end
end
% %the proposed OnlineNR end