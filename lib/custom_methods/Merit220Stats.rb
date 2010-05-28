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
    images = Dir.glob(File.join(@statsdir, "sw*#{@subid}*task*.nii"))
    raise ScriptError, "Can't find any smoothed, warped images in #{@statsdir}" if images.empty?
    
    queue = MatlabQueue.new
	  queue.paths << ['/Applications/spm/spm8/spm8_current', 
      File.expand_path(File.dirname(__FILE__)), 
      File.expand_path(File.join(File.dirname(__FILE__), '..', 'matlab_helpers'))
    ]

	  queue << "Merit220Stats('#{@statsdir}/', \
    { #{images.collect {|im| "'#{File.basename(im)}'"}.join(' ')} },  \
    { #{@bold_reps.join(' ') } }, \
    { #{@onsetsfiles.collect { |file| "'#{File.basename(file)}'"}.join(' ') } }, \
    { #{@regressorsfiles.collect { |file| "'#{File.basename(file)}'"}.join(' ') } }, \
    'Merit220Stats_job.m')"
    
    # puts queue.to_s
    queue.run!
  end
  
end