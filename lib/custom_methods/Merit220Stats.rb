require 'logfile'
module Merit220Stats

	DEFAULT_CONDITIONS = [:new_correct_, :new_incorrect_, :old_correct_, :old_incorrect]
  
  # runs the complete set of tasks using data in a subject's "proc" directory and a preconfigured template spm job.
	def run_first_level_stats
		flash "Highway to the dangerzone..."
		setup_directory(@statsdir, "STATS")
		
		@conditions = DEFAULT_CONDITIONS if @conditions.nil?
		
		Dir.chdir(@statsdir) do
			link_files_from_proc_directory(File.join(@procdir, "sw*.nii"), File.join(@procdir, "rp*.txt"))
			if @onsetsfiles.nil? && !@logresponsefiles.nil?
			  @onsetsfiles = create_onsets_files(@logresponsefiles, conditions)
		  else
			  raise ScriptError, "Multiple conditions cannot be calculated because both log response files and onsets mat files haven't been defined."
			end 
			link_onsets_files
			run_stats_spm_job
		end
	end

	alias_method :perform, :run_first_level_stats
	
	def create_onsets_files(log_response_files, conditions)
	  onsets_mat_files = []
	  log_response_files.each do |logfile|
	    prefix = File.basename(logfile, '.txt')
	    log = Logfile.new(logfile, *conditions)
	    log.write_csv(prefix + '.csv')
	    onsets_mat_files << log.write_mat(prefix)
    end
    
    return onsets_mat_files
  end

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