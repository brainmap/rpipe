function [] = prepare_onsets_xls(filename)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

import_csv(filename)

names{1}='new';
onsets{1}=new;
durations{1}=[0];

names{2}='old';
onsets{2}=old
durations{2}=[0];

save([filename,'.mat'],'names','onsets', 'durations');
