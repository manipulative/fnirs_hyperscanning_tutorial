clear

%% bash_params
stats_params.fsMask = [30:93];%改
stats_params.chMask = 1:16;
stats_params.savedir = '';
stats_params.savename = 'anova_result.mat';
stats_params.fisherz_mark = 0;
stats_params.betweenMask = [1 1 1 2 2 2 1 1 1 2 2 2];
stats_params.withinMask =  [1 1 1 1 1 1 2 2 2 2 2 2]; %改

%% generate file list - here we only focused on one time-lag
lag = '0';

dyad_ID = {'kc1'
    'kc2'
    'kc3'
    'kf1'
    'kf2'
    'kf3'};

highfiles = fullfile('group_test',dyad_ID,lag,'highavg.mat');
lowfiles = fullfile('group_test',dyad_ID,lag,'lowavg.mat');

taskfiles = [highfiles;lowfiles]; % file order should match between and within mask
restfiles = fullfile('group_test',dyad_ID,lag,'restavg.mat');