module DefaultRecon	
	# Create Physionoise Regressors for Inclusion in GLM
	def create_physiosnoise_regressors(scan_spec)
    runs = build_physionoise_run_spec(scan_spec)
    Physionoise.run_physionoise_on(runs, ["--saveFiles"])
  end
  
  # Generate a Physionoise Spec
  def generate_physiospec
	  physiospec = Physiospec.new(@rawdir, File.join(@rawdir, '..', 'cardiac'))
	  physiospec.epis_and_associated_phys_files
  end
  
  # Build a Run Spec from a Scan Spec
  # This should be moved to the generators and shouldn't be used here.
  def build_physionoise_run_spec(rpipe_scan_spec)
    run = rpipe_scan_spec['physio_files'].dup
    flash "Physionoise Regressors: #{run[:phys_directory]}"
    run[:bold_reps] = rpipe_scan_spec['bold_reps']
    run[:rep_time] = rpipe_scan_spec['rep_time']
    unless Pathname.new(run[:phys_directory]).absolute?
      run[:phys_directory] = File.join(@rawdir, run[:phys_directory])
    end
    run[:run_directory] = @rawdir
    runs = [run]
  end
	
	# Runs 3dRetroicor for a scan.
	# Returns the output filename if successful or raises an error if there was an error.
	def run_retroicor(physio_files, file)
	  icor_cmd, outfile = build_retroicor_cmd(physio_files, file)
	  flash "3dRetroicor: #{file} \n #{icor_cmd}"
	  if run(icor_cmd)
	    return outfile
    else
      raise ScriptError, "Problem running #{icor_cmd}"
    end
  end
	
	# Builds a properly formed 3dRetroicor command and returns the command and 
	# output filename.
	#
	# Input a physio_files hash with keys:
	#   :respiration_signal: RESPData_epiRT_0303201014_46_27_463
  #   :respiration_trigger: RESPTrig_epiRT_0303201014_46_27_463
  #   :phys_directory: cardiac/
  #   :cardiac_signal: PPGData_epiRT_0303201014_46_27_463
  #   :cardiac_trigger: PPGTrig_epiRT_0303201014_46_27_463
	def build_retroicor_cmd(physio_files, file)
    [:cardiac_signal, :respiration_signal].collect {|req| raise ScriptError, "Missing physio config: #{req}" unless physio_files.include?(req)}
    
    prefix = 'p'
    unless Pathname.new(physio_files[:cardiac_signal]).absolute?
      cardiac_signal = File.join(@rawdir, physio_files[:phys_directory], physio_files[:cardiac_signal])
    end
    
    unless Pathname.new(physio_files[:respiration_signal]).absolute?
      respiration_signal = File.join(@rawdir, physio_files[:phys_directory], physio_files[:respiration_signal])
    end
    
    outfile = prefix + file

    icor_format = "3dretroicor -prefix %s -card %s -resp %s %s"
    icor_options = [outfile, cardiac_signal, respiration_signal, file]
    icor_cmd = icor_format % icor_options
    return icor_cmd, outfile
  end
  
end