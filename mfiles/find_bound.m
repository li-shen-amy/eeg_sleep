function [start_idx,end_idx,lens]=find_bound(index)
end_idx=find(diff(index)>1);
start_idx=end_idx+1;
end_idx=[end_idx,length(index)];
start_idx=[1,start_idx];
lens=end_idx-start_idx;