$LOAD_PATH.unshift File.join(File.dirname(__FILE__), '..', '..', '..',  'physionoise/lib')

require 'metamri/core_additions'
require 'physionoise'

require 'pathname'

module DefaultRecon
	
	# Reconstructs, strips, and slice timing corrects all scans specified in the recon_spec.
	# This function assumes a destination directory is set up in the filesystem and begins writing
	# to it with no further checking.	 It will overwrite data if it already exists, be careful.
	def recon_visit
		
		setup_directory(@origdir, "RECON")
		
		Dir.chdir(@origdir) do		  
			@scans.each_with_index do |scan_spec, i|
				outfile = "%s_%s.nii" % [@subid, scan_spec['label']]
				
				reconstruct_scan(scan_spec, outfile)
				
				if scan_spec['type'] == "func"
					if scan_spec['physio_files']
            # create_physiosnoise_regressors(scan_spec)
            outfile = run_retroicor(scan_spec['physio_files'], outfile)
				  end
				  
					slice_time_correct(outfile)
				else
					File.copy('tmp.nii', outfile)
				end
				
				File.delete('tmp.nii') if File.exist? 'tmp.nii'
			end
		end
	end
	
	alias_method :perform, :recon_visit
	
	# Reconstructs a scan from dicoms to nifti, anatomical or functional.	 Uses a scan_spec hash to drive.
	# Writes the result in current working directory. Raises an error if to3d system call fails.
	# Conventions: I****.dcm filenaming, I0002.dcm is second file in series, 
	def reconstruct_scan(scan_spec, outfile)	
		if scan_spec['dir']
		  reconstruct_dicom_sequence(scan_spec, 'tmp.nii')
			strip_leading_volumes('tmp.nii', outfile, @volume_skip, scan_spec['bold_reps'])
	  elsif scan_spec['pfile']
	    reconstruct_pfile_sequence(scan_spec, outfile)
    else raise ConfigError, "Scan must list either a pfile or a dicom directory."
    end
	end
	
	# Determines the proper timing options to pass to to3d for functional scans.	Must pass a static path to
	# the second file in the series to determine zt vs tz ordering.	 Assumes 2sec TR's.	 Returns the options
	# as a string that may be empty if the scan is an anatomical.
	def timing_options(scan_spec, second_file)
		return "" if scan_spec['type'] == "anat"
		instance_offset = scan_spec['z_slices'] + 1
		if system("dicom_hdr #{second_file} | grep .*REL.Instance.*#{instance_offset}")
			return "-epan -time:tz #{scan_spec['bold_reps']} #{scan_spec['z_slices']} 2000 alt+z"
		else
			return "-epan -time:zt #{scan_spec['z_slices']} #{scan_spec['bold_reps']} 2000 alt+z"
		end
	end
	
	# Removes the specified number of volumes from the beginning of a 4D functional nifti file.
	# In most cases this will be 3 volumes. Writes result in current working directory.
	def strip_leading_volumes(infile, outfile, volume_skip, bold_reps)
		flash "Stripping #{volume_skip.to_s} leading volumes: #{infile}"
		puts cmd = "fslroi #{infile} #{outfile} #{volume_skip.to_s} #{bold_reps.to_s}"
		unless system(cmd)
		  raise ScriptError, "Failed to strip volumes: #{cmd}"
	  end
	end
	
	# Uses to3d to slice time correct a 4D functional nifti file.	 Writes result in the current working directory.
	def slice_time_correct(infile)
		flash "Slice Timing Correction: #{infile}"
		cmd = "3dTshift -tzero 0 -tpattern alt+z -prefix a#{infile} #{infile}"
		unless system(cmd)
		  raise ScriptError, "Failed to slice time correct: #{cmd}"
	  end
	end
	
	def generate_physiospec
	  physiospec = Physiospec.new(@rawdir, File.join(@rawdir, '..', 'cardiac'))
	  physiospec.epis_and_associated_phys_files
  end
	
	def create_physiosnoise_regressors(scan_spec)
    runs = build_physionoise_run_spec(scan_spec)
    Physionoise.run_physionoise_on(runs, ["--saveFiles"])
  end
  
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
	  if system(icor_cmd)
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
  
  private
  
  def reconstruct_dicom_sequence(scan_spec, outfile)
    scandir = File.join(@rawdir, scan_spec['dir'])
		flash "Dicom Reconstruction: #{scandir}"
		Pathname.new(scandir).all_dicoms do |dicoms|
		
  		# second_file = File.join(scandir, 'I0002.dcm')
  		# wildcard = File.join(scandir,'I*dcm')
  		
  		local_scandir = File.dirname(dicoms.first)
		
  		second_file = Dir.glob( File.join(local_scandir, "*0002*") )
  		wildcard = File.join(local_scandir, "*.[0-9]*")
		
  		recon_cmd_format = 'to3d -skip_outliers %s -prefix tmp.nii "%s"'

  		timing_opts = timing_options(scan_spec, second_file)
		
  		unless system(recon_cmd_format % [timing_opts, wildcard])
  			raise(IOError,"Failed to reconstruct scan: #{scandir}")
  		end
		end
  end
  
  def reconstruct_pfile_sequence(scan_spec, outfile)
    puts outfile
    base_pfile_path = File.join(@rawdir, scan_spec['pfile'])
    pfile_path = File.exist?(base_pfile_path) ? base_pfile_path : base_pfile_path + '.bz2'
    
    raise IOError, "#{pfile_path} does not exist." unless File.exist?(pfile_path)
      
		flash "Pfile Reconstruction: #{pfile_path}"
		Pathname.new(pfile_path).local_copy do |pfile|
		  reconstruct_pfile(pfile, outfile, scan_spec['volumes_to_skip'])
	  end    
  end
  
  # Reconstructs a single pfile into the epirecon default brik/head when
  # given a temporary working directory, path to the pfile and the task to
  # use when naming the output.
  def reconstruct_pfile(pfile, label, volumes_to_skip = 3, refdat_stem = 'ref.dat')
		setup_refdat(refdat_stem)
    epirecon_cmd_format = "epirecon_ex -f %s -NAME %s -skip %d -scltype=0"
		epirecon_cmd = epirecon_cmd_format % [pfile, label, volumes_to_skip]
		puts epirecon_cmd
		puts output = `#{epirecon_cmd}`
		puts Dir.pwd
		puts Dir.glob('*')
  end
  
  def setup_refdat(refdat_stem)
    base_refdat_path = File.join(@rawdir, refdat_stem)
    refdat_path = File.exist?(base_refdat_path) ? base_refdat_path : base_refdat_path + ".bz2"
    raise IOError, "#{refdat_path} does not exist." unless File.exist?(refdat_path)
    local_refdat_file = Pathname.new(refdat_path).local_copy
    FileUtils.ln_s(local_refdat_file, Dir.pwd, :force => true)
  end

	
end