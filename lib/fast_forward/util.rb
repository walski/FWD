module FWD
  # Util class to achieve common tasks in FWD.
  # The Util class is supposed to be used in a static manner only.
  class Util
    
    # Given a filename (with path but without a suffix) and an array of possible
    # suffixes this methods checks which file + suffix combination exists and
    # returns the first existing one.
    # If the passed in filename already has a suffix the method just returns
    # the passed in filename.
    # If no matching file + suffix combination is found a NoMatchingFileError
    # is raised.
    def self.matching_file(file, possible_suffix)
      return file if file =~ /\.[a-zA-Z]+$/
      
      file = "#{FWD_ROOT}/file" unless file =~ /^#{FWD_ROOT}/
      
      possible_suffix.each do |suffix|
        filename = "#{file}.#{suffix}"
        return filename if File.exists?(filename)
      end

      raise NoMatchingFileError.new(filename)
    end
  end
  
  
  class NoMatchingFileError < ArgumentError
  end
  
end