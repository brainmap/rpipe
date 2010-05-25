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
for crun = 1:nrun
		inputs{1, crun} = { statsdir }; % fMRI model specification: Directory  - cfg_entry
		
		% fMRI model specification: Directory  - cfg_entry
		for index = 1:length(images)
			offset = (index - 1) .* 3;
			inputs{offset + 2, crun} = CreateFunctionalVolumeStruct(statsdir, images{index}, image_boldreps{index}); % fMRI model specification: Scans - cfg_entry
			inputs{offset + 3, crun} = { strcat(statsdir, conditions{index} ) };    % fMRI model specification: Multiple Conditions File - cfg_entry
			inputs{offset + 4, crun} = { strcat(statsdir, regressors{index} ) };    % fMRI model specification: Multiple Regressors File - cfg_entry
        end

end



spm_jobman('serial', jobs, '', inputs{:});
