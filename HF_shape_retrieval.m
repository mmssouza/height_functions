%---------- matching by height functions feature ----------%


addpath common_HF;
clear;
load('norHFs(16) for MPEG7 with max-normal.mat');
load('norHF2s(16) for MPEG7 with max-normal.mat');

%---- file name parameters ----
m=1402;

%---- matching score save ----
Score = zeros(m-2);
%- matching parameters
num_start = 100;
search_step	= 1;
thre = 0.0;

TA1 = fix(clock); % start time
for k1 = 1:m-2  % the diagonal also need matching!
    f1 = norHFs{k1};
    for k2 = 1:m-2  % matching the two shapes with their feature by DP
        f2 = norHFs{k2};
        f3 = norHF2s{k2};
        %tmp = fliplr(flipud(SSHRs{k2}));
        %f3 = [sum(tmp(scales1, :)); sum(tmp(scales2, :)); sum(tmp(scales3, :))];
        %-- compute the cost matrix b/w points in feature1 and feature2. 
        [costmat1] = weighted0_tar_cost(f1, f2);
        [costmat2] = weighted0_tar_cost(f1, f3);
        
        %-- MATCHING
        %- in current order
        [cvec1, match_cost1] = mixDPMatching_C(costmat1, thre, num_start, search_step);
        %- in reverse order
        [cvec2, match_cost2] = mixDPMatching_C(costmat2, thre, num_start, search_step);

        %- get the best result
        Score(k1, k2) = min(match_cost1, match_cost2);
    end
    
    fprintf('Process line %i end \n', k1);
end
TA2 = fix(clock); % end time
%---- save matching score
save('weighted0-tar distance (16) th=0.0 norHFs 1400Score.mat', 'Score');        % Score
%load('Score.mat');


%---- compute matching accuracy
%FullScore = Score + Score';
[sorted, index] = sort(Score);  % by column, sort(Score, 1)
%-- judge the first 40 rows of 'index', whether the place is in proper range, and count number
n_class = (m-2)/20;  % how many classes of objects in DB
n_obj = 20;   % how many objects in every class
hit_num = zeros(1, n_class);  % how many objects found in matching for every class
for i = 1 : n_class
    index_min = 1 + n_obj * (i - 1);  % the two indices denote both the column range for every class
    index_max = n_obj * i;            % and the proper index range
    
    hit_num(i) = length(find(index(1 : 40, index_min : index_max) >= index_min & index(1 : 40, index_min : index_max) <= index_max));
end

%-- statis, VC+DP 66%
Accu_class = hit_num / (n_obj * n_obj);
Accu = sum(hit_num) / (n_obj * n_obj * n_class);

figure(1);
bar(Accu_class);
title(strcat('Accu = ', num2str(Accu)));

return;
