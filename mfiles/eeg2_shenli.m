clc;clear;close all;
addpath('/Users/Emily/Documents/sleep');
fs=1000;
data_folder='/Users/Emily/Documents/sleep/data';
[trigger_trace, timestamps, info] = load_open_ephys_data(fullfile(data_folder,'100_ADC1.continuous'));
[EEG, timestamps, info] = load_open_ephys_data(fullfile(data_folder,'100_CH9.continuous'));
[EMG, timestamps, info] = load_open_ephys_data(fullfile(data_folder,'100_CH16.continuous'));
ts=1/fs:1/fs:length(EMG)/fs;
%%
[s,f,t,ps]=spectrogram(EEG,5*fs,2.5*fs,1:0.1:30,fs);
s=abs(s);
% ps=log(ps);
% ps=ps;
ps_db=10*log10(ps);
%%
figure,
subplot(3,1,1)
% spectrogram(EEG,5*fs,2.5*fs,1:0.1:30,fs,'yaxis');
imagesc(t,f,ps_db);
% colormap(jet);
caxis([-2,30])
colorbar;
axis xy;

subplot(3,1,2)   
plot(linspace(0,length(EMG)/fs/60,length(EMG)),EMG);ylim([-1000,1000]);colorbar;xlim([0,29])

subplot(3,1,3)
plot(linspace(0,length(trigger_trace)/fs/60,length(trigger_trace)),trigger_trace);colorbar;xlim([0,29])
%%
delta_range=find(f>=1 & f<=4);
theta_range=find(f>=6 & f<=12);
delta_power=sum(ps(delta_range,:));
theta_power=sum(ps(theta_range,:));
theta_delta_ratio=theta_power./delta_power;
figure,subplot(311),plot(t,delta_power);
subplot(312),plot(t,abs(theta_power));
subplot(313),plot(t,theta_delta_ratio);
%%  EEG Delta Power
% figure
% histogram(delta_power);

[N,edges]=histcounts(delta_power,50);
N=N/sum(N);
bincenter=(edges(1:end-1)+edges(2:end))/2;
figure,
bar(bincenter,N);
hold on,
fit_deltapower_hist = fit(bincenter',N','gauss3');
yfit=feval(fit_deltapower_hist,bincenter');
plot(fit_deltapower_hist);
plot(bincenter,yfit,'b');
a=find(diff(yfit)>0);
b=find((yfit(1:end-1)-yfit(2:end))>0)+1;
troughs=a(ismember(a,b));

threshold_delta=bincenter(troughs(1));
% mean(delta_power)
% median(delta_power)
%%
% threshold_delta=433;% manually
higher_delta_power_range=find(delta_power>threshold_delta);
% higher_delta_power_range=remove_short_seg(higher_delta_power_range,2);

figure,plot(t,delta_power);hold on,
plot([t(1),t(end)],threshold_delta*ones(1,2),'r');
plot(t(higher_delta_power_range),delta_power(higher_delta_power_range),'r.');
%% EMG analysis
[s_emg,f_emg,t_emg]=spectrogram(EMG,5000,2500,20:300,1000,'yaxis');
sum_EMG_power=sum(abs(s_emg));

mean_EMG_power=mean(sum_EMG_power);
std_EMG_power=std(sum_EMG_power);
std_lower_EMG_power=std(sum_EMG_power(sum_EMG_power<mean_EMG_power));
% low_EMG_power_range=find(sum_EMG_power<(mean_EMG_power-std_lower_EMG_power));

[N,edges]=histcounts(sum_EMG_power,70);
N=N/sum(N);
bincenter=(edges(1:end-1)+edges(2:end))/2;
figure,
bar(bincenter,N);
hold on,plot(mean_EMG_power*ones(1,2),[0,max(N)],'r');
plot((mean_EMG_power-std_lower_EMG_power)*ones(1,2),[0,max(N)],'r--');
fit_EMG_hist = fit(bincenter',N','gauss3');
plot(fit_EMG_hist);
yfit=feval(fit_EMG_hist,bincenter');
a=find(diff(yfit)>0);
b=find((yfit(1:end-1)-yfit(2:end))>0)+1;
troughs=a(ismember(a,b));
threshold1_emg=edges(troughs(1));
threshold2_emg=edges(troughs(end));
%% single thresholding (higher)
low_EMG_power_range=find(sum_EMG_power<threshold2_emg);
low_EMG_power_range=remove_short_seg(low_EMG_power_range,2);

% a=find(diff(low_EMG_power_range_gaussfit)<2);
% b=find((low_EMG_power_range_gaussfit(1:end-1)-low_EMG_power_range_gaussfit(2:end))>-2)+1;
% low_EMG_power_continues_range=low_EMG_power_range_gaussfit(union(a,b));
%% double thresholding
low_EMG_power_range2=find(sum_EMG_power<threshold1_emg);
low_EMG_power_range3=find(sum_EMG_power>threshold1_emg & sum_EMG_power<threshold2_emg);
% low_EMG_power_range3=remove_short_seg(low_EMG_power_range3,2);
low_EMG_power_range=[low_EMG_power_range2,low_EMG_power_range3];
%%
% [start_idx3,end_idx3,lens3]=find_bound(low_EMG_power_range_gaussfit3);
% seg_idx3=find(lens3>1);
% low_EMG_power_continues_range3=[];
% diffs=[];
% for i=1:length(seg_idx3)
%     tmp=low_EMG_power_range_gaussfit3(start_idx3(seg_idx3(i)):end_idx3(seg_idx3(i)));
%     low_EMG_power_continues_range3=[low_EMG_power_continues_range3,tmp];
%     diffs=[diffs,diff(sum_EMG_power(tmp))];
% end
% mean(diffs)
% std(diffs)
%%
figure,
% subplot(311),plot(t,delta_power);
subplot(311),plot(ts,EMG);
subplot(312)
imagesc(t_emg,f_emg,abs(s_emg));axis xy;colormap(jet)
subplot(313)
plot(t_emg,sum_EMG_power);hold on
% plot([0,t_emg(end)],mean_EMG_power*ones(1,2),'r');
% plot([0,t_emg(end)],(mean_EMG_power-std_lower_EMG_power)*ones(1,2),'r--');

plot([0,t_emg(end)],threshold*ones(1,2),'r');
% plot(t_emg(low_EMG_power_continues_range),sum_EMG_power(low_EMG_power_continues_range),'r.');

plot([0,t_emg(end)],threshold2*ones(1,2),'r');
plot(t_emg(low_EMG_power_continues_range2),sum_EMG_power(low_EMG_power_continues_range2),'b.');
plot(t_emg(low_EMG_power_continues_range3),sum_EMG_power(low_EMG_power_continues_range3),'r.');
%% NREM: higher delta power, lower EMG
nrem_idx=higher_delta_power_range(ismember(higher_delta_power_range,low_EMG_power_continues_range));
%% REM: lower delta power, higher theta/delta ratio, lower EMG
mean_theta_delta_ratio=mean(theta_delta_ratio);
std_theta_delta_ratio=std(theta_delta_ratio);
threshold_theta_delta_ratio=mean_theta_delta_ratio+std_theta_delta_ratio;
higher_theta_delta_ratio_range=find(theta_delta_ratio>threshold_theta_delta_ratio);
%%
[N,edges]=histcounts(theta_delta_ratio,70);
N=N/sum(N);
bincenter=(edges(1:end-1)+edges(2:end))/2;
figure,
bar(bincenter,N);
hold on,plot(mean_theta_delta_ratio*ones(1,2),[0,max(N)],'r');
plot((mean_theta_delta_ratio+std_theta_delta_ratio)*ones(1,2),[0,max(N)],'r--');
fit_theta_delta_ratio_hist = fit(bincenter',N','gauss2');
plot(fit_theta_delta_ratio_hist);
yfit=feval(fit_theta_delta_ratio_hist,bincenter');
a=find(diff(yfit)>0);
b=find((yfit(1:end-1)-yfit(2:end))>0)+1;
troughs=a(ismember(a,b))
% threshold1_emg=edges(troughs(1));
% threshold2_emg=edges(troughs(end));
threshold_theta_delta_ratio=mean_theta_delta_ratio;
%%
higher_theta_delta_ratio_range=find(theta_delta_ratio>threshold_theta_delta_ratio);

lower_delta_power=setdiff(1:length(t),higher_delta_power_range);
rem_idx=lower_delta_power(ismember(lower_delta_power,higher_theta_delta_ratio_range));
rem_idx=rem_idx(ismember(rem_idx,low_EMG_power_continues_range));
%% Awake: higher EMG // (lower delta power // lower theta_delta_ratio)
awake_idx=setdiff(1:length(t),[rem_idx,nrem_idx]);
%% NREM='orange', REM='blue', awake='gray'
nrem_color=[1,0.5,0.5];
figure,
subplot(311)
plot(t,delta_power);hold on
plot([t(1),t(end)],threshold_delta*ones(1,2),'r');
plot(t(nrem_idx),delta_power(nrem_idx),'.','color',nrem_color);
plot(t(rem_idx),delta_power(rem_idx),'b.');%,'color',[1,0.5,0.5]);
plot(t(awake_idx),delta_power(awake_idx),'k.');
title('Delta Power');
subplot(312)
plot(t,theta_delta_ratio);hold on
plot([t(1),t(end)],threshold_theta_delta_ratio*ones(1,2),'r');
plot(t(nrem_idx),theta_delta_ratio(nrem_idx),'.','color',nrem_color);
plot(t(rem_idx),theta_delta_ratio(rem_idx),'b.');
plot(t(awake_idx),theta_delta_ratio(awake_idx),'k.');
title('Theta/Delta Ratio');
subplot(313)
plot(t_emg,sum_EMG_power);hold on
plot(t_emg(nrem_idx),sum_EMG_power(nrem_idx),'.','color',nrem_color);
plot(t_emg(rem_idx),sum_EMG_power(rem_idx),'b.');
plot(t_emg(awake_idx),sum_EMG_power(awake_idx),'k.');
title('EMG power');
%% corresponding ts (fs=1000)
nrem_ts=[];
rem_ts=[];
awake_ts=[];
if nrem_idx(1)==1
    nrem_ts=find(ts>=0 & ts<1.25);
end
if rem_idx(1)==1
    rem_ts=find(ts>=0 & ts<1.25);
end
if awake_idx(1)==1
    awake_ts=find(ts>=0 & ts<1.25);
end
for i=1:length(nrem_idx)
    nrem_ts=[nrem_ts,find(ts>=t(nrem_idx(i))-1.25 & ts<t(nrem_idx(i))+1.25)];
end
for i=1:length(rem_idx)
    rem_ts=[rem_ts,find(ts>=t(rem_idx(i))-1.25 & ts<t(rem_idx(i))+1.25)];
end
for i=1:length(awake_idx)
    awake_ts=[awake_ts,find(ts>=t(awake_idx(i))-1.25 & ts<t(awake_idx(i))+1.25)];
end
%%
[start_nrem,end_nrem,lens_nrem]=find_bound(nrem_idx);
start_nrem=nrem_idx(start_nrem);
end_nrem=nrem_idx(end_nrem);
[start_rem,end_rem,lens_rem]=find_bound(rem_idx);
start_rem=rem_idx(start_rem);
end_rem=rem_idx(end_rem);
[start_awake,end_awake,lens_awake]=find_bound(awake_idx);
start_awake=awake_idx(start_awake);
end_awake=awake_idx(end_awake);
%%
figure,
subplot(3,1,1)
imagesc(t*2.5/60,f,ps_db);
caxis([-2,30])
colorbar;
axis xy;

subplot(312);
for i=1:length(start_nrem)
    patch(t([start_nrem(i),end_nrem(i),end_nrem(i),start_nrem(i)])*2.5/60,[0,0,1,1],nrem_color,'facealpha',0.5,'edgecolor','none');
end
for i=1:length(start_rem)
    patch(t([start_rem(i),end_rem(i),end_rem(i),start_rem(i)])*2.5/60,[0,0,1,1],[0,0,1],'facealpha',0.5,'edgecolor','none');
end
for i=1:length(start_awake)
    patch(t([start_awake(i),end_awake(i),end_awake(i),start_awake(i)])*2.5/60,[0,0,1,1],[0,0,0],'facealpha',0.5,'edgecolor','none');
end
colorbar;
% plot(ts(nrem_ts),EEG(nrem_ts),'.','color',nrem_color);
% plot(ts(rem_ts),EEG(rem_ts),'.','color','b');
% plot(ts(awake_ts),EEG(awake_ts),'.','color','k');
xlim([0,29])


subplot(3,1,3)
plot(linspace(0,length(trigger_trace)/fs/60,length(trigger_trace)),trigger_trace);colorbar;xlim([0,29])

%%