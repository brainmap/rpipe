%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3599 $)
%-----------------------------------------------------------------------
%% Specification
matlabbatch{1}.spm.stats.fmri_spec.dir = '<UNDEFINED>';
matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
for i = 1:6
	matlabbatch{1}.spm.stats.fmri_spec.sess(i).scans = '<UNDEFINED>';
	matlabbatch{1}.spm.stats.fmri_spec.sess(i).cond = struct('name', {}, 'onset', {}, 'duration', {}, 'tmod', {}, 'pmod', {});
	matlabbatch{1}.spm.stats.fmri_spec.sess(i).multi = '<UNDEFINED>';
	matlabbatch{1}.spm.stats.fmri_spec.sess(i).regress = struct('name', {}, 'val', {});
	matlabbatch{1}.spm.stats.fmri_spec.sess(i).multi_reg = '<UNDEFINED>';
	matlabbatch{1}.spm.stats.fmri_spec.sess(i).hpf = 128;
end
matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
%% Estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
%% Contrast Creation
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
matlabbatch{3}.spm.stats.con.consess{1}.fcon.name       = '<UNDEFINED>';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.convec{1}  = '<UNDEFINED>';
matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep    = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name       = '<UNDEFINED>';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec     = '<UNDEFINED>';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep    = 'repl';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.name       = '<UNDEFINED>';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec     = '<UNDEFINED>';
matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep    = 'repl';
matlabbatch{3}.spm.stats.con.delete = 0;

% NOTE! F-contrasts expect cells containing contrast arrays, while
% T-contrasts expect the arrays themslves (hence the cell reference in
% F-contrast definition (convec{1} = [];) but not in T-contrast definition
% (convec = [];)