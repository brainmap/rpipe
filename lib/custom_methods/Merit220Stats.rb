require 'logfile'
module Merit220Stats

	DEFAULT_CONDITIONS = [:new_correct_, :new_incorrect_, :old_correct_, :old_incorrect]
  
  # runs the complete set of tasks using data in a subject's "proc" directory and a preconfigured template spm job.
	def run_first_level_stats
		flash "Highway to the dangerzone..."
		setup_directory(@statsdir, "STATS")
		
		Dir.chdir(@statsdir) do
			link_files_from_proc_directory(File.join(@procdir, "sw*.nii"), File.join(@procdir, "rp*.txt"))
			setup_onsets			
			run_stats_spm_job
		end
	end

	alias_method :perform, :run_first_level_stats
	
	def setup_onsets
	  setup_conditions
    create_or_link_onsets_files
  end
  
  def setup_conditions
    @conditions = @conditions ? @conditions.collect! {|c| c.to_sym} : DEFAULT_CONDITIONS 
  end
  
  def create_or_link_onsets_files
    if @onsetsfiles.nil?
		  if @logresponsefiles
		    puts @logresponsefiles
		    puts @onsetsfiles = create_onsets_files(@logresponsefiles, conditions)
	    else
	      raise ScriptError, "Multiple conditions cannot be calculated because both log response files and onsets mat files haven't been defined."
      end
    else
	    link_onsets_files
		end
  end
	  
	def create_onsets_files(log_response_files, conditions)
	  onsets_mat_files = []
	  log_response_files.each do |logfile|
	    # Either Strip off the prefix directly without changing the name...
      #   prefix = File.basename(logfile, '.txt')
      # Or create a new name based on standard logfile naming scheme:
      # mrt00015_xxx_021110_faces3_recognitionA.txt
      prefix = File.basename(logfile, '.txt').split("_").values_at(0,3,4).join("_")
      puts prefix
	    log = Logfile.new(logfile, *conditions)
	    puts log.to_csv
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
      File.join(@root_dir, 'custom_methods'), 
      File.join(@root_dir, 'matlab_helpers')    ]

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