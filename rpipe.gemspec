# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rpipe}
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kristopher Kosmatka", "Erik Kastman"]
  s.date = %q{2010-10-29}
  s.description = %q{Neuroimaging preprocessing the Ruby way}
  s.email = %q{kjkosmatka@gmail.com}
  s.executables = ["swallow_batch_run.rb", "create_driver.rb", "rpipe"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "bin/create_driver.rb",
     "bin/rpipe",
     "bin/swallow_batch_run.rb",
     "lib/core_additions.rb",
     "lib/custom_methods/JohnsonMerit220Visit1Preproc.m",
     "lib/custom_methods/JohnsonMerit220Visit1Preproc.rb",
     "lib/custom_methods/JohnsonMerit220Visit1Preproc_job.m",
     "lib/custom_methods/JohnsonMerit220Visit1Stats.m",
     "lib/custom_methods/JohnsonMerit220Visit1Stats.rb",
     "lib/custom_methods/JohnsonMerit220Visit1Stats_job.m",
     "lib/custom_methods/JohnsonTbiLongitudinalSnodPreproc.m",
     "lib/custom_methods/JohnsonTbiLongitudinalSnodPreproc.rb",
     "lib/custom_methods/JohnsonTbiLongitudinalSnodPreproc_job.m",
     "lib/custom_methods/JohnsonTbiLongitudinalSnodStats.m",
     "lib/custom_methods/JohnsonTbiLongitudinalSnodStats.rb",
     "lib/custom_methods/JohnsonTbiLongitudinalSnodStats_job.m",
     "lib/custom_methods/ReconWithHello.rb",
     "lib/default_logger.rb",
     "lib/default_methods/default_preproc.rb",
     "lib/default_methods/default_recon.rb",
     "lib/default_methods/default_stats.rb",
     "lib/default_methods/recon/physionoise_helper.rb",
     "lib/default_methods/recon/raw_sequence.rb",
     "lib/generators/job_generator.rb",
     "lib/generators/preproc_job_generator.rb",
     "lib/generators/recon_job_generator.rb",
     "lib/generators/stats_job_generator.rb",
     "lib/generators/workflow_generator.rb",
     "lib/global_additions.rb",
     "lib/logfile.rb",
     "lib/matlab_helpers/CreateFunctionalVolumeStruct.m",
     "lib/matlab_helpers/import_csv.m",
     "lib/matlab_helpers/matlab_queue.rb",
     "lib/matlab_helpers/prepare_onsets.m",
     "lib/rpipe.rb",
     "rpipe.gemspec",
     "spec/generators/preproc_job_generator_spec.rb",
     "spec/generators/recon_job_generator_spec.rb",
     "spec/generators/stats_job_generator_spec.rb",
     "spec/generators/workflow_generator_spec.rb",
     "spec/helper_spec.rb",
     "spec/integration/johnson.merit220.visit1_spec.rb",
     "spec/integration/johnson.tbi.longitudinal.snod_spec.rb",
     "spec/logfile_spec.rb",
     "spec/matlab_queue_spec.rb",
     "spec/merit220_stats_spec.rb",
     "spec/physio_spec.rb",
     "test/drivers/merit220_workflow_sample.yml",
     "test/drivers/mrt00000.yml",
     "test/drivers/mrt00015.yml",
     "test/drivers/mrt00015_hello.yml",
     "test/drivers/mrt00015_withphys.yml",
     "test/drivers/tbi000.yml",
     "test/drivers/tbi000_separatevisits.yml",
     "test/drivers/tmp.yml",
     "test/fixtures/faces3_recognitionA.mat",
     "test/fixtures/faces3_recognitionA.txt",
     "test/fixtures/faces3_recognitionA_equal.csv",
     "test/fixtures/faces3_recognitionA_unequal.csv",
     "test/fixtures/faces3_recognitionB_incmisses.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_CPd3R_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_CPd3_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_CPttl_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_CRTd3R_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_CRTd3_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_CRTttl_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_HalfTR_CRTd3R_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_HalfTR_CRTd3_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_HalfTR_CRTttl_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_HalfTR_RRT_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_HalfTR_RVT_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_HalfTR_card_spline_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_HalfTR_resp_spline_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_RRT_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_RVT_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_TR_CRTd3R_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_TR_CRTd3_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_TR_CRTttl_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_TR_RRT_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_TR_RVT_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_TR_card_spline_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_TR_resp_spline_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_card_spline_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_resp_spline_40.txt",
     "test/fixtures/physionoise_regressors/EPI__fMRI_Task1_resp_spline_downsampled_40.txt",
     "test/fixtures/ruport_summary.yml",
     "test/fixtures/valid_scans.yaml",
     "test/helper.rb",
     "test/test_dynamic_method_inclusion.rb",
     "test/test_includes.rb",
     "test/test_integrative_johnson.merit220.visit1.rb",
     "test/test_preproc.rb",
     "test/test_recon.rb",
     "test/test_rpipe.rb",
     "vendor/output_catcher.rb",
     "vendor/trollop.rb"
  ]
  s.homepage = %q{http://github.com/brainmap/rpipe}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.6}
  s.summary = %q{Neuroimaging preprocessing the Ruby way}
  s.test_files = [
    "spec/generators/preproc_job_generator_spec.rb",
     "spec/generators/stats_job_generator_spec.rb",
     "spec/generators/recon_job_generator_spec.rb",
     "spec/generators/workflow_generator_spec.rb",
     "spec/matlab_queue_spec.rb",
     "spec/logfile_spec.rb",
     "spec/physio_spec.rb",
     "spec/integration/johnson.merit220.visit1_spec.rb",
     "spec/integration/johnson.tbi.longitudinal.snod_spec.rb",
     "spec/merit220_stats_spec.rb",
     "spec/helper_spec.rb",
     "test/helper.rb",
     "test/test_dynamic_method_inclusion.rb",
     "test/test_includes.rb",
     "test/test_integrative_johnson.merit220.visit1.rb",
     "test/test_preproc.rb",
     "test/test_recon.rb",
     "test/test_rpipe.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_runtime_dependency(%q<metamri>, [">= 0"])
      s.add_runtime_dependency(%q<log4r>, [">= 0"])
      s.add_runtime_dependency(%q<POpen4>, [">= 0"])
      s.add_runtime_dependency(%q<ruport>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<metamri>, [">= 0"])
      s.add_dependency(%q<log4r>, [">= 0"])
      s.add_dependency(%q<POpen4>, [">= 0"])
      s.add_dependency(%q<ruport>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<metamri>, [">= 0"])
    s.add_dependency(%q<log4r>, [">= 0"])
    s.add_dependency(%q<POpen4>, [">= 0"])
    s.add_dependency(%q<ruport>, [">= 0"])
  end
end

