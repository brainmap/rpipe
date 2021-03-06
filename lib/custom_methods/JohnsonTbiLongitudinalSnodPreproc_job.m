%-----------------------------------------------------------------------------
% Unfortunately, there is no easy way to pass in the number of images to this
% template job, short of writing a function to build one on the fly. Number of
% sessions is hardcoded.
nsessions = 6;
%-----------------------------------------------------------------------------

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3599 $)
%-----------------------------------------------------------------------
for i = 1:nsessions
	matlabbatch{1}.spm.spatial.realign.estimate.data{i} = '<UNDEFINED>';
end
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.quality = 0.9;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.sep = 4;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.fwhm = 5;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.rtm = 1;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.interp = 2;
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.realign.estimate.eoptions.weight = {''};
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1) = cfg_dep;
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1).tname = 'Source Image';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1).sname = 'Realign: Estimate: Realigned Images (Sess 1)';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.source(1).src_output = substruct('.','sess', '()',{1}, '.','cfiles');
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.wtsrc = '';
for i = 1:nsessions
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i) = cfg_dep;
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i).tname = 'Images to Write';
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i).tgt_spec{1}(1).name = 'filter';
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i).tgt_spec{1}(1).value = 'image';
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i).tgt_spec{1}(2).name = 'strtype';
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i).tgt_spec{1}(2).value = 'e';
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i).sname = ['Realign: Estimate: Realigned Images (Sess' i ')'];
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
	matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(i).src_output = substruct('.','sess', '()',{i}, '.','cfiles');
end
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.template = {[spm('Dir') '/templates/EPI.nii,1']};
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.weight = '';
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.smosrc = 8;
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.smoref = 0;
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.regtype = 'mni';
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.cutoff = 25;
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.nits = 16;
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.reg = 1;
matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.preserve = 0;
matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.bb = [-78 -112 -50
                                                             78 76 85];
matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.vox = [2 2 2];
matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.interp = 1;
matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.normalise.estwrite.roptions.prefix = 'w';
matlabbatch{3}.spm.spatial.smooth.data(1) = cfg_dep;
matlabbatch{3}.spm.spatial.smooth.data(1).tname = 'Images to Smooth';
matlabbatch{3}.spm.spatial.smooth.data(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{3}.spm.spatial.smooth.data(1).tgt_spec{1}(1).value = 'image';
matlabbatch{3}.spm.spatial.smooth.data(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{3}.spm.spatial.smooth.data(1).tgt_spec{1}(2).value = 'e';
matlabbatch{3}.spm.spatial.smooth.data(1).sname = 'Normalise: Estimate & Write: Normalised Images (Subj 1)';
matlabbatch{3}.spm.spatial.smooth.data(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{3}.spm.spatial.smooth.data(1).src_output = substruct('()',{1}, '.','files');
matlabbatch{3}.spm.spatial.smooth.fwhm = [8 8 8];
matlabbatch{3}.spm.spatial.smooth.dtype = 0;
matlabbatch{3}.spm.spatial.smooth.im = 0;
matlabbatch{3}.spm.spatial.smooth.prefix = 's';
