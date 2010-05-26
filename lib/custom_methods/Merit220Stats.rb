module Merit220Stats

  # runs the complete set of tasks using data in a subject's "proc" directory and a preconfigured template spm job.
	def run_first_level_stats
		flash "Highway to the dangerzone..."
		setup_directory(@statsdir, "STATS")
		
		Dir.chdir(@statsdir) do
			link_files_from_proc_directory(File.join(@procdir, "sw*.nii"), File.join(@procdir, "rp*.txt"))
			link_onsets_files
			run_stats_spm_job
		end
	end

	alias_method :perform, :run_first_level_stats

  # Finally runs the stats job 
  def run_stats_spm_job
    run_matlab_queue(stats_queue)
  end
  
  def stats_queue
    images = Dir.glob(File.join(@statsdir, "sw*#{@subid}*task*.nii"))
    queue = []
    queue << add_matlab_paths(
      '/Applications/spm/spm8/spm8_current', 
      File.expand_path(File.dirname(__FILE__)), 
      File.expand_path(File.join(File.dirname(__FILE__), '..', 'matlab_helpers'))
    )
    queue << "Merit220Stats('#{@statsdir}/', \
    { #{images.collect {|im| "'#{File.basename(im)}'"}.join(' ')} },  \
    { #{@bold_reps.join(' ') } }, \
    { #{@onsetsfiles.collect { |file| "'#{File.basename(file)}'"}.join(' ') } }, \
    { #{@regressorsfiles.collect { |file| "'#{File.basename(file)}'"}.join(' ') } }, \
    '/private/tmp/mrt00015_stats/Merit220Stats_job.m')"
  end
  
end