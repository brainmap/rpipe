%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3599 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.realign.estimate.data = {
                                                    '<UNDEFINED>'
                                                    '<UNDEFINED>'
                                                    '<UNDEFINED>'
                                                    '<UNDEFINED>'
                                                    '<UNDEFINED>'
                                                    '<UNDEFINED>'
                                                    }';
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
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1) = cfg_dep;
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1).tname = 'Images to Write';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1).sname = 'Realign: Estimate: Realigned Images (Sess 1)';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(1).src_output = substruct('.','sess', '()',{1}, '.','cfiles');
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2) = cfg_dep;
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2).tname = 'Images to Write';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2).sname = 'Realign: Estimate: Realigned Images (Sess 2)';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(2).src_output = substruct('.','sess', '()',{2}, '.','cfiles');
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3) = cfg_dep;
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3).tname = 'Images to Write';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3).sname = 'Realign: Estimate: Realigned Images (Sess 3)';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(3).src_output = substruct('.','sess', '()',{3}, '.','cfiles');
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4) = cfg_dep;
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4).tname = 'Images to Write';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4).sname = 'Realign: Estimate: Realigned Images (Sess 4)';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(4).src_output = substruct('.','sess', '()',{4}, '.','cfiles');
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5) = cfg_dep;
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5).tname = 'Images to Write';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5).sname = 'Realign: Estimate: Realigned Images (Sess 5)';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(5).src_output = substruct('.','sess', '()',{5}, '.','cfiles');
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6) = cfg_dep;
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6).tname = 'Images to Write';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6).tgt_spec{1}(1).name = 'filter';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6).tgt_spec{1}(1).value = 'image';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6).tgt_spec{1}(2).name = 'strtype';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6).tgt_spec{1}(2).value = 'e';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6).sname = 'Realign: Estimate: Realigned Images (Sess 6)';
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.normalise.estwrite.subj.resample(6).src_output = substruct('.','sess', '()',{6}, '.','cfiles');
matlabbatch{2}.spm.spatial.normalise.estwrite.eoptions.template = {'/apps/spm/spm8_current/templates/EPI.nii,1'};
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
