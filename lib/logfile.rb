require 'pp'
require 'matlab_helpers/matlab_queue'
require 'ruport'

###############################################	 START OF CLASS	 ######################################################
# An object that helps parse and format Behavioral Logfiles.
class Logfile
  
  # An array of rows raw text data 
  attr_accessor :textfile_data
  # Conditions to extract time vectors from
  attr_accessor :conditions
  # Filename for output csv
  attr_accessor :csv_filename
  # Original Presentation Processed Logfile (.txt)
  attr_reader :textfile
  # A hash of Onset Vectors keyed by condition
  attr_reader :vectors
  
  def initialize(path, *conditions)
    @textfile = path
    @textfile_data = []
    @conditions = conditions.select {|cond| cond.respond_to? 'to_sym'  }
    
    # Add the keys of any hashes (the combined conditions) to the list of 
    # conditions and add the separate vectors to the list of combined_conditions
    @combined_conditions = []
    conditions.select {|cond| cond.respond_to? 'keys' }.each do |cond|
      cond.keys.collect {|key| @conditions << key }
      @combined_conditions << cond
    end
    
    raise IOError, "Can't find file #{path}" unless File.exist?(path)
    File.open(path, 'r').each do |line| 
      @textfile_data << line.split(/[\,\:\n\r]+/).each { |val| val.strip } 
    end
    
    raise IOError, "Problem reading #{@textfile} - no data found." if @textfile_data.empty?

    if @conditions.empty?
      raise ScriptError, "Could not set conditions #{conditions}" unless conditions.empty?
    end

  end
  
  def condition_vectors
    return @vectors if @vectors
    raise ScriptError, "Conditions must be set to extract vectors" if @conditions.empty?
    vectors = extract_condition_vectors(@conditions)
    @vectors = zero_and_convert_to_reps(vectors)
  end
  
  def to_csv
    rows = condition_vectors.values
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
    raise ScriptError, "Unable to write #{filename}" unless File.exist?(filename)
    @csv_filename = filename
  end
  
  def write_mat(prefix)
    queue = MatlabQueue.new    
    queue.paths << [
      Pathname.new(File.join(File.dirname(__FILE__), 'matlab_helpers'))
    ]
    
    raise ScriptError, "Can't find #{@csv_filename}" unless File.exist?(@csv_filename)

    queue << "prepare_onsets_xls( \
      '#{@csv_filename}', \
      '#{prefix}', \
      { #{@conditions.collect {|c| "'#{c}'"}.join(' ') } } \
    )"
    
    queue.run!
    
    raise ScriptError, "Problem writing #{prefix}.mat" unless File.exist?(prefix + '.mat')
    
    return prefix + '.mat'
  end
  
  # Sort Logfiles by their Modification Time
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
      # Intialize a logfile without any conditions.
      lf = Logfile.new(logfile)
      table << lf.ruport_summary
      table.column_names = lf.summary_attributes if table.column_names.empty?
    end
    return table
  end
  
  # Create an item analysis table containing average response time and 
  # accuracy for each item over all logfiles.
  def self.item_analysis(directory)
    logfiles = Dir.glob(File.join(directory, '*.txt')).collect { |lf| lf = Logfile.new(lf) }
    all_items = self.item_table(logfiles)
    item_groups = self.group_items_by(all_items, ['code1', 'pair_type'])
    summary = self.item_summary(item_groups)
    
    return summary
  end
  
  # Create a Ruport::Data::Table of all the response pairs for a given logfile.
  def response_pairs_table
    response_pairs = []
    
    @textfile_data.each do |line|
      next if line.empty?
      header = line.first.gsub(/(\(|\))/, '_').downcase.chomp("_").to_sym
      if line[1] =~ /(o|n)_\w\d{2}/
        response_pairs << Ruport::Data::Record.new(response_pair_data(line), :attributes => response_pair_attributes)
      end
    end    
    
    return response_pairs
  end
  
  # Fields to be included in a Response Pair Table
  def response_pair_attributes
    ['enum', 'version', 'ctime', 'pair_type', 'code1', 'time1', 'code2', 'time2', 'time_diff']
  end
  
  def ruport_summary
    Ruport::Data::Record.new(summary_data, :attributes => summary_attributes )
  end
  
  def summary_attributes
    ['enum', 'task', 'version', 'ctime'] + @textfile_data[0]
  end
  
  # Combine vectors into a new one (new_misses + old_misses = misses)
  def combine_vectors(combined_vector_title, original_vector_titles)
    # Add the combined vectors to the vectors instance variable.
    condition_vectors[combined_vector_title] = combined_vectors(original_vector_titles)
    
    # Add the new condition to @conditions
    @conditions << combined_vector_title
  end
    
  private
  
  def combined_vectors(titles)
    combined_vector = []
    puts titles
    titles.each do |title|
      if condition_vectors[title]
        combined_vector << condition_vectors[title]
      else
        pp condition_vectors
        raise "Couldn't find vector called #{title}"
      end
    end
    pp combined_vector
    return combined_vector.flatten.sort
  end  
  
  # Create a table of all responses to all items.
  # Pass in an array of #Logfiles
  def self.item_table(logfiles)
    table = Ruport::Data::Table.new
    
    logfiles.each do |logfile| 
      logfile.response_pairs_table.collect { |pair| table << pair }
      table.column_names = logfile.response_pair_attributes if table.column_names.empty?
    end
    
    return table    
  end
  
  def self.item_summary(grouping)
    item_summary_table = Ruport::Data::Table.new
    grouping.data.keys.each do |code| 
      # Create a new copy of the grouping, because the act of summarizing a 
      # grouping does something destructive to it.
      current_group = grouping.dup; 
      samples = current_group.data.values.first.length
      
      
      # Return the summary of codes for each item (in the current case, that's 
      # <condition>_correct, <condition>_incorrect, and misses)
      item_records = current_group.subgrouping(code).summary(:code1, 
        :response_time_average => lambda {|sub| sub.sigma("time_diff").to_f / sub.length}, 
        :count => lambda {|sub| sub.length}, 
        :accuracy => lambda {|sub| sub.length / samples.to_f }, 
        :version => lambda {|sub| sub.data[0][1] }  
      );
      
      # Extract just the first record (correct responses) for the item analysis
      # as incorrect can be inferred.  Currently, ditch the misses.
      item_record = item_records.to_a.first
      
      # Add the item to the record as a column (the summary doesn't give this
      # by default because it assumes we already know what we're summarizing.)
      item_record['code1'] = code; 
      item_summary_table << item_record
    end
    
    return item_summary_table
  end
  
  def self.group_items_by(table, groupings)
    Ruport::Data::Grouping.new(table, :by => groupings)
  end  
  
  def response_pair_data(line)
    enum, task, version = File.basename(@textfile).split("_").values_at(0,3,4)
    enum = File.basename(enum) unless enum.nil?
    version = File.basename(version, '.txt') unless version.nil?
    ctime = File.stat(@textfile).ctime
    
    [enum, version, ctime] + line
    
  end
  

  
  def summary_data
    enum, task, version = File.basename(@textfile).split("_").values_at(0,3,4)
    enum = File.basename(enum) unless enum.nil?
    version = File.basename(version, '.txt') unless version.nil?
    ctime = File.stat(@textfile).ctime
    
    [[enum, task, version, ctime], @textfile_data[1]].flatten
  end  
  
  def extract_condition_vectors(conditions)
    vectors = {}
    @conditions
    @textfile_data.each do |line|
      next if line.empty?
      # Headers are written in the Textfile as "New(Correct)".
      # Convert them to proper condition names - downcase separated by underscores
      header = line.first.gsub(/(\(|\))/, '_').downcase.chomp("_").to_sym
      vector = line[2..-1].collect {|val| val.to_f } if line[2..-1]

      # Make sure this isn't a column line inside the logfile.
      if line[1] =~ /time/ 
        # Check if this vector matches any combined conditions.
        @combined_conditions.each do |vector_group|
          vector_group.each_pair do |key, vals| 
            if vals.include?(header)
              vectors[key] = vectors[key] ? vector.collect{ |timepoint| vectors[key] << timepoint} : vector
              vectors[key].flatten!
            end
          end
        end
        
        # Check if this vector matches a single condition.
        vectors[header] = vector if @conditions.include?(header);
      end
    end
    
    # Ensure that the vecotors are in order.
    vectors.each_value { |vector| vector.sort! }
    
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