function [] = JohnsonTbiLongitudinalSnodPreproc(studypath, images, image_boldreps, job_mfile)
% [] =  Calls and runs TBI Longitudinal preproc job.
% merit_preproc('/private/tmp/mrt00015_orig/', ...
% {'amrt00015_task1.nii' 'amrt00015_task2.nii' 'amrt00015_rest.nii'}, ...
% {164 164 164}, ...
% '/private/tmp/mrt00015_orig/mrt00015_preproc_job.m') 
% 

spm('defaults', 'FMRI');

% List of open inputs
% Realign: Estimate: Session - cfg_files
% Realign: Estimate: Session - cfg_files
% Realign: Estimate: Session - cfg_files
nrun = 1; % enter the number of runs here
jobfile = {job_mfile};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(3, nrun);

for crun = 1:nrun
    for index = 1:length(images)
			inputs{index, crun} = CreateFunctionalVolumeStruct(studypath, images{index}, image_boldreps{index}); % Realign: Estimate: Session - cfg_files
    end
end

spm_jobman('serial', jobs, '', inputs{:});
