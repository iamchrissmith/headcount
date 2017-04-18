class ResultEntry
  def initialize(data)
    @data = data
  end

  def name
    @data[:name]
  end

  def free_and_reduced_price_lunch_rate
    @data[:free_and_reduced_price_lunch_rate]
  end

  def children_in_poverty_rate
    @data[:children_in_poverty_rate]
  end

  def high_school_graduation_rate
    @data[:high_school_graduation_rate]
  end

  def median_household_income
    @data[:median_household_income]
  end
end
