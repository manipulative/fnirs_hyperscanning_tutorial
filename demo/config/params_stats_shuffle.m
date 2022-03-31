clear 

%% bash_params
stats_params.fsMask = [25:92];
stats_params.chMask = 1:16;
stats_params.savedir = './data/stats/shuffle/';
stats_params.savename = 'ttest_result.mat';
stats_params.fisherz_mark = 0;
stats_params.groupMask = [ones(1,20) ones(1,20)*2];
stats_params.NofSample = [5 5];

%% generate file list - here we only focused on one time-lag
lag = '0';

dyadID = {'treat-01_treat-02';'treat-01_treat-03';'treat-01_treat-04';'treat-01_treat-05';'treat-02_treat-01';'treat-02_treat-03';'treat-02_treat-04';'treat-02_treat-05';'treat-03_treat-01';'treat-03_treat-02';'treat-03_treat-04';'treat-03_treat-05';'treat-04_treat-01';'treat-04_treat-02';'treat-04_treat-03';'treat-04_treat-05';'treat-05_treat-01';'treat-05_treat-02';'treat-05_treat-03';'treat-05_treat-04';'control-01_control-02';'control-01_control-03';'control-01_control-04';'control-01_control-05';'control-02_control-01';'control-02_control-03';'control-02_control-04';'control-02_control-05';'control-03_control-01';'control-03_control-02';'control-03_control-04';'control-03_control-05';'control-04_control-01';'control-04_control-02';'control-04_control-03';'control-04_control-05';'control-05_control-01';'control-05_control-02';'control-05_control-03';'control-05_control-04';};

taskfiles = fullfile('data/permute',dyadID,lag,'talk.mat');
restfiles = fullfile('data/permute',dyadID,lag,'rest.mat');
