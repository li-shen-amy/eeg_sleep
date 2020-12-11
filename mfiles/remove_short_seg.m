function output_sig=remove_short_seg(ori_sig,min_len)
[start_idx,end_idx,lens]=find_bound(ori_sig);
seg_idx=find(lens>=min_len);
output_sig=[];
for i=1:length(seg_idx)
    output_sig=[output_sig,...
        ori_sig(start_idx(seg_idx(i)):end_idx(seg_idx(i)))];
end