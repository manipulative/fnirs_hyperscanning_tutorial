function wtcData = insWtc(params, nirs1, nirs2)
% Calculate WTC in dyad level
% INPUTS:
%     params:
%                 fs: Sampling frequency(Hz); e.g. fs = 10
%                lag: Interested time-lag (second). Only single integer is 
%                     allowed; e.g. lag = -2; ATTENTION: differ from
%                     insWtc_bash
%                 TR: Data time range to calculate; e.g. TR = [150 750]
%          wtcmethod: The way of channel assignment during wtc
%                     calculation, 'align' or 'cross' channel
%         savemethod: Save whole wtc data or time-averaged data,
%                     'average' or 'all'
%
%     nirs1 & nirs2: The [time x channel] nirs data matrix of two
%                    subjects in each dyad.
%
% OUTPUTS:
%     wtcData: The calculated wtc data. The data struct is:
%              'align' & 'average': [fs x channel_pair]
%              'align' & 'whole'  : [fs x time x channel_pair]
%              'cross' & 'average': [fs x channel_pair]
%              'cross' & 'whole'  : [fs x time x channel_pair]
%         for the 'cross' method, the channel id of each pair could be
%         decomposited by reshape()
%
% DEPENDENCY:
%     Wavelet toolbox (MATLAB built-in)
% Siyuan Zhou, Lulab, BNU, 2022/03

%% init
fs = params.fs;
lag = params.lag;
TR = params.TR;
wtcmethod = params.wtcmethod;
savemethod = params.savemethod;

TR1 = TR(1);
TR2 = TR(2);

%% load data
data1 = nirs1(TR1+1:TR2,:);
data2 = nirs2(TR1+1:TR2,:);
clear nirs1 nirs2

%% data lag
lag_num = lag;
lag_fs = ceil(abs(lag_num) * fs);

% when lag is postive, means 1 follows 2 and cut 1's foreside;
% when lag is negative, means 1 preceedes 2 and cut 1's backside;
if lag_num > 0
    data1_lag = data1(lag_fs:end,:);
    data2_lag = data2(1:end-lag_fs+1,:);
elseif lag_num <0
    data1_lag = data1(1:end-lag_fs+1,:);
    data2_lag = data2(lag_fs:end,:);
elseif lag_num == 0
    data1_lag = data1;
    data2_lag = data2;
else
    error('wrong lag parameters')
end

%% calculate WTC
% access meta information
[TR_len Nch] = size(data1_lag);
[~,~,f] = wcoherence(ones(TR_len,1),ones(TR_len,1),fs);
[fs_len] = length(f);

% calculating
if strcmp(wtcmethod, 'align')
    wtc_whole = nan(fs_len, TR_len, Nch);
    
    for ch1 = 1:Nch
        wtc_whole(:,:,ch1) = wcoherence(data1_lag(:,ch1),data2_lag(:,ch1));
    end
    
    wtc_value = wcoherence(data1, data2);
    
elseif strcmp(wtcmethod, 'cross')
    wtc_whole = nan(fs_len, TR_len, Nch*Nch);
    
    idx = 0;
    for ch1 = 1:Nch
        for ch2 = 1:Nch
            idx = idx + 1;
            wtc_whole(:,:,idx) = wcoherence(data1_lag(:,ch1),data2_lag(:,ch2));
        end
    end
    
else
    error('wrong method parameters')
end

%% data save
if strcmp(savemethod, 'average')
    wtcData = squeeze(mean(wtc_whole,2));
elseif strcmp(savemethod, 'all')
    wtcData = wtc_whole;
end
