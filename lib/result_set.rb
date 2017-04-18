class ResultSet
  attr_reader :matching_districts, :statewide_average

  def initialize (args)
    @matching_districts = args[:matching_districts] || nil
    @statewide_average = args[:statewide_average] || nil
  end
end
