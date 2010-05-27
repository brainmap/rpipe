function [] = prepare_onsets_xls(csvfile, matfileprefix, conditions)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

import_csv(csvfile);

for i = 1:length(conditions)
	condition = conditions{i};
	
	names{i}=condition;
	onsets{i} = eval(condition);
	durations{i}=[0];
end

save([matfileprefix,'.mat'],'names','onsets', 'durations');
