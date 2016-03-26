%---------- smoothing and local normalization ----------%

clear;

m=1402;

% % k=3, M=32 %
% scales1 = [1:3];
% scales2 = [4:6];
% scales3 = [7:9];
% scales4 = [10:12];
% scales5 = [13:15];
% scales6 = [16:18];
% scales7 = [19:21];
% scales8 = [22:24];
% scales9 = [25:27];
% scales10 = [28:30];
% scales11 = [31:33];
% scales12 = [34:36];
% scales13 = [37:39];
% scales14 = [40:42];
% scales15 = [43:45];
% scales16 = [46:49];
% scales17 = [49:52];
% scales18 = [53:55];
% scales19 = [56:58];
% scales20 = [59:61];
% scales21 = [62:64];
% scales22 = [65:67];
% scales23 = [68:70];
% scales24 = [71:73];
% scales25 = [74:76];
% scales26 = [77:79];
% scales27 = [80:82];
% scales28 = [83:85];
% scales29 = [86:88];
% scales30 = [89:91];
% scales31 = [92:94];
% scales32 = [95:97];

% % k=4, M=24 %
% scales1 = [1:4];
% scales2 = [5:8];
% scales3 = [9:12];
% scales4 = [13:16];
% scales5 = [17:20];
% scales6 = [21:24];
% scales7 = [25:28];
% scales8 = [29:32];
% scales9 = [33:36];
% scales10 = [37:40];
% scales11 = [41:44];
% scales12 = [45:49];
% scales13 = [49:53];
% scales14 = [54:57];
% scales15 = [58:61];
% scales16 = [62:65];
% scales17 = [66:69];
% scales18 = [70:73];
% scales19 = [74:77];
% scales20 = [78:81];
% scales21 = [82:85];
% scales22 = [86:89];
% scales23 = [90:93];
% scales24 = [94:97];

% % k=5, M=19 %
% scales1 = [1:5];
% scales2 = [6:10];
% scales3 = [11:15];
% scales4 = [16:20];
% scales5 = [21:25];
% scales6 = [26:30];
% scales7 = [31:35];
% scales8 = [36:40];
% scales9 = [41:45];
% scales10 = [46:52];
% scales11 = [53:57];
% scales12 = [58:62];
% scales13 = [63:67];
% scales14 = [68:72];
% scales15 = [73:77];
% scales16 = [78:82];
% scales17 = [83:87];
% scales18 = [88:92];
% scales19 = [93:97];

% k=6, M=16 %
scales1 = [1:6];
scales2 = [7:12];
scales3 = [13:18];
scales4 = [19:24];
scales5 = [25:30];
scales6 = [31:36];
scales7 = [37:42];
scales8 = [43:49];
scales9 = [49:55];
scales10 = [56:61];
scales11 = [62:67];
scales12 = [68:73];
scales13 = [74:79];
scales14 = [80:85];
scales15 = [86:91];
scales16 = [92:97];

% % k=7, M=14 %
% scales1 = [1:7];
% scales2 = [8:14];
% scales3 = [15:21];
% scales4 = [22:28];
% scales5 = [29:35];
% scales6 = [36:42];
% scales7 = [43:49];
% scales8 = [49:55];
% scales9 = [56:62];
% scales10 = [63:69];
% scales11 = [70:76];
% scales12 = [77:83];
% scales13 = [84:90];
% scales14 = [91:97];

% % k=9, M=11 %
% scales1 = [1:9];
% scales2 = [10:18];
% scales3 = [19:27];
% scales4 = [28:36];
% scales5 = [37:45];
% scales6 = [46:52];
% scales7 = [53:61];
% scales8 = [62:70];
% scales9 = [71:79];
% scales10 = [80:88];
% scales11 = [89:97];

% % k=10, M=10 %
% scales1 = [1:10];
% scales2 = [11:20];
% scales3 = [21:30];
% scales4 = [31:40];
% scales5 = [41:49];
% scales6 = [49:57];
% scales7 = [58:67];
% scales8 = [68:77];
% scales9 = [78:87];
% scales10 = [88:97];

% % k=11, M=9 %
% scales1 = [1:11];
% scales2 = [12:22];
% scales3 = [23:33];
% scales4 = [34:44];
% scales5 = [45:53];
% scales6 = [54:64];
% scales7 = [65:75];
% scales8 = [76:86];
% scales9 = [87:97];

load('HFs for MPEG7 with max-normal.mat');
norHFs = cell(1, m-2);
for i = 1 : m-2
    %tmp = [sum(SSHRs{1, i}(scales1, :)); sum(SSHRs{1, i}(scales2, :)); sum(SSHRs{1, i}(scales3, :)); sum(SSHRs{1, i}(scales4, :)); sum(SSHRs{1, i}(scales5, :)); sum(SSHRs{1, i}(scales6, :)); sum(SSHRs{1, i}(scales7, :)); sum(SSHRs{1, i}(scales8, :)); sum(SSHRs{1, i}(scales9, :)); sum(SSHRs{1, i}(scales10, :)); sum(SSHRs{1, i}(scales11, :)); sum(SSHRs{1, i}(scales12, :)); sum(SSHRs{1, i}(scales13, :)); sum(SSHRs{1, i}(scales14, :)); sum(SSHRs{1, i}(scales15, :)); sum(SSHRs{1, i}(scales16, :)); sum(SSHRs{1, i}(scales17, :)); sum(SSHRs{1, i}(scales18, :)); sum(SSHRs{1, i}(scales19, :)); sum(SSHRs{1, i}(scales20, :)); sum(SSHRs{1, i}(scales21, :)); sum(SSHRs{1, i}(scales22, :)); sum(SSHRs{1, i}(scales23, :)); sum(SSHRs{1, i}(scales24, :)); SSHRs{1, i}(scales25, :); sum(SSHRs{1, i}(scales26, :)); sum(SSHRs{1, i}(scales27, :)); sum(SSHRs{1, i}(scales28, :)); sum(SSHRs{1, i}(scales29, :)); sum(SSHRs{1, i}(scales30, :)); sum(SSHRs{1, i}(scales31, :)); sum(SSHRs{1, i}(scales32, :)); sum(SSHRs{1, i}(scales33, :)); sum(SSHRs{1, i}(scales34, :)); sum(SSHRs{1, i}(scales35, :)); sum(SSHRs{1, i}(scales36, :)); sum(SSHRs{1, i}(scales37, :)); sum(SSHRs{1, i}(scales38, :)); sum(SSHRs{1, i}(scales39, :)); sum(SSHRs{1, i}(scales40, :)); sum(SSHRs{1, i}(scales41, :)); sum(SSHRs{1, i}(scales42, :)); sum(SSHRs{1, i}(scales43, :)); sum(SSHRs{1, i}(scales44, :)); sum(SSHRs{1, i}(scales45, :)); sum(SSHRs{1, i}(scales46, :)); sum(SSHRs{1, i}(scales47, :)); sum(SSHRs{1, i}(scales48, :)); sum(SSHRs{1, i}(scales49, :))];
    tmp = [sum(HFs{1, i}(scales1, :)); sum(HFs{1, i}(scales2, :)); sum(HFs{1, i}(scales3, :)); sum(HFs{1, i}(scales4, :)); sum(HFs{1, i}(scales5, :)); sum(HFs{1, i}(scales6, :)); sum(HFs{1, i}(scales7, :)); sum(HFs{1, i}(scales8, :)); sum(HFs{1, i}(scales9, :)); sum(HFs{1, i}(scales10, :)); sum(HFs{1, i}(scales11, :)); sum(HFs{1, i}(scales12, :)); sum(HFs{1, i}(scales13, :)); sum(HFs{1, i}(scales14, :)); sum(HFs{1, i}(scales15, :)); sum(HFs{1, i}(scales16, :))];% sum(SSHRs{1, i}(scales17, :)); sum(SSHRs{1, i}(scales18, :)); sum(SSHRs{1, i}(scales19, :)); sum(SSHRs{1, i}(scales20, :)); sum(SSHRs{1, i}(scales21, :)); sum(SSHRs{1, i}(scales22, :)); sum(SSHRs{1, i}(scales23, :)); sum(SSHRs{1, i}(scales24, :)); SSHRs{1, i}(scales25, :); sum(SSHRs{1, i}(scales26, :)); sum(SSHRs{1, i}(scales27, :)); sum(SSHRs{1, i}(scales28, :)); sum(SSHRs{1, i}(scales29, :)); sum(SSHRs{1, i}(scales30, :)); sum(SSHRs{1, i}(scales31, :)); sum(SSHRs{1, i}(scales32, :))];
    v = max(abs(tmp'));
    %v = mean(abs(tmp'));
    norHFs{1, i} = tmp ./ repmat(v', 1, 100);
    
    fprintf('Process shape %i end \n', i);
end
save('norHFs(16) for MPEG7 with max-normal.mat', 'norHFs');

load('HF2s for MPEG7 with max-normal.mat');
norHF2s = cell(1, m-2);
for i = 1 : m-2
    %tmp = [sum(SSHR2s{1, i}(scales1, :)); sum(SSHR2s{1, i}(scales2, :)); sum(SSHR2s{1, i}(scales3, :)); sum(SSHR2s{1, i}(scales4, :)); sum(SSHR2s{1, i}(scales5, :)); sum(SSHR2s{1, i}(scales6, :)); sum(SSHR2s{1, i}(scales7, :)); sum(SSHR2s{1, i}(scales8, :)); sum(SSHR2s{1, i}(scales9, :)); sum(SSHR2s{1, i}(scales10, :)); sum(SSHR2s{1, i}(scales11, :)); sum(SSHR2s{1, i}(scales12, :)); sum(SSHR2s{1, i}(scales13, :)); sum(SSHR2s{1, i}(scales14, :)); sum(SSHR2s{1, i}(scales15, :)); sum(SSHR2s{1, i}(scales16, :)); sum(SSHR2s{1, i}(scales17, :)); sum(SSHR2s{1, i}(scales18, :)); sum(SSHR2s{1, i}(scales19, :)); sum(SSHR2s{1, i}(scales20, :)); sum(SSHR2s{1, i}(scales21, :)); sum(SSHR2s{1, i}(scales22, :)); sum(SSHR2s{1, i}(scales23, :)); sum(SSHR2s{1, i}(scales24, :)); SSHR2s{1, i}(scales25, :); sum(SSHR2s{1, i}(scales26, :)); sum(SSHR2s{1, i}(scales27, :)); sum(SSHR2s{1, i}(scales28, :)); sum(SSHR2s{1, i}(scales29, :)); sum(SSHR2s{1, i}(scales30, :)); sum(SSHR2s{1, i}(scales31, :)); sum(SSHR2s{1, i}(scales32, :)); sum(SSHR2s{1, i}(scales33, :)); sum(SSHR2s{1, i}(scales34, :)); sum(SSHR2s{1, i}(scales35, :)); sum(SSHR2s{1, i}(scales36, :)); sum(SSHR2s{1, i}(scales37, :)); sum(SSHR2s{1, i}(scales38, :)); sum(SSHR2s{1, i}(scales39, :)); sum(SSHR2s{1, i}(scales40, :)); sum(SSHR2s{1, i}(scales41, :)); sum(SSHR2s{1, i}(scales42, :)); sum(SSHR2s{1, i}(scales43, :)); sum(SSHR2s{1, i}(scales44, :)); sum(SSHR2s{1, i}(scales45, :)); sum(SSHR2s{1, i}(scales46, :)); sum(SSHR2s{1, i}(scales47, :)); sum(SSHR2s{1, i}(scales48, :)); sum(SSHR2s{1, i}(scales49, :))];
    tmp = [sum(HF2s{1, i}(scales1, :)); sum(HF2s{1, i}(scales2, :)); sum(HF2s{1, i}(scales3, :)); sum(HF2s{1, i}(scales4, :)); sum(HF2s{1, i}(scales5, :)); sum(HF2s{1, i}(scales6, :)); sum(HF2s{1, i}(scales7, :)); sum(HF2s{1, i}(scales8, :)); sum(HF2s{1, i}(scales9, :)); sum(HF2s{1, i}(scales10, :)); sum(HF2s{1, i}(scales11, :)); sum(HF2s{1, i}(scales12, :)); sum(HF2s{1, i}(scales13, :)); sum(HF2s{1, i}(scales14, :)); sum(HF2s{1, i}(scales15, :)); sum(HF2s{1, i}(scales16, :))];% sum(SSHR2s{1, i}(scales17, :)); sum(SSHR2s{1, i}(scales18, :)); sum(SSHR2s{1, i}(scales19, :)); sum(SSHR2s{1, i}(scales20, :)); sum(SSHR2s{1, i}(scales21, :)); sum(SSHR2s{1, i}(scales22, :)); sum(SSHR2s{1, i}(scales23, :)); sum(SSHR2s{1, i}(scales24, :)); SSHR2s{1, i}(scales25, :); sum(SSHR2s{1, i}(scales26, :)); sum(SSHR2s{1, i}(scales27, :)); sum(SSHR2s{1, i}(scales28, :)); sum(SSHR2s{1, i}(scales29, :)); sum(SSHR2s{1, i}(scales30, :)); sum(SSHR2s{1, i}(scales31, :)); sum(SSHR2s{1, i}(scales32, :))];
    v = max(abs(tmp'));
    %v = mean(abs(tmp'));
    norHF2s{1, i} = tmp ./ repmat(v', 1, 100);
    
    %fprintf('Process shape %i end \n', i);
end
save('norHF2s(16) for MPEG7 with max-normal.mat', 'norHF2s');

a=1;