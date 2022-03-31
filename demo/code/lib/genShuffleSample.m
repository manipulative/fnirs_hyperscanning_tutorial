function [sumDist meanDist] = genShuffleSample(datafiles)
% INPUTS:
%     datafiles: a series shuffled t-test result datafiles location
%
% OUTPUTS: 
%     sumDist: a vector of largest sum stats value of each files
%     meanDist: a vector of largest mean stats value of each files
%
% Dependency: bandSelectStats
% By Siyuan Zhou,2022/3


N_RP = size(datafiles,1);
sumDist = nan(N_RP,1);
meanDist = nan(N_RP,1);

for ii = 1:N_RP
    load(datafiles{ii})
    T = bandSelectStats(pmap,tmap,0.05,0.05);
    
    T = sortrows(T,'meanStatsValue','descend');
    largest_mean_stats = T.meanStatsValue(1);
    T = sortrows(T,'sumStatsValue','descend');
    largest_sum_stats = T.sumStatsValue(1);
    
    sumDist(ii) = largest_sum_stats;
    meanDist(ii) = largest_mean_stats;
end
