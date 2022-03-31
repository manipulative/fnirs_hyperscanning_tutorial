function insStats_ttest2(stats_params, taskfiles, varargin)
% A function used to perform two-sample t-test of wtc data
%
% INPUTS:
%     stats_params:
%               fsMask: Select the frequency of interested; 
%                       e.g. fsMask = [25:92]
%               chMask: Select the channel pair of interested; 
%                       e.g. chMask = [1:16]
%              savedir: T-test results save folder
%             savename: T-test results save name
%         fisherz_mark: Whether the wtc were fisher-z transformed; 
%                       e.g. 0 or 1
%            groupMask: A vector to indicate group of each files;
%                       e.g. [1 1 1 1 1 2 2 2 2 2]
%
%     taskfiles: a list of .mat datafiles to run two sample t-test, which
%                containd ONLY ONE column contains wtc datafiles location.
%                Each wtc .mat file should contain a [fs x channel pair].
%                And the order of files should align to groupMask.
%     restfiles: OPTIONAL INPUT. If restfiles added as input, the function
%                would conduct de-rest operation before t-test
%
% OUTPUTS:
%     a [fs x channel pair] matrix t-test results files stored in savedir
%     with savename
%
% Siyuan Zhou, Lulab, BNU, 2022/03


fsMask= stats_params.fsMask;
chMask= stats_params.chMask;
groupMask = stats_params.groupMask;
savedir = stats_params.savedir;
savename = stats_params.savename;
fisherz_mark = stats_params.fisherz_mark;

Nfile = size(taskfiles,1);
Nfs = length(fsMask);
Nch = length(chMask);

groupMask1 = groupMask==1;
groupMask2 = groupMask==2;

wtcWhole = nan([length(fsMask),length(chMask)]);

for ii = 1:Nfile
    if nargin < 3
        dataname = taskfiles{ii};
        load(dataname)
        if fisherz_mark == 0
            wtcData = 0.5.*log((1.+wtcData)./(1.-wtcData));
        end
        
    else
        dataname = taskfiles{ii};
        load(dataname);
        taskdata = wtcData;
        dataname = varargin{:}{ii};
        load(dataname);
        restdata = wtcData;
        if fisherz_mark == 0
            taskdata = 0.5.*log((1.+taskdata)./(1.-taskdata));
            restdata = 0.5.*log((1.+restdata)./(1.-restdata));
        end
        wtcData = taskdata - restdata;
        
    end
    
    wtcWhole(:,:,ii) = wtcData(fsMask,chMask);
end

tmap = nan(Nfs, Nch);
pmap = nan(Nfs, Nch);

for nfs = 1:Nfs
    for nch = 1:Nch
        % run stats
        x = squeeze(wtcWhole(nfs,nch,groupMask1));
        y = squeeze(wtcWhole(nfs,nch,groupMask2));
        [h p ci stat] = ttest2(x,y);
        
        % store
        tmap(nfs,nch) = stat.tstat;
        pmap(nfs,nch) = p;
    end
end

mkdir(savedir);
savename = fullfile(savedir,savename);
save(savename,'tmap','pmap');

fprintf(['\n *** Results saved ***\n']);




