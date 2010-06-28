function [] = Merit220Stats(statsdir, images, image_boldreps, conditions, regressors, job_mfile) 
	
% List of open inputs
% fMRI model specification: Directory - cfg_entry
% fMRI model specification: Scans
% fMRI model specification: Multiple Conditions File - cfg_entry
% fMRI model specification: Multiple Regressors File - cfg_entry
% fMRI model specification: Scans
% fMRI model specification: Multiple Conditions File - cfg_entry
% fMRI model specification: Multiple Regressors File - cfg_entry

spm('defaults', 'FMRI');

% statsdir = '/private/tmp/mrt00015_stats/'
% images = { 'swamrt00015_task1.nii' 'swamrt00015_task2.nii' }
% image_boldreps = {164 164}
% regressors =  { 'mrt00015_faces3_recognitionA.mat' 'mrt00015_faces3_recognitionB.mat' }
% job_mfile = '/private/tmp/mrt00015_stats/Merit220Stats_job.m'

nrun = 1; % enter the number of runs here
% jobfile = {'/private/tmp/mrt00015_proc/Merit220_Stats_job.m'};
jobfile = {job_mfile};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(5, nrun);

% Load the first conditions file to get the length of the names.
eval(['load ' conditions{1}]);

switch numel(names)
    case 2 % New, Old
        fcontrast_vector = [1 0 
                            0 1 ];
        tcontrast_1_vector = [-1 1];
        tcontrast_2_vector = [1 -1];        
    case 4 % New_correct, New_incorrect, Old_correct, Old_incorrect
        fcontrast_vector = [1 0 0 0 
                            0 1 0 0 
                            0 0 1 0 
                            0 0 0 1 ];
        tcontrast_1_vector = [-1 0  1 0];
        tcontrast_2_vector = [ 1 0 -1 0];
    case 5 % New_correct, New_incorrect, Old_correct, Old_incorrect, Misses
        fcontrast_vector = [1 0 0 0
                            0 1 0 0 
                            0 0 1 0 
                            0 0 0 1 ];
        tcontrast_1_vector = [-1 0  1 0];
        tcontrast_2_vector = [ 1 0 -1 0];
    otherwise
        error('Incorrect number of conditions detected: %d', numel(conditions));
end

for crun = 1:nrun
		inputs{1, crun} = { statsdir }; % fMRI model specification: Directory  - cfg_entry
		
		% fMRI model specification: Directory  - cfg_entry
		for index = 1:length(images)
			offset = (index - 1) .* 3;
			inputs{offset + 2, crun}  = CreateFunctionalVolumeStruct(statsdir, images{index}, image_boldreps{index}); % fMRI model specification: Scans - cfg_entry
			inputs{offset + 3, crun}  = { strcat(statsdir, conditions{index} ) };    % fMRI model specification: Multiple Conditions File - cfg_entry
			inputs{offset + 4, crun}  = { strcat(statsdir, regressors{index} ) };    % fMRI model specification: Multiple Regressors File - cfg_entry
			inputs{offset + 5, crun}  = 'Omnibus F';    % fMRI model specification: Omnibus Title - cfg_entry
            inputs{offset + 6, crun}  = fcontrast_vector;    % fMRI model specification: Omnibus Contrast - cfg_entry
			inputs{offset + 7, crun}  = 'PV > NV';   % fMRI model specification: T Contrast 1 Title - cfg_entry
			inputs{offset + 8, crun}  = tcontrast_1_vector; % fMRI model specification: T Contrast 1 Vector - cfg_entry
			inputs{offset + 9, crun}  = 'NV > PV';   % fMRI model specification: T Contrast 2 Title - cfg_entry
			inputs{offset + 10, crun} = tcontrast_2_vector; % fMRI model specification: T Contrast 2 Vector - cfg_entry
        end

end



spm_jobman('serial', jobs, '', inputs{:});
