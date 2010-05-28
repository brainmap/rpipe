function [] = prepare_onsets_xls(csvfile, matfileprefix, conditions)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

import_csv(csvfile);

for i = 1:length(conditions)
	condition = conditions{i};
	condition_onsets = eval(condition);
		
	% Strip NaN's, but leave one nan if vector is empty (SPM's preference).
	condition_onsets = condition_onsets(find(~isnan(condition_onsets)));
	if length(condition_onsets) == 0;
		condition_onsets=[nan];
	end
	
	% Format cell array for SPM's multiple conditions
	names{i} = condition;
	onsets{i} = condition_onsets;
	durations{i} = [0];
end

save([matfileprefix,'.mat'],'names','onsets', 'durations');
