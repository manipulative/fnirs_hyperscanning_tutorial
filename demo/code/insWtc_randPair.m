function insWtc_randPair(wtc_params, RP_params, datafiles)
% A function used to calculate random-pair WTC (Bash available)
%
% INPUTS:
%     bash_params:
%                 fs: Sampling frequency(Hz); e.g. fs = 10
%                lag: Interested time-lag (second). It could be a single 
%                     integer or vector; e.g. lag = [0 -2 2 -4 4]
%                 TR: Data time range to calculate; e.g. TR = [150 750]
%          wtcmethod: The way of channel assignment during wtc
%                     calculation, 'align' or 'cross' channel
%         savemethod: Save whole wtc data or time-averaged data,
%                     'average' or 'all'
%
%     RP_params:
%            savedir: save folder
%           datatype: the field name of data in files; e.g. 'oxyData'
%             fileID: an identified name of wtc file within each dyad, e.g.
%                     'rest' or 'talk' or 'run1' or 'run2'
%          groupMask: a vector which the length is same as rows of datafiles to
%                     indicates within-RP group in datafiles; 
%                     e.g. [1 1 1 1 1 2 2 2 2 2]
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
%     N_RP: permutation times of random pair, e.g. 1000;
%
% OUTPUTS:
%     wtc data files stored in a BIDS-like structure folder:
%         savedir
%           - <dyad-ID1_ID2> (e.g. 'dyad-01_02')
%                - <lag> (e.g. '2')
%                    - <filename>.mat (e.g. 'rest.mat')
%
% DEPENDENCY:
%   insWtc_bash function
% Siyuan Zhou, Lulab, BNU, 2022/03

RP_list = randPair(datafiles, RP_params.groupMask); 

insWtc_bash(wtc_params, RP_params, RP_list);




