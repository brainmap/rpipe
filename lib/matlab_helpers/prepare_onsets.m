function [] = prepare_onsets(csvfile, matfileprefix, conditions)
%IMPORTFILE(FILETOREAD1)
%  Imports data from the specified file
%  FILETOREAD1:  file to read

try
	import_csv(csvfile);
catch exception
	% Since this is running in a script, catch errors and force Matlab to exit
	% instead of hanging.  (Not exactly elegant, but it works.)
	['Error Importing CSV' exception.identifier]
	exit
end

for i = 1:length(conditions)
	condition = conditions{i};
	condition_onsets = eval(condition);
		
	% Strip NaN's, but leave one nan if vector is empty (SPM's preference).
	condition_onsets = condition_onsets(find(~isnan(condition_onsets)));
	
    % Allow for conditions called 'misses' to be dropped from onsets.
    if length(condition_onsets) == 0;
		if ~strcmp(condition, 'misses')
            condition_onsets=[nan];
        else
            continue
        end
	end
	
	% Format cell array for SPM's multiple conditions
	names{i} = condition;
	onsets{i} = condition_onsets;
	durations{i} = [0];
end

save([matfileprefix,'.mat'],'names','onsets', 'durations');
