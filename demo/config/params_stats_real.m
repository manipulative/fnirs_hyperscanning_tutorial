clear

%% bash_params
stats_params.fsMask = [25:92];
stats_params.chMask = 1:16;
stats_params.savedir = './data/stats/real/';
stats_params.savename = 'ttest_result.mat';
stats_params.fisherz_mark = 0;
stats_params.groupMask = [ones(1,5) ones(1,5)*2];

%% generate file list - here we only focused on one time-lag
lag = '0';

dyad_ID = {
    'treat-01'
    'treat-02'
    'treat-03'
    'treat-04'
    'treat-05'
    'control-01'
    'control-02'
    'control-03'
    'control-04'
    'control-05'};

taskfiles = fullfile('data/group',dyad_ID,lag,'talk.mat');
restfiles = fullfile('data/group',dyad_ID,lag,'rest.mat');

