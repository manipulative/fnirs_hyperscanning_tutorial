function insStats_ttest2_perm(stats_params, N_perm, taskfiles, varargin)
% A function used to perform two-sample t-test of shuffled wtc data
%
% INPUTS:
%     stats_params:
%               fsMask: Select the frequency of interested; 
%                       e.g. fsMask = [25:92]
%               chMask: Select the channel pair of interested; 
%                       e.g. chMask = [1:16]
%              savedir: T-test results save folder
%             savename: T-test results save name
%         fisherz_mark: Whether the wtc were fisher-z transformed; e.g. 0 or 1
%            groupMask: A vector to indicate group of each shuffle files 
%                       e.g. [1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2]
%            NofSample: the number of sample of each group; e.g. [5 5]
%
%     N_perm: The times of permutation; e.g. N_perm = 100;
%     taskfiles: a list of .mat datafiles to run two sample t-test, which
%                containd ONLY ONE column contains shuffled wtc datafiles 
%                location. Each wtc .mat file should contain a 
%                [fs x channel pair]. And the order of files should align 
%                to groupMask.
%     restfiles: OPTIONAL INPUT. If restfiles added as input, the function
%                would conduct de-rest operation before t-test
%
% OUTPUTS:
%     a series [fs x channel pair] matrix shuffled t-test results files 
%     stored in savedir with savename
%
% Siyuan Zhou, Lulab, BNU, 2022/03

rng('shuffle')
savedir = stats_params.savedir;
rootname = stats_params.savename;
groupMask = stats_params.groupMask;
NofSample = stats_params.NofSample;

sub_params = stats_params;

groupMask1 = groupMask==1;
groupMask2 = groupMask==2;

taskfiles1 = taskfiles(groupMask1,:);
taskfiles2 = taskfiles(groupMask2,:);

for ii = 1:N_perm
    sub_params.savename = ['RP' num2str(ii) '_' rootname];
    sub_params.groupMask = [ones(1,NofSample(1)) ones(1,NofSample(2))*2];
    
    idx1 = randperm(size(taskfiles1,1),NofSample(1));
    idx2 = randperm(size(taskfiles1,1),NofSample(2));
    
    if nargin < 4
        taskfiles1_sub = taskfiles1(idx1,:);
        taskfiles2_sub = taskfiles2(idx2,:);
        taskfiles_sub = [taskfiles1_sub; taskfiles2_sub];
        
        insStats_ttest2(sub_params, taskfiles_sub)
    else
        taskfiles1_sub = taskfiles1(idx1,:);
        taskfiles2_sub = taskfiles2(idx2,:);
        taskfiles_sub = [taskfiles1_sub; taskfiles2_sub];
        
        restfiles1 = varargin{:}(groupMask1,:);
        restfiles2 = varargin{:}(groupMask2,:);
        restfiles1_sub = restfiles1(idx1,:);
        restfiles2_sub = restfiles2(idx2,:);
        restfiles_sub = [restfiles1_sub; restfiles2_sub];
        
        insStats_ttest2(sub_params, taskfiles_sub, restfiles_sub)
    end
end



