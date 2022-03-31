clear

%% wtc_params
wtc_params.fs = 8.333;
wtc_params.lag = [0 -2 2];
wtc_params.TR = [100 900];
wtc_params.wtcmethod = 'cross';
wtc_params.savemethod = 'average';

%% bash_params
bash_params.savedir = './data/group';
bash_params.datatype = 'oxyData';
bash_params.fileID = 'talk';

%% generate datafile list
dyadID = {'control-01'
    'control-02' 
    'control-03' 
    'control-04' 
    'control-05'
    'treat-01'
    'treat-02'
    'treat-03'
    'treat-04'
    'treat-05'};

datafiles(:,1) = dyadID;
datafiles(:,2) = fullfile('data',dyadID,'F_talk.mat');
datafiles(:,3) = fullfile('data',dyadID,'M_talk.mat');

%% RP_params
RP_params.savedir = './data/permute';
RP_params.datatype = 'oxyData';
RP_params.fileID = 'talk';

RPfiles_treat = randPair(datafiles(1:5,:)); % treat group random pair
RPfiles_control = randPair(datafiles(6:10,:)); % control group random pair
RPfiles = [RPfiles_treat; RPfiles_control];