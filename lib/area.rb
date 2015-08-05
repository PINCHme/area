if RUBY_VERSION.to_f >= 1.9 # ;_;
  require 'csv'
else
  require 'rubygems'
  require 'faster_csv'
end

require 'area/array'
require 'area/integer'
require 'area/string'

module Area

  # Public: Returns an two-dimentional Array of area codes.
  #
  # Examples
  #
  #   Area.area_codes
  #   # => [["201", "NJ"]..]
  #
  # Returns an Array representation of area codes.
  def self.area_codes
    @area_codes ||= load_csv(:areacodes)
  end

  # Public: Returns an two-dimentional Array of zip codes.
  #
  # Examples
  #
  #   Area.zip_codes
  #   # => [["00401","Pleasantville","NY","41.1381","-73.7847"]..]
  #
  # Returns an Array representation of zip codes.
  def self.zip_codes
    @zip_codes ||= load_csv(:zipcodes)
  end

  def self.regions
    regions = []
    area_codes.map{|row| regions << row.last.upcase }
    return regions
  end

  def self.code?(code)
    if code.to_s.length == 3
      return code
    else
      raise ArgumentError, "You must provide a valid area code", caller
    end
  end

  def self.code_or_zip?(code)
    if code.to_s.length == 3 or code.to_s.length == 5
      return code
    else
      raise ArgumentError, "You must provide a valid area or zip code", caller
    end
  end

  def self.zip?(code)
    if code.to_s.length == 5
      return code
    else
      raise ArgumentError, "You must provide zip code", caller
    end
  end

  def self.state_or_territory?(state)
    if self.regions.include?(state.upcase)
      return state
    else
      raise ArgumentError, "You must provide a valid US state abbreviation or territory name", caller
    end
  end

  def self.zip_or_territory?(state)
    if self.regions.include?(state.upcase) or self.zip?(state)
      return state
    else
      raise ArgumentError, "You must provide a valid US state abbreviation or zipcode.", caller
    end
  end


  private

    # Internal: Load the data in corresponding csv files in the data directory.
    #
    # type - String or Symbol value that is the same as the name of a CSV file in the data directory.
    #
    # Examples
    #
    #   self.load_csv(:areacodes)  #=> []
    #   self.load_csv(:zipcodes)  #=> []
    #
    # Returns an Array of values from the CSV data.
    def self.load_csv(type)
      file = File.open(File.join(File.dirname(__FILE__), '..', 'data',  "#{type}.csv"))
      (RUBY_VERSION.to_f >= 1.9) ? CSV.read(file) : FasterCSV.parse(file)
    end
end
