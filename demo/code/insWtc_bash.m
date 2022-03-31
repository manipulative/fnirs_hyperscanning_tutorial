function insWtc_bash(wtc_params, bash_params, datafiles)
% A function used to calculate wavelet coherence in bash
%
% INPUTS:
%     wtc_params:
%                 fs: Sampling frequency(Hz); e.g. fs = 10
%                lag: Interested time-lag (second). It could be a single 
%                     integer or vector; e.g. lag = [0 -2 2 -4 4]
%                 TR: Data time range to calculate; e.g. TR = [150 750]
%          wtcmethod: The way of channel assignment during wtc
%                     calculation, 'align' or 'cross' channel
%         savemethod: Save whole wtc data or time-averaged data,
%                     'average' or 'all'
%
%     bash_params:
%            savedir: wtc data save folder
%           datatype: the field name of data in files; e.g. 'oxyData'
%             fileID: an identified name of wtc file within each dyad, e.g.
%                     'rest' or 'talk' or 'run1' or 'run2'
%
%     datafiles: a list of .mat datafiles to run wtc over. The list should
%                contain three column as follow:
%                |dyad_ID|sub1_file|sub2_file|
%                Each row indicates one dyad. The dyad_ID indicates the ID
%                indicates of each dyad. And the sub1_file and sub2_file
%                indicates .mat file name of subjects within each dyad.
%                Each .mat file should contain at least a [time x channel]
%                matrix correspond to datatype in bash_params
%
% OUTPUTS:
%     wtc data files stored in a BIDS-like structure folder:
%         savedir
%           - <dyad> (e.g. 'dyad-01')
%                - <lag> (e.g. '2')
%                    - <filename>.mat (e.g. 'rest.mat')
%
% DEPENDENCY:
%   insWtc function
% Siyuan Zhou, Lulab, BNU, 2022/03

%% init
params.fs = wtc_params.fs;
params.TR = wtc_params.TR;
params.wtcmethod = wtc_params.wtcmethod;
params.savemethod = wtc_params.savemethod;

lag = wtc_params.lag;

savedir = bash_params.savedir;
dyadlist = datafiles(:,1);
datatype = bash_params.datatype;
fileID = bash_params.fileID;

Nfile = size(datafiles,1);
Nlag = length(lag);

wtcfiles = {};

for n_file = 1:Nfile
    %% load data
    fprintf(['\n *** Calculating WTC: '  dyadlist{n_file} ':' fileID '***\n']);
    
    dyad_ID = datafiles{n_file,1};
    raw_name1 = datafiles{n_file,2};
    raw_name2 = datafiles{n_file,3};
    d1 = load(raw_name1);
    d2 = load(raw_name2);
    data1 = d1.(datatype);
    data2 = d2.(datatype);
    
    for n_lag = 1:Nlag % lag loop
        params.lag = lag(n_lag);
        
        wtcData = insWtc(params, data1, data2);
        
        savefolder = fullfile(savedir,dyad_ID,num2str(params.lag));
        mkdir(savefolder)
        savefile = fullfile(savefolder,[fileID '.mat']);
        
        save(savefile,'wtcData'); 
    end
end


    
    
    
    
