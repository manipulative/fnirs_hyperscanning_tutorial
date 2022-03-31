function RP_files = randPair(datafiles)
% A function used to generate random-pair combinations
%
% INPUTS:
%     datafiles: a list of .mat datafiles to run wtc over. The list should
%                contain three column as follow:
%                |dyad_ID|sub1_ID|sub2_ID|
%                Each row indicates one dyad. The dyad_ID indicates the ID
%                indicates of each dyad. And the sub1_ID and sub2_ID
%                indicates .mat file name of subjects within each dyad.
%                Each .mat file should contain at least a [time x channel]
%                matrix correspond to datatype in bash_params
%
% OUTPUTS:
%     RP_files: a three column list of all random paired combinations. The
%               first column indicates RP name (e.g. control-01control-02)
%               and the rest columns indicates source datafiles name.
%
% Siyuan Zhou, Lulab, BNU, 2022/03

        Nfile = 1:size(datafiles,1);

RP_mat1 = nchoosek(Nfile,2); RP_mat2 = [RP_mat1(:,2) RP_mat1(:,1)];
RP_mat = [RP_mat1; RP_mat2];

name1 = datafiles(RP_mat(:,1),1); name2 = datafiles(RP_mat(:,2),1);
name_list = append(name1, '_', name2);

file1 = datafiles(RP_mat(:,1),2);file2 = datafiles(RP_mat(:,2),3);
file_list = [file1 file2];

RP_files = [name_list file_list];

end

    
    



