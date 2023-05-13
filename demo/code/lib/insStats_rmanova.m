function insStats_rmanova(stats_params, taskfiles, varargin)
% A function used to perform mixed ANOVA of wtc data
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
%            betweenMask: A vector to indicate BETWEEN var of each files;
%                       e.g. [1 1 1 1 1 1 2 2 2 2 2 2]
%             withinMask: AA vector to indicate WITHIN var of each files;
%                       e.g. [1 2 1 2 1 2 1 2 1 2 1 2]
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
% Siyuan Zhou, Lulab, BNU, 2023/01


fsMask= stats_params.fsMask;
chMask= stats_params.chMask;
betweenMask = stats_params.betweenMask;
withinMask = stats_params.withinMask;
savedir = stats_params.savedir;
savename = stats_params.savename;
fisherz_mark = stats_params.fisherz_mark;

Nfile = size(taskfiles,1);
Nfs = length(fsMask);
Nch = length(chMask);

%
withinMask1 = withinMask==1;
withinMask2 = withinMask==2;
%

wtcWhole = nan([length(fsMask),length(chMask)]);

for ii = 1:Nfile
    if nargin < 3
        dataname = taskfiles{ii};
        load(dataname)
        if fisherz_mark == 0
            wtcData = 0.5.*log((1.+wtcData)./(1.-wtcData));
        end

    else
        dataname = taskfiles{ii}
        load(dataname);
        wtcData = wtcavgData; % temp
        taskdata = wtcData;

        if Nfile/2 >= ii
            jj = ii;
        else
            jj = ii - Nfile/2;
        end

        dataname = varargin{:}{jj}
        load(dataname)
        wtcData = wtcavgData; % temp
        restdata = wtcData;

        if fisherz_mark == 0
            taskdata = 0.5.*log((1.+taskdata)./(1.-taskdata));
            restdata = 0.5.*log((1.+restdata)./(1.-restdata));
        end
        wtcData = taskdata - restdata;

    end

    wtcWhole(:,:,ii) = wtcData(fsMask,chMask);
end

fmap_b = nan(Nfs, Nch);
fmap_w = nan(Nfs, Nch);
fmap_inter = nan(Nfs, Nch);
pmap_b = nan(Nfs, Nch);
pmap_w = nan(Nfs, Nch);
pmap_inter = nan(Nfs, Nch);

for nfs = 1:Nfs
    for nch = 1:Nch
        % run stats
        w1 = squeeze(wtcWhole(nfs,nch,withinMask1));
        w2 = squeeze(wtcWhole(nfs,nch,withinMask2));

        % rmanova model build
        T = table;
        T.H = w1;
        T.L = w2;
        T.between = num2str(betweenMask(1:size(betweenMask,2)/2)');
        Meas = table([1 2]','VariableNames',{'context'});

        rm = fitrm(T,...
            'H-L~between','WithinDesign',Meas);

        wp = ranova(rm);
        bp = anova(rm);

        % store
        fmap_b(nfs,nch) = bp.F(2);
        fmap_w(nfs,nch) = wp.F(1);
        fmap_inter(nfs,nch) = wp.F(2);
        pmap_b(nfs,nch) = bp.pValue(2);
        pmap_w(nfs,nch) = wp.pValueGG(1);
        pmap_inter(nfs,nch) = wp.pValueGG(2);
    end
end

mkdir(savedir);
savename = fullfile(savedir,savename);
save(savename,'fmap_b','fmap_w','fmap_inter','pmap_b','pmap_w','pmap_inter');

fprintf(['\n *** Results saved ***\n']);




