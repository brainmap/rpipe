class LogfileHelper
  
  attr_accessor :textfile_data, :conditions, :csv_filename
  
  def initialize(path, *conditions)
    @textfile = path
    @textfile_data = []
    @conditions = conditions
    File.open(path, 'r').each do |line| 
      @textfile_data << line.split(/[\,\:\s]+/).each { |val| val.strip } 
    end

  end
  
  def to_csv
    vectors = extract_condition_vectors(@conditions)
    vectors = zero_and_convert_to_reps(vectors)
    puts vectors
    
    output = ""
    output <<  vectors.keys.join(', ') + "\n"
    vectors.values.transpose.each do |row|
      output << row.join(', ') + "\n"
    end
    
    return output
  end
  
  def write_csv(filename)
    File.open(filename, 'w') { |f| f.puts to_csv }
    @csv_filename = filename
  end
  
  def write_mat(prefix)
    queue = []
    queue << JobStep.add_matlab_paths(
      File.expand_path(File.dirname(__FILE__)), 
      File.expand_path(File.join(File.dirname(__FILE__), '..', 'matlab_helpers'))
    )

    queue << "prepare_onsets_xls( \
      '#{@csv_filename}', \
      '#{prefix}', \
      { #{@conditions.collect {|c| "'#{c}'"}.join(' ') } } \
    )"
    
    puts JobStep.run_matlab_queue(queue)
  end
  
  private
  
  def extract_condition_vectors(conditions)
    vectors = {}
    @textfile_data.each do |line|
      next if line.empty?
      header = line.first.downcase.to_sym
      if conditions.include?(header);
        # puts ">> " + line.join(', ') 
        vectors[header] = line[2..-1].collect {|val| val.to_f }
      end
    end
    
    return vectors
  end
  
  def zero_and_convert_to_reps(vectors)
    minimum = vectors.values.flatten.min
    vectors.values.each do |row|
      row.collect! { |val| (val - minimum) / 2000 }
    end
    
    return vectors
  end
  
end