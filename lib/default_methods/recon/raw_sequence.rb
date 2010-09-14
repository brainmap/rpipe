module DefaultRecon
  # An abstract class for Raw Image Sequences
  # The Recon job will calls prepare on Raw Sequence Instances to process 
  # them from their raw state (dicoms or pfiles) to Nifti files suitable for
  # processing.
  class RawSequence
    def initialize(scan_spec, rawdir)
      @scan_spec = scan_spec
      @rawdir = rawdir
    end
  end

  # Manage a folder of Raw Dicoms for Nifti file conversion
  class DicomRawSequence < RawSequence
    # Locally copy and unzip a folder of Raw Dicoms and call convert_sequence on them
    def prepare_and_convert_sequence(outfile)
      scandir = File.join(@rawdir, @scan_spec['dir'])
      $Log.info "Dicom Reconstruction: #{scandir}"
      Pathname.new(scandir).all_dicoms do |dicoms|
        convert_sequence(dicoms, outfile)
      end
    end
      
    alias_method :prepare, :prepare_and_convert_sequence
  
    private
  
    # Convert a folder of unzipped Dicom files to outfile
    def convert_sequence(dicoms, outfile)
      local_scandir = File.dirname(dicoms.first)
      second_file = Dir.glob( File.join(local_scandir, "*0002*") )
      wildcard = File.join(local_scandir, "*.[0-9]*")
    
      recon_cmd_format = 'to3d -skip_outliers %s -prefix tmp.nii "%s"'

      timing_opts = timing_options(@scan_spec, second_file)

      unless run(recon_cmd_format % [timing_opts, wildcard])
        raise(IOError,"Failed to reconstruct scan: #{scandir}")
      end
    end
  
    # Determines the proper timing options to pass to to3d for functional scans.
    # Must pass a static path to the second file in the series to determine zt
    # versus tz ordering. Assumes 2sec TR's. Returns the options as a string 
    # that may be empty if the scan is an anatomical.
    def timing_options(scan_spec, second_file)
      return "" if scan_spec['type'] == "anat"
      instance_offset = scan_spec['z_slices'] + 1
      if system("dicom_hdr #{second_file} | grep .*REL.Instance.*#{instance_offset}")
        return "-epan -time:tz #{scan_spec['bold_reps']} #{scan_spec['z_slices']} 2000 alt+z"
      else
        return "-epan -time:zt #{scan_spec['z_slices']} #{scan_spec['bold_reps']} 2000 alt+z"
      end
    end
  end
  
  # Reconstucts a PFile from Raw to Nifti File
  class PfileRawSequence < RawSequence
    # Create a local unzipped copy of the Pfile and prepare Scanner Reference Data for reconstruction
    def initialize(scan_spec, rawdir)
      super(scan_spec, rawdir)
      
      base_pfile_path = File.join(@rawdir, @scan_spec['pfile'])
      pfile_path = File.exist?(base_pfile_path) ? base_pfile_path : base_pfile_path + '.bz2'
  
      raise IOError, "#{pfile_path} does not exist." unless File.exist?(pfile_path)
  
      flash "Pfile Reconstruction: #{pfile_path}"
      @pfile_data = Pathname.new(pfile_path).local_copy
      
      @refdat_file = @scan_spec['refdat_stem'] ||= search_for_refdat_file
      setup_refdat(@refdat_file)
    end
  
    # Reconstructs a single pfile using epirecon
    # Outfile may include a '.nii' extension - a nifti file will be constructed
    # directly in this case.
    def reconstruct_sequence(outfile)
      volumes_to_skip = @scan_spec['volumes_to_skip'] ||= 3
      epirecon_cmd_format = "epirecon_ex -f %s -NAME %s -skip %d -scltype=0"
      epirecon_cmd_options = [@pfile_data, outfile, volumes_to_skip]
      epirecon_cmd = epirecon_cmd_format % epirecon_cmd_options
			raise ScriptError, "Problem running #{epirecon_cmd}" unless run(epirecon_cmd)
    end
    
    alias_method :prepare, :reconstruct_sequence
    
    private
  
    # Find an appropriate ref.dat file if not provided in the scan spec.
    def search_for_refdat_file
      Dir.new(@rawdir).each do |file|
        return file if file =~ /ref.dat/
      end
      raise ScriptError, "No candidate ref.dat file found in #{@rawdir}"
    end
  
    # Create a new unzipped local copy of the ref.dat file and link it into 
    # pwd for reconstruction.
    def setup_refdat(refdat_stem)
      $Log.debug "Using refdat file: #{refdat_stem}"
			base_refdat_path = File.join(@rawdir, refdat_stem)
      refdat_path = File.exist?(base_refdat_path) ? base_refdat_path : base_refdat_path + ".bz2"
      raise IOError, "#{refdat_path} does not exist." unless File.exist?(refdat_path)
      local_refdat_file = Pathname.new(refdat_path).local_copy
			# epirecon expects a reference named _exactly_ ref.dat, so that's what the link should be named.
      FileUtils.ln_s(local_refdat_file, File.join(Dir.pwd, 'ref.dat'), :force => true)
    end    
   end
end
