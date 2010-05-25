module DefaultPreproc
	
	# Runs the preprocessing job, including spm job customization, run spm job, and handling motion issues.
	# This function assumes a destination directory is set up; it will overwrite preexisting data.	Careful!
	def preproc_visit
		flash "Spatial Preprocessing Subject: #{@subid}"
		
		setup_directory(@procdir, "PREPROC")
		
		Dir.chdir(@procdir) do
			link_files_into_proc
			customize_templates
			run_spm_jobs
			deal_with_motion
		end
	end
	
	alias_method :perform, :preproc_visit
	
	# Links all the slice timing corrected data from the source "orig" directory using a wildcard a${subid}*.nii,
	# where subid is the subject id specified in the preproc_spec hash.
	def link_files_into_proc
		flash "Linking files from #{@origdir} into #{@procdir}"
		wildcard = File.join(@origdir,"a#{@subid}*.nii")
		system("ln -s #{wildcard} #{@procdir}")
	end
	
	# Customizes the template job in preproc_spec to be specific for this particular preproc job.
	# Performs to recursive string replacements inside the spm job:
	# - path inside template is replaced with destination "proc" directory
	# - subid inside template is replaced with the current subid
	def customize_templates
		flash "Customizing template SPM job: #{@tspec['job']}"
		replacecmd = "spmjobStringReplace.sh"
		
		templatejob = File.join(@spmdir, @tspec['job'])
		thisjob = @subid + '_preproc.mat'
		
		File.copy(templatejob, thisjob)
		system("#{replacecmd} #{thisjob} #{@tspec['path']} #{@procdir} #{thisjob}")
		system("#{replacecmd} #{thisjob} #{@tspec['subid']} #{@subid} #{thisjob}")
	end
	
	# Runs the customized spm job using the shell script runSpmJob.sh.	Make sure this is available at your site.
	def run_spm_jobs
		thisjob = "#{@subid}_preproc.mat"
		flash "Running spatial preprocessing SPM job: #{thisjob}"
		system("runSpmJob.sh #{thisjob}")
	end
	
	# Calculates the realignment motion derivatives and checks that displacement in all directions was less than
	# the MOTION_THRESHOLD.	 Operates on all file in the current working directory that match rp_a*txt (SPM convention).
	# Uses two shell scripts that must both be available on the local machine:
	# - calc_derivs.sh
	# - fmri_motion_check.sh
	def deal_with_motion
		flash "Calculating motion derivatives and checking for excessive motion"
		Dir.glob("rp_a*txt").each do |rp|
			system("calc_derivs.sh #{rp}")
			system("fmri_motion_check.sh #{rp} #{@motion_threshold}")
		end
	end
	
end