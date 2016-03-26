% how to define shape complexity? %
% method one: max-min
% method two: variance of all points (statis, maybe more robust than method one) 

%%%%%%%%%%%%%%%%%%%%%%%% get SCs for MPEG7 %%%%%%%%%%%%%%%%%%%%%%%%
clear;
load('norHFs(16) for MPEG7 with max-normal.mat');
% scales1 = [1:6];
% scales2 = [7:12];
% scales3 = [13:18];
% scales4 = [19:24];
% scales5 = [25:30];
% scales6 = [31:36];
% scales7 = [37:42];
% scales8 = [43:49];
% scales9 = [49:55];
% scales10 = [56:61];
% scales11 = [62:67];
% scales12 = [68:73];
% scales13 = [74:79];
% scales14 = [80:85];
% scales15 = [86:91];
% scales16 = [92:97];

%load('RSARs for 1400MPEG7 with max-normal.mat');
m=1402;
%-- shape complexity
SHR_SC1 = zeros(1,m-2); % left sar for every point
%SAR_SC2 = zeros(1,m); % right sar for every point
SHR_SC3 = zeros(1,m-2); % left sar for every scale
%SAR_SC4 = zeros(1,m); % right sar for every scale

len = 16;
%coff = [1 2 3 4 5 6 7 8 8 7 6 5 4 3 2 1];
for i = 1 : m-2
    %f1 = [sum(SSHRs{1, i}(scales1, :)); sum(SSHRs{1, i}(scales2, :)); sum(SSHRs{1, i}(scales3, :)); sum(SSHRs{1, i}(scales4, :)); sum(SSHRs{1, i}(scales5, :)); sum(SSHRs{1, i}(scales6, :)); sum(SSHRs{1, i}(scales7, :)); sum(SSHRs{1, i}(scales8, :)); sum(SSHRs{1, i}(scales9, :)); sum(SSHRs{1, i}(scales10, :)); sum(SSHRs{1, i}(scales11, :)); sum(SSHRs{1, i}(scales12, :)); sum(SSHRs{1, i}(scales13, :)); sum(SSHRs{1, i}(scales14, :)); sum(SSHRs{1, i}(scales15, :)); sum(SSHRs{1, i}(scales16, :))];
    f1 = norHFs{1, i};
    addi1 = 0;
    %addi2 = 0;
    for j = 1 : 100
        tmp1 = f1(:, j); % point j
        %tmp2 = RSARs{1, i}(sample, j); % point j
        
        %addi1 = addi1 + max(tmp1) - min(tmp1);
        %addi1 = addi1 + sqrt(var(tmp1));
        addi1 = addi1 + var(tmp1);
        
        %addi2 = addi2 + max(tmp2) - min(tmp2);
    end
    HF_SC1(i) = addi1 / 100;
    %SAR_SC2(i) = addi2 / 100;

    addi1 = 0;
    %addi2 = 0;
    for j = 1 : len
        tmp1 = f1(j, :); % scale j
        %tmp2 = RSARs{1, i}(j, :); % scale j
        
        %addi1 = addi1 + max(tmp1) - min(tmp1); %/ coff(j);
        %addi1 = addi1 + sqrt(var(tmp1)); %/ coff(j);
        addi1 = addi1 + var(tmp1);
        
        %addi2 = addi2 + max(tmp2) - min(tmp2);
    end
    HF_SC3(i) = addi1 / len;
    %SAR_SC4(i) = addi2 / length(sample);
    
    fprintf('Process line %i end \n', i);
end

save('MPEG7 norHF16 ShapeVARForEveryPoint.mat', 'HF_SC1');
%save('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat', 'SAR_SC2');
save('MPEG7 norHF16 ShapeVARForEveryScale.mat', 'HF_SC3');
%save('MPG 2-32-98 right ShapeComplexityForEveryScale.mat', 'SAR_SC4');
%%%%%%%%%%%%%%%%%%%%%%%% get SCs %%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% get SCs for Tari %%%%%%%%%%%%%%%%%%%%%%%%
% clear;
% load('norSSHRs(32) for Tari1000 with max-normal.mat');
% % scales1 = [1:6];
% % scales2 = [7:12];
% % scales3 = [13:18];
% % scales4 = [19:24];
% % scales5 = [25:30];
% % scales6 = [31:36];
% % scales7 = [37:42];
% % scales8 = [43:49];
% % scales9 = [49:55];
% % scales10 = [56:61];
% % scales11 = [62:67];
% % scales12 = [68:73];
% % scales13 = [74:79];
% % scales14 = [80:85];
% % scales15 = [86:91];
% % scales16 = [92:97];
% 
% %load('RSARs for 1400MPEG7 with max-normal.mat');
% m=1002;
% %-- shape complexity
% %SHR_SC1 = zeros(1,m); % left sar for every point
% %SAR_SC2 = zeros(1,m); % right sar for every point
% SHR_SC3 = zeros(1,m); % left sar for every scale
% %SAR_SC4 = zeros(1,m); % right sar for every scale
% 
% len = 32;
% %coff = [1 2 3 4 5 6 7 8 8 7 6 5 4 3 2 1];
% for i = 1 : m-2
%     %f1 = [sum(SSHRs{1, i}(scales1, :)); sum(SSHRs{1, i}(scales2, :)); sum(SSHRs{1, i}(scales3, :)); sum(SSHRs{1, i}(scales4, :)); sum(SSHRs{1, i}(scales5, :)); sum(SSHRs{1, i}(scales6, :)); sum(SSHRs{1, i}(scales7, :)); sum(SSHRs{1, i}(scales8, :)); sum(SSHRs{1, i}(scales9, :)); sum(SSHRs{1, i}(scales10, :)); sum(SSHRs{1, i}(scales11, :)); sum(SSHRs{1, i}(scales12, :)); sum(SSHRs{1, i}(scales13, :)); sum(SSHRs{1, i}(scales14, :)); sum(SSHRs{1, i}(scales15, :)); sum(SSHRs{1, i}(scales16, :))];
%     f1 = norSSHRs{1, i};
% %     addi1 = 0;
% %     %addi2 = 0;
% %     for j = 1 : 100
% %         tmp1 = f1(:, j); % point j
% %         %tmp2 = RSARs{1, i}(sample, j); % point j
% %         
% %         %addi1 = addi1 + max(tmp1) - min(tmp1);
% %         %addi1 = addi1 + sqrt(var(tmp1));
% %         addi1 = addi1 + var(tmp1);
% %         
% %         %addi2 = addi2 + max(tmp2) - min(tmp2);
% %     end
% %     SHR_SC1(i) = addi1 / 100;
% %     %SAR_SC2(i) = addi2 / 100;
% 
%     addi1 = 0;
%     %addi2 = 0;
%     for j = 1 : len
%         tmp1 = f1(j, :); % scale j
%         %tmp2 = RSARs{1, i}(j, :); % scale j
%         
%         %addi1 = addi1 + max(tmp1) - min(tmp1); %/ coff(j);
%         %addi1 = addi1 + sqrt(var(tmp1)); %/ coff(j);
%         addi1 = addi1 + sqrt(var(tmp1));
%         
%         %addi2 = addi2 + max(tmp2) - min(tmp2);
%     end
%     SHR_SC3(i) = addi1 / len;
%     %SAR_SC4(i) = addi2 / length(sample);
%     
%     fprintf('Process line %i end \n', i);
% end
% 
% %save('MPEG7 norSSHR19 ShapeVARForEveryPoint.mat', 'SHR_SC1');
% %save('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat', 'SAR_SC2');
% save('MPEG7 norSSHR32 ShapeSTDForEveryScale.mat', 'SHR_SC3');
% %save('MPG 2-32-98 right ShapeComplexityForEveryScale.mat', 'SAR_SC4');
% a=1;
%%%%%%%%%%%%%%%%%%%%%%%% get SCs %%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%% get SCs for ETH-80 %%%%%%%%%%%%%%%%%%%%%%%%
% clear;
% load('norSSHRs(32) for ETH-80 with max-normal.mat');
% % scales1 = [1:6];
% % scales2 = [7:12];
% % scales3 = [13:18];
% % scales4 = [19:24];
% % scales5 = [25:30];
% % scales6 = [31:36];
% % scales7 = [37:42];
% % scales8 = [43:49];
% % scales9 = [49:55];
% % scales10 = [56:61];
% % scales11 = [62:67];
% % scales12 = [68:73];
% % scales13 = [74:79];
% % scales14 = [80:85];
% % scales15 = [86:91];
% % scales16 = [92:97];
% 
% %load('RSARs for 1400MPEG7 with max-normal.mat');
% m=3282;
% %-- shape complexity
% %SHR_SC1 = zeros(1,m); % left sar for every point
% %SAR_SC2 = zeros(1,m); % right sar for every point
% SHR_SC3 = zeros(1,m); % left sar for every scale
% %SAR_SC4 = zeros(1,m); % right sar for every scale
% 
% len = 32;
% %coff = [1 2 3 4 5 6 7 8 8 7 6 5 4 3 2 1];
% for i = 1 : m-2
%     %f1 = [sum(SSHRs{1, i}(scales1, :)); sum(SSHRs{1, i}(scales2, :)); sum(SSHRs{1, i}(scales3, :)); sum(SSHRs{1, i}(scales4, :)); sum(SSHRs{1, i}(scales5, :)); sum(SSHRs{1, i}(scales6, :)); sum(SSHRs{1, i}(scales7, :)); sum(SSHRs{1, i}(scales8, :)); sum(SSHRs{1, i}(scales9, :)); sum(SSHRs{1, i}(scales10, :)); sum(SSHRs{1, i}(scales11, :)); sum(SSHRs{1, i}(scales12, :)); sum(SSHRs{1, i}(scales13, :)); sum(SSHRs{1, i}(scales14, :)); sum(SSHRs{1, i}(scales15, :)); sum(SSHRs{1, i}(scales16, :))];
%     f1 = norSSHRs{1, i};
% %     addi1 = 0;
% %     %addi2 = 0;
% %     for j = 1 : 100
% %         tmp1 = f1(:, j); % point j
% %         %tmp2 = RSARs{1, i}(sample, j); % point j
% %         
% %         %addi1 = addi1 + max(tmp1) - min(tmp1);
% %         %addi1 = addi1 + sqrt(var(tmp1));
% %         addi1 = addi1 + var(tmp1);
% %         
% %         %addi2 = addi2 + max(tmp2) - min(tmp2);
% %     end
% %     SHR_SC1(i) = addi1 / 100;
% %     %SAR_SC2(i) = addi2 / 100;
% 
%     addi1 = 0;
%     %addi2 = 0;
%     for j = 1 : len
%         tmp1 = f1(j, :); % scale j
%         %tmp2 = RSARs{1, i}(j, :); % scale j
%         
%         %addi1 = addi1 + max(tmp1) - min(tmp1); %/ coff(j);
%         %addi1 = addi1 + sqrt(var(tmp1)); %/ coff(j);
%         addi1 = addi1 + sqrt(var(tmp1));
%         
%         %addi2 = addi2 + max(tmp2) - min(tmp2);
%     end
%     SHR_SC3(i) = addi1 / len;
%     %SAR_SC4(i) = addi2 / length(sample);
%     
%     fprintf('Process line %i end \n', i);
% end
% 
% %save('MPEG7 norSSHR19 ShapeVARForEveryPoint.mat', 'SHR_SC1');
% %save('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat', 'SAR_SC2');
% save('ETH-80 norSSHR32 ShapeSTDForEveryScale.mat', 'SHR_SC3');
% %save('MPG 2-32-98 right ShapeComplexityForEveryScale.mat', 'SAR_SC4');
%%%%%%%%%%%%%%%%%%%%%%%% get SCs for ETH-80 %%%%%%%%%%%%%%%%%%%%%%%%
a=1;
% %%%%%%%%%%%%%%%%%%%%%%% get kimia99 SCs for SSHR %%%%%%%%%%%%%%%%%%%%%%%%
% clear;
% load('norSSHRs(32) for Kimia99 with max-normal.mat');
% % scales1 = [1:6];
% % scales2 = [7:12];
% % scales3 = [13:18];
% % scales4 = [19:24];
% % scales5 = [25:30];
% % scales6 = [31:36];
% % scales7 = [37:42];
% % scales8 = [43:49];
% % scales9 = [49:55];
% % scales10 = [56:61];
% % scales11 = [62:67];
% % scales12 = [68:73];
% % scales13 = [74:79];
% % scales14 = [80:85];
% % scales15 = [86:91];
% % scales16 = [92:97];
% 
% %load('RSARs for 1400MPEG7 with max-normal.mat');
% m=101;
% %-- shape complexity
% %SHR_SC1 = zeros(1,m); % left sar for every point
% %SAR_SC2 = zeros(1,m); % right sar for every point
% SHR_SC3 = zeros(1,m); % left sar for every scale
% %SAR_SC4 = zeros(1,m); % right sar for every scale
% 
% len = 32;
% %coff = [1 2 3 4 5 6 7 8 8 7 6 5 4 3 2 1];
% for i = 1 : m-2
%     %f1 = [sum(SSHRs{1, i}(scales1, :)); sum(SSHRs{1, i}(scales2, :)); sum(SSHRs{1, i}(scales3, :)); sum(SSHRs{1, i}(scales4, :)); sum(SSHRs{1, i}(scales5, :)); sum(SSHRs{1, i}(scales6, :)); sum(SSHRs{1, i}(scales7, :)); sum(SSHRs{1, i}(scales8, :)); sum(SSHRs{1, i}(scales9, :)); sum(SSHRs{1, i}(scales10, :)); sum(SSHRs{1, i}(scales11, :)); sum(SSHRs{1, i}(scales12, :)); sum(SSHRs{1, i}(scales13, :)); sum(SSHRs{1, i}(scales14, :)); sum(SSHRs{1, i}(scales15, :)); sum(SSHRs{1, i}(scales16, :))];
%     f1 = norSSHRs{1, i};
% %     addi1 = 0;
% %     %addi2 = 0;
% %     for j = 1 : 100
% %         tmp1 = f1(:, j); % point j
% %         %tmp2 = RSARs{1, i}(sample, j); % point j
% %         
% %         %addi1 = addi1 + max(tmp1) - min(tmp1);
% %         %addi1 = addi1 + sqrt(var(tmp1));
% %         addi1 = addi1 + var(tmp1);
% %         
% %         %addi2 = addi2 + max(tmp2) - min(tmp2);
% %     end
% %     SHR_SC1(i) = addi1 / 100;
% %     %SAR_SC2(i) = addi2 / 100;
% 
%     addi1 = 0;
%     %addi2 = 0;
%     for j = 1 : len
%         tmp1 = f1(j, :); % scale j
%         %tmp2 = RSARs{1, i}(j, :); % scale j
%         
%         %addi1 = addi1 + max(tmp1) - min(tmp1); %/ coff(j);
%         %addi1 = addi1 + sqrt(var(tmp1)); %/ coff(j);
%         addi1 = addi1 + var(tmp1);
%         
%         %addi2 = addi2 + max(tmp2) - min(tmp2);
%     end
%     SHR_SC3(i) = addi1 / len;
%     %SAR_SC4(i) = addi2 / length(sample);
%     
%     fprintf('Process line %i end \n', i);
% end
% 
% %save('MPEG7 norSSHR19 ShapeVARForEveryPoint.mat', 'SHR_SC1');
% %save('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat', 'SAR_SC2');
% save('Kimia99 norSSHR32 ShapeVARForEveryScale.mat', 'SHR_SC3');
% %save('MPG 2-32-98 right ShapeComplexityForEveryScale.mat', 'SAR_SC4');
% 
% for i = 1 : m-2
%     %f1 = [sum(SSHRs{1, i}(scales1, :)); sum(SSHRs{1, i}(scales2, :)); sum(SSHRs{1, i}(scales3, :)); sum(SSHRs{1, i}(scales4, :)); sum(SSHRs{1, i}(scales5, :)); sum(SSHRs{1, i}(scales6, :)); sum(SSHRs{1, i}(scales7, :)); sum(SSHRs{1, i}(scales8, :)); sum(SSHRs{1, i}(scales9, :)); sum(SSHRs{1, i}(scales10, :)); sum(SSHRs{1, i}(scales11, :)); sum(SSHRs{1, i}(scales12, :)); sum(SSHRs{1, i}(scales13, :)); sum(SSHRs{1, i}(scales14, :)); sum(SSHRs{1, i}(scales15, :)); sum(SSHRs{1, i}(scales16, :))];
%     f1 = norSSHRs{1, i};
% %     addi1 = 0;
% %     %addi2 = 0;
% %     for j = 1 : 100
% %         tmp1 = f1(:, j); % point j
% %         %tmp2 = RSARs{1, i}(sample, j); % point j
% %         
% %         %addi1 = addi1 + max(tmp1) - min(tmp1);
% %         %addi1 = addi1 + sqrt(var(tmp1));
% %         addi1 = addi1 + var(tmp1);
% %         
% %         %addi2 = addi2 + max(tmp2) - min(tmp2);
% %     end
% %     SHR_SC1(i) = addi1 / 100;
% %     %SAR_SC2(i) = addi2 / 100;
% 
%     addi1 = 0;
%     %addi2 = 0;
%     for j = 1 : len
%         tmp1 = f1(j, :); % scale j
%         %tmp2 = RSARs{1, i}(j, :); % scale j
%         
%         %addi1 = addi1 + max(tmp1) - min(tmp1); %/ coff(j);
%         %addi1 = addi1 + sqrt(var(tmp1)); %/ coff(j);
%         addi1 = addi1 + sqrt(var(tmp1));
%         
%         %addi2 = addi2 + max(tmp2) - min(tmp2);
%     end
%     SHR_SC3(i) = addi1 / len;
%     %SAR_SC4(i) = addi2 / length(sample);
%     
%     fprintf('Process line %i end \n', i);
% end
% 
% %save('MPEG7 norSSHR19 ShapeVARForEveryPoint.mat', 'SHR_SC1');
% %save('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat', 'SAR_SC2');
% save('Kimia99 norSSHR32 ShapeSTDForEveryScale.mat', 'SHR_SC3');
% %%%%%%%%%%%%%%%%%%%%%%%% get SCs %%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%% get kimia25 SCs for SSHR %%%%%%%%%%%%%%%%%%%%%%%%
% clear;
% load('norSSHRs(19) for Kimia25 with max-normal.mat');
% % scales1 = [1:6];
% % scales2 = [7:12];
% % scales3 = [13:18];
% % scales4 = [19:24];
% % scales5 = [25:30];
% % scales6 = [31:36];
% % scales7 = [37:42];
% % scales8 = [43:49];
% % scales9 = [49:55];
% % scales10 = [56:61];
% % scales11 = [62:67];
% % scales12 = [68:73];
% % scales13 = [74:79];
% % scales14 = [80:85];
% % scales15 = [86:91];
% % scales16 = [92:97];
% 
% %load('RSARs for 1400MPEG7 with max-normal.mat');
% m=27;
% %-- shape complexity
% %SHR_SC1 = zeros(1,m); % left sar for every point
% %SAR_SC2 = zeros(1,m); % right sar for every point
% SHR_SC3 = zeros(1,m-2); % left sar for every scale
% %SAR_SC4 = zeros(1,m); % right sar for every scale
% 
% len = 19;
% %coff = [1 2 3 4 5 6 7 8 8 7 6 5 4 3 2 1];
% for i = 1 : m-2
%     %f1 = [sum(SSHRs{1, i}(scales1, :)); sum(SSHRs{1, i}(scales2, :)); sum(SSHRs{1, i}(scales3, :)); sum(SSHRs{1, i}(scales4, :)); sum(SSHRs{1, i}(scales5, :)); sum(SSHRs{1, i}(scales6, :)); sum(SSHRs{1, i}(scales7, :)); sum(SSHRs{1, i}(scales8, :)); sum(SSHRs{1, i}(scales9, :)); sum(SSHRs{1, i}(scales10, :)); sum(SSHRs{1, i}(scales11, :)); sum(SSHRs{1, i}(scales12, :)); sum(SSHRs{1, i}(scales13, :)); sum(SSHRs{1, i}(scales14, :)); sum(SSHRs{1, i}(scales15, :)); sum(SSHRs{1, i}(scales16, :))];
%     f1 = norSSHRs{1, i};
% %     addi1 = 0;
% %     %addi2 = 0;
% %     for j = 1 : 100
% %         tmp1 = f1(:, j); % point j
% %         %tmp2 = RSARs{1, i}(sample, j); % point j
% %         
% %         %addi1 = addi1 + max(tmp1) - min(tmp1);
% %         %addi1 = addi1 + sqrt(var(tmp1));
% %         addi1 = addi1 + var(tmp1);
% %         
% %         %addi2 = addi2 + max(tmp2) - min(tmp2);
% %     end
% %     SHR_SC1(i) = addi1 / 100;
% %     %SAR_SC2(i) = addi2 / 100;
% 
%     addi1 = 0;
%     %addi2 = 0;
%     for j = 1 : len
%         tmp1 = f1(j, :); % scale j
%         %tmp2 = RSARs{1, i}(j, :); % scale j
%         
%         %addi1 = addi1 + max(tmp1) - min(tmp1); %/ coff(j);
%         %addi1 = addi1 + sqrt(var(tmp1)); %/ coff(j);
%         addi1 = addi1 + sqrt(var(tmp1));
%         
%         %addi2 = addi2 + max(tmp2) - min(tmp2);
%     end
%     SHR_SC3(i) = addi1 / len;
%     %SAR_SC4(i) = addi2 / length(sample);
%     
%     fprintf('Process line %i end \n', i);
% end
% 
% %save('MPEG7 norSSHR19 ShapeVARForEveryPoint.mat', 'SHR_SC1');
% %save('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat', 'SAR_SC2');
% save('Kimia25 norSSHR19 ShapeSTDForEveryScale.mat', 'SHR_SC3');
% %save('MPG 2-32-98 right ShapeComplexityForEveryScale.mat', 'SAR_SC4');
% 
% for i = 1 : m-2
%     %f1 = [sum(SSHRs{1, i}(scales1, :)); sum(SSHRs{1, i}(scales2, :)); sum(SSHRs{1, i}(scales3, :)); sum(SSHRs{1, i}(scales4, :)); sum(SSHRs{1, i}(scales5, :)); sum(SSHRs{1, i}(scales6, :)); sum(SSHRs{1, i}(scales7, :)); sum(SSHRs{1, i}(scales8, :)); sum(SSHRs{1, i}(scales9, :)); sum(SSHRs{1, i}(scales10, :)); sum(SSHRs{1, i}(scales11, :)); sum(SSHRs{1, i}(scales12, :)); sum(SSHRs{1, i}(scales13, :)); sum(SSHRs{1, i}(scales14, :)); sum(SSHRs{1, i}(scales15, :)); sum(SSHRs{1, i}(scales16, :))];
%     f1 = norSSHRs{1, i};
% %     addi1 = 0;
% %     %addi2 = 0;
% %     for j = 1 : 100
% %         tmp1 = f1(:, j); % point j
% %         %tmp2 = RSARs{1, i}(sample, j); % point j
% %         
% %         %addi1 = addi1 + max(tmp1) - min(tmp1);
% %         %addi1 = addi1 + sqrt(var(tmp1));
% %         addi1 = addi1 + var(tmp1);
% %         
% %         %addi2 = addi2 + max(tmp2) - min(tmp2);
% %     end
% %     SHR_SC1(i) = addi1 / 100;
% %     %SAR_SC2(i) = addi2 / 100;
% 
%     addi1 = 0;
%     %addi2 = 0;
%     for j = 1 : len
%         tmp1 = f1(j, :); % scale j
%         %tmp2 = RSARs{1, i}(j, :); % scale j
%         
%         %addi1 = addi1 + max(tmp1) - min(tmp1); %/ coff(j);
%         %addi1 = addi1 + sqrt(var(tmp1)); %/ coff(j);
%         addi1 = addi1 + sqrt(var(tmp1));
%         
%         %addi2 = addi2 + max(tmp2) - min(tmp2);
%     end
%     SHR_SC3(i) = addi1 / len;
%     %SAR_SC4(i) = addi2 / length(sample);
%     
%     fprintf('Process line %i end \n', i);
% end
% 
% %save('MPEG7 norSSHR19 ShapeVARForEveryPoint.mat', 'SHR_SC1');
% %save('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat', 'SAR_SC2');
% save('Kimia99 norSSHR32 ShapeSTDForEveryScale.mat', 'SHR_SC3');
%%%%%%%%%%%%%%%%%%%%%%%%% get sc for kimia25 %%%%%%%%%%%%%%%%%%%%%%%%%%


% %%%%%%%%%%%%%%%%%%% get new distance from SCs for MPEG7 %%%%%%%%%%%%%%%%%
% add shape complexity to score
clear;
m=1402;
% 
load('weighted0-tar distance (16) th=0.0 norHFs 1400Score.mat');
%S=Score+Score';
% Score = S;
% % 1 means get sc for every point, and sum/average them for the whole shape; 2 means get sc for every scale, and sum them for the whole shape 
% % 2 is more suitable, as sc should be global at the start point 
load('MPEG7 norHF16 ShapeVARForEveryPoint.mat');
% %load('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat');
load('MPEG7 norHF16 ShapeVARForEveryScale.mat');
%load('MPG weighted0 norSSHR16 ShapeComplexityForEveryScale.mat');
% %load('MPG 2-32-98 right ShapeComplexityForEveryScale.mat');
% 
fac = [0.01:0.01:1.2];
for c2 = 1:length(fac)
% 
sc = SHR_SC3(1:m-2);
comat = fac(c2)*ones(m-2) + repmat(sc, m-2, 1) + repmat(sc', 1, m-2);
Score2 = Score ./ comat;
% 
% %---- compute matching accuracy
[sorted, index] = sort(Score2);  % by column, sort(Score, 1)
% %-- judge the first 40 rows of 'index', whether the place is in proper range, and count number
n_class = (m-2)/20;  % how many classes of objects in DB
n_obj = 20;   % how many objects in every class
hit_num = zeros(1, n_class);  % how many objects found in matching for every class
for i = 1 : n_class
    index_min = 1 + n_obj * (i - 1);  % the two indices denote both the column range for every class
    index_max = n_obj * i;            % and the proper index range
%     
    hit_num(i) = length(find(index(1 : 40, index_min : index_max) >= index_min & index(1 : 40, index_min : index_max) <= index_max));
end
% 
% %-- statis, VC+DP 66%
Accu_class = hit_num / (n_obj * n_obj);
% %Accu = sum(hit_num) / (n_obj * n_obj * n_class);
Accu(c2) = sum(hit_num) / (n_obj * n_obj * n_class);
% %num=num+1;
% %    end
end

a=1;

% %%%%%%%%%%%%%%%%% get new distance from SCs for Tari1000 %%%%%%%%%%%%%%%%
% % add shape complexity to score
% clear;
% m=1002;
% % 
% load('full weighted0-tar distance (32) th=0.0 norSSHRs 1000Score.mat');
% %S=Score+Score';
% % Score = S;
% % % 1 means get sc for every point, and sum/average them for the whole shape; 2 means get sc for every scale, and sum them for the whole shape 
% % % 2 is more suitable, as sc should be global at the start point 
% %load('MPEG7 norSSHR19 ShapeSTDForEveryPoint.mat');
% % %load('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat');
% load('Tari1000 norSSHR32 ShapeSTDForEveryScale.mat');
% %load('MPG weighted0 norSSHR16 ShapeComplexityForEveryScale.mat');
% % %load('MPG 2-32-98 right ShapeComplexityForEveryScale.mat');
% % 
% fac = [0:0.01:2];
% for c2 = 1:length(fac)
% % 
% sc = SHR_SC3(1:m-2);
% comat = fac(c2)*ones(m-2) + repmat(sc, m-2, 1) + repmat(sc', 1, m-2);
% Score2 = Score ./ comat;
% % 
% % %---- compute matching accuracy
% [sorted, index] = sort(Score2);  % by column, sort(Score, 1)
% % %-- judge the first 40 rows of 'index', whether the place is in proper range, and count number
% n_class = (m-2)/20;  % how many classes of objects in DB
% n_obj = 20;   % how many objects in every class
% hit_num = zeros(1, n_class);  % how many objects found in matching for every class
% for i = 1 : n_class
%     index_min = 1 + n_obj * (i - 1);  % the two indices denote both the column range for every class
%     index_max = n_obj * i;            % and the proper index range
% %     
%     hit_num(i) = length(find(index(1 : 40, index_min : index_max) >= index_min & index(1 : 40, index_min : index_max) <= index_max));
% end
% % 
% % %-- statis, VC+DP 66%
% Accu_class = hit_num / (n_obj * n_obj);
% % %Accu = sum(hit_num) / (n_obj * n_obj * n_class);
% Accu(c2) = sum(hit_num) / (n_obj * n_obj * n_class);
% % %num=num+1;
% % %    end
% end
% 
% a=1;

% %%%%%%%%%%%%%%%%%% get new NN from SCs for ETH-80 %%%%%%%%%%%%%%%%%
% % add shape complexity to score
% clear;
% m=3282;
% % 
% load('(32) th=0.0 norSSHRs 3280Score.mat');
% %S=Score+Score';
% % Score = S;
% % % 1 means get sc for every point, and sum/average them for the whole shape; 2 means get sc for every scale, and sum them for the whole shape 
% % % 2 is more suitable, as sc should be global at the start point 
% %load('MPEG7 norSSHR19 ShapeSTDForEveryPoint.mat');
% % %load('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat');
% load('ETH-80 norSSHR32 ShapeSTDForEveryScale.mat');
% %load('MPG weighted0 norSSHR16 ShapeComplexityForEveryScale.mat');
% % %load('MPG 2-32-98 right ShapeComplexityForEveryScale.mat');
% % 
% n_obj1 = 41;          % how many objects in every class
% n_class1 = (m-2)/n_obj1;  % how many classes of objects in DB
% n_obj2 = 41*10;          % how many objects in every class
% n_class2 = (m-2)/n_obj2;  % how many classes of objects in DB
% 
% fac = [0.121:0.001:0.17];
% for c2 = 1:length(fac)
% % 
% sc = SHR_SC3(1:m-2);
% comat = fac(c2)*ones(m-2) + repmat(sc, m-2, 1) + repmat(sc', 1, m-2);
% Score2 = Score ./ comat;
% 
% for i = 1 : n_class1
%     index_min = 1 + n_obj1 * (i - 1);  % the two indices denote both the column range for every class
%     index_max = n_obj1 * i;            % and the proper index range
%     
%     Score2(index_min:index_max, index_min:index_max) = 100000;
% end
% % 
% % %---- compute matching accuracy
% [sorted, index] = sort(Score2);  % by column, sort(Score, 1)
% %-- judge the NN of 'index', whether the place is in proper range, and count number
% hit_num = zeros(1, n_class2);  % how many objects found in matching for every class
% for i = 1 : n_class2
%     index_min = 1 + n_obj2 * (i - 1);  % the two indices denote both the column range for every class
%     index_max = n_obj2 * i;            % and the proper index range
%     
%     hit_num(i) = length(find(index(1, index_min : index_max) >= index_min & index(1, index_min : index_max) <= index_max));
% end
% % 
% % %-- statis, VC+DP 66%
% Accu_class = hit_num / n_obj2;
% % %Accu = sum(hit_num) / (n_obj * n_obj * n_class);
% Accu(c2) = mean(Accu_class);
% % %num=num+1;
% % %    end
% end
% 
% a=1;

% % %%%%%%%%%%%%%%%%%%%%%%% kimia25 statis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear;
% m=27;
% 
% load('w0 (19) th=0 norSSHRs 25Score.mat');
% 
% % 1 means get sc for every point, and sum/average them for the whole shape; 2 means get sc for every scale, and sum them for the whole shape 
% % 2 is more suitable, as sc should be global at the start point 
% %load('Kimia25 norSSHR32 ShapeComplexityForEveryPoint.mat');
% %load('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat');
% load('Kimia25 norSSHR19 ShapeSTDForEveryScale.mat');
% %load('MPG 2-32-98 right ShapeComplexityForEveryScale.mat');
% 
% fac = 0.01;%[0:0.1:5];
% %Accu = zeros(length(fac), 10);
% for c2 = 1:length(fac)
% 
% sc = SHR_SC3(1:m-2);
% comat = fac(c2)*ones(m-2) + repmat(sc, m-2, 1) + repmat(sc', 1, m-2);
% Score2 = Score ./ comat;
% 
% %---- compute matching accuracy
% [sorted, index] = sort(Score2');  % by column, sort(Score, 1)
% end
% %%%%%%%%%%%%%%%%%%%%%%% kimia99 statis %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clear;
% m=101;
% 
% load('w0 (19) th=0.1 norSSHRs 99Score.mat');
% 
% % 1 means get sc for every point, and sum/average them for the whole shape; 2 means get sc for every scale, and sum them for the whole shape 
% % 2 is more suitable, as sc should be global at the start point 
% load('Kimia99 norSSHR19 ShapeSTDForEveryScale.mat');
% %load('MPG 2-32-98 right ShapeComplexityForEveryPoint.mat');
% %load('Kimia99 norSSHR12 ShapeComplexityForEveryScale.mat');
% %load('MPG 2-32-98 right ShapeComplexityForEveryScale.mat');
% 
% fac = [0:0.01:2];
% Accu = zeros(length(fac), 10);
% for c2 = 1:length(fac)
% 
% sc = SHR_SC3(1:m-2);
% comat = fac(c2)*ones(m-2) + repmat(sc, m-2, 1) + repmat(sc', 1, m-2);
% Score2 = Score ./ comat;
% 
% %---- compute matching accuracy
% [sorted, index] = sort(Score2');  % by column, sort(Score, 1)
% %-- judge the first 40 rows of 'index', whether the place is in proper range, and count number
% n_class = 9;  % how many classes of objects in DB
% n_obj = 11;   % how many objects in every class
% n_sta = 10;
% hit_num = zeros(n_sta, n_class);  % how many objects found in matching for every class
% for i = 1 : n_class
%     index_min = 1 + n_obj * (i - 1);  % the two indices denote both the column range for every class
%     index_max = n_obj * i;            % and the proper index range
%     
%     for j = 2 : n_sta+1
%         hit_num(j-1, i) = length(find(index(j, index_min : index_max) >= index_min & index(j, index_min : index_max) <= index_max));
%     end
% end
% Accu(c2, :) = sum(hit_num');
% %num=num+1;
% %    end
% end
%%%%%%%%%%%%%%%%%%%%%%%% get new distance from SCs %%%%%%%%%%%%%%%%%%%%%%%%


% 
% clear;
% m=1402;
% 
% load('MPG norSSHR24 ShapeComplexityForEveryPoint.mat');
% load('MPG norSSHR24 ShapeComplexityForEveryScale.mat');
% % load('max 5-13-9 leftdis ShapeComplexityForEveryPoint.mat');
% % load('max 5-13-9 leftdis ShapeComplexityForEveryScale.mat');
% % load('max 5-13-9 rightdis ShapeComplexityForEveryPoint.mat');
% % load('max 5-13-9 rightdis ShapeComplexityForEveryScale.mat');
% load('weighted-tar distance (24) th=0.0 norSSHRs 1400Score.mat');
% t=Score+Score';
% %FullScore = Score + Score';
% %%lam=[0.4:0.01:0.6];
% %%fac = [1:0.1:3];
% num=1;
% for c1 = 39
%     lam = c1/100; % 0.26:0.01:0.6
%     for c2 = 18
%         fac = c2/10; % 0.1:0.1:2
% sc = lam*shape_complexity2(1:m-2) + (1-lam)*(shape_complexity4(1:m-2) + shape_complexity6(1:m-2));
% comat = fac*ones(m-2) + repmat(sc, m-2, 1) + repmat(sc', 1, m-2);
% Score2 = t ./ comat;
% 
% %---- compute matching accuracy
% [sorted, index] = sort(Score2);  % by column, sort(Score, 1)
% %-- judge the first 40 rows of 'index', whether the place is in proper range, and count number
% n_class = (m-2)/20;  % how many classes of objects in DB
% n_obj = 20;   % how many objects in every class
% hit_num = zeros(1, n_class);  % how many objects found in matching for every class
% for i = 1 : n_class
%     index_min = 1 + n_obj * (i - 1);  % the two indices denote both the column range for every class
%     index_max = n_obj * i;            % and the proper index range
%     
%     hit_num(i) = length(find(index(1 : 40, index_min : index_max) >= index_min & index(1 : 40, index_min : index_max) <= index_max));
% end
% 
% %-- statis, VC+DP 66%
% Accu_class = hit_num / (n_obj * n_obj);
% Accu(c1, c2) = sum(hit_num) / (n_obj * n_obj * n_class);
% %num=num+1;
%     end
% end




% bar(Accu_class);
% title(strcat('Accu = ', num2str(Accu)));
% 
% %-- for Kimia 1 with 25 images, just count for every object...
% %-- for Kimia 2 with 99 images, use the following code to statistic the retrieval rates
% n_class = 9;  % how many classes of objects in DB
% n_obj = 11;   % how many objects in every class
% n_sta = 10;
% hit_num = zeros(n_sta, n_class);  % how many objects found in matching for every class
% for i = 1 : n_class
%     index_min = 1 + n_obj * (i - 1);  % the two indices denote both the column range for every class
%     index_max = n_obj * i;            % and the proper index range
%     
%     for j = 2 : n_sta+1
%         hit_num(j-1, i) = length(find(index(j, index_min : index_max) >= index_min & index(j, index_min : index_max) <= index_max));
%     end
% end
% Accu = sum(hit_num');
% a=1;




% %---- compute matching accuracy
% [sorted, index] = sort(Score2);  % by column, sort(Score, 1)
% %-- judge the first 40 rows of 'index', whether the place is in proper range, and count number
% n_class = (m-2)/20;  % how many classes of objects in DB
% n_obj = 20;   % how many objects in every class
% hit_num = zeros(1, n_class);  % how many objects found in matching for every class
% for i = 1 : n_class
%     index_min = 1 + n_obj * (i - 1);  % the two indices denote both the column range for every class
%     index_max = n_obj * i;            % and the proper index range
%     
%     hit_num(i) = length(find(index(1 : 40, index_min : index_max) >= index_min & index(1 : 40, index_min : index_max) <= index_max));
% end
% 
% %-- statis, VC+DP 66%
% Accu_class = hit_num / (n_obj * n_obj);
% Accu = sum(hit_num) / (n_obj * n_obj * n_class);
% 
% figure(1);
% bar(Accu_class);
% title(strcat('Accu = ', num2str(Accu)));
% 
% tete = 1;
