function [md] = pdist2(X,thre,num_start,search_step)
 m = length(X);
 md = zeros(m,m);
 for k1 = 1:m
  f1 = X{k1};
  for k2 = k1:m
   if k1 ~= k2
    f2 = X{k2};
    [costmat] = weighted0_tar_cost(f1, f2);
    %-- MATCHING
    [cvec1, match_cost] = mixDPMatching_c(costmat, thre, num_start, search_step);
    md(k1, k2) = match_cost;
   endif
  end
 end 
 md = md + md'
 return; 
 