require 'matlab_helpers/matlab_queue'
require 'ruport'

###############################################	 START OF CLASS	 ######################################################
# An object that helps parse and format Behavioral Logfiles.
class Logfile
  
  attr_accessor :textfile_data, :conditions, :csv_filename
  attr_reader :textfile, :vectors
  
  def initialize(path, *conditions)
    @textfile = path
    @textfile_data = []
    @conditions = conditions
    raise IOError, "Can't find file #{path}" unless File.exist?(path)
    File.open(path, 'r').each do |line| 
      @textfile_data << line.split(/[\,\:\n\r]+/).each { |val| val.strip } 
    end
    
    raise IOError, "Problem reading #{@textfile} - no data found." if @textfile_data.empty?

  end
  
  def to_csv
    @vectors = extract_condition_vectors(@conditions)
    @vectors = zero_and_convert_to_reps(vectors)
    rows = @vectors.values
    rows = pad_array(rows)
    
    output = ""
    output <<  vectors.keys.join(', ') + "\n"
    vectors.values.transpose.each do |row|
      output << row.join(', ') + "\n"
    end
    
    return output
  end
  
  def write_csv(filename)
    File.open(filename, 'w') { |f| f.puts to_csv }
    raise "Unable to write #{filename}" unless File.exist?(filename)
    @csv_filename = filename
  end
  
  def write_mat(prefix)
    queue = MatlabQueue.new    
    queue.paths << [
      Pathname.new(File.join(File.dirname(__FILE__), 'matlab_helpers'))
    ]

    queue << "prepare_onsets_xls( \
      '#{@csv_filename}', \
      '#{prefix}', \
      { #{@conditions.collect {|c| "'#{c}'"}.join(' ') } } \
    )"
    
    queue.run!
    
    raise ScriptError, "Problem writing #{prefix}.mat" unless File.exist?(prefix + '.mat')
    
    return prefix + '.mat'
  end
  
  def <=>(other_logfile)
    File.stat(@textfile).mtime <=> File.stat(other_logfile.textfile).mtime
  end
  
  def self.write_summary(filename = 'tmp.csv', directory = Dir.pwd, grouping = 'version')
    table = self.summarize_directory(directory)
    File.open(filename, 'w') do |f| 
      f.puts Ruport::Data::Grouping(table, :by => grouping).to_csv
    end
  end
    
  def self.summarize_directory(directory)
    table = Ruport::Data::Table.new
    Dir.glob(File.join(directory, '*.txt')).each do |logfile| 
      lf = Logfile.new(logfile)      
      table << lf.ruport_summary
      table.column_names = lf.summary_attributes if table.column_names.empty?
    end
    return table
  end
  
  def ruport_summary
    Ruport::Data::Record.new(summary_data, :attributes => summary_attributes )
  end
  
  def summary_data
    enum, task, version = File.basename(@textfile).split("_").values_at(0,3,4)
    enum = File.basename(enum) unless enum.nil?
    version = File.basename(version, '.txt') unless version.nil?
    ctime = File.stat(@textfile).ctime
    
    [[enum, task, version, ctime], @textfile_data[1]].flatten
  end
  
  def summary_attributes
    ['enum', 'task', 'version', 'ctime'] + @textfile_data[0]
  end
  
  private
  
  def extract_condition_vectors(conditions)
    vectors = {}
    @conditions
    @textfile_data.each do |line|
      next if line.empty?
      # Headers are written in the Textfile as "New(Correct)".
      # Convert them to proper condition names - downcase sepearted by underscores
      header = line.first.gsub(/(\(|\))/, '_').downcase.chomp("_").to_sym
      if conditions.include?(header);
        # Make sure this isn't a column line inside the logfile.
        if line[1] =~ /time/ 
          vectors[header] = line[2..-1].collect {|val| val.to_f }
        end
      end
    end
    
    raise ScriptError, "Unable to read vectors for #{@textfile}" if vectors.empty?
    
    return vectors
  end
  
  def zero_and_convert_to_reps(vectors)
    minimum = vectors.values.flatten.min
    vectors.values.each do |row|
      row.collect! { |val| (val - minimum) / 2000 }
    end
    
    return vectors
  end
  
  def pad_array(rows)
    max_length = rows.inject(0) { |max, row| max >= row.length ? max : row.length }
    rows.each do |row|
      row[max_length] = nil
      row.pop
    end
  end
  
end