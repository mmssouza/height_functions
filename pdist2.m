function [md] = pdist2(X,Y,C1,C2,thre,num_start,search_step,beta)
 Fl1 = X;
 Fl2 = Y; 
 m = length(Fl1);
 md = zeros(m,m);
 for k1 = 1:m
  f1 = Fl1{k1};
  sc1 = C1(k1);
  for k2 = k1:m
   if k1 ~= k2
    f2 = Fl1{k2};
    sc2 = C1(k2);
    f3 = Fl2{k2};
    sc3 = C2(k2);
    [costmat1] = weighted0_tar_cost(f1, f2);
    [costmat2] = weighted0_tar_cost(f1, f3);    
    %-- MATCHING
    [cvec1, match_cost1] = mixDPMatching_C(costmat1, thre, num_start, search_step);
    [cvec2, match_cost2] = mixDPMatching_C(costmat2, thre, num_start, search_step);
    md(k1, k2) = min(match_cost1/(sc1+sc2+beta), match_cost2/(sc1+sc3+beta));
   endif
  end
 end 
 md = md + md'
 return; 
 
