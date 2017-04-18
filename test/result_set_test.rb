require_relative 'test_helper'

class ResultSetTest < MiniTest::Test
  def setup
    r1 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.5,
    	children_in_poverty_rate: 0.25,
      high_school_graduation_rate: 0.75})
    r2 = ResultEntry.new({free_and_reduced_price_lunch_rate: 0.3,
    	children_in_poverty_rate: 0.2,
      high_school_graduation_rate: 0.6})
    @rs = ResultSet.new(matching_districts: [r1], statewide_average: r2)
  end

  def test_result_set_responds_to_matching_districts
    assert_respond_to(@rs, :matching_districts)
  end

  def test_matching_districts_returns_array_of_ResultEntry_objects
    result = @rs.matching_districts
    assert_instance_of Array, result
    result.each do |entry|
      assert_instance_of ResultEntry, entry
    end
  end

  def test_result_set_responds_to_statewide_average
    assert_respond_to(@rs, :statewide_average)
  end

  def test_statewide_average_returns_ResultEntry
    result = @rs.statewide_average
    assert_instance_of ResultEntry, result
  end

  def test_can_retrieve_result_entry_data_from_matching
    assert_equal 0.5, @rs.matching_districts.first.free_and_reduced_price_lunch_rate
    assert_equal 0.25, @rs.matching_districts.first.children_in_poverty_rate
    assert_equal 0.75, @rs.matching_districts.first.high_school_graduation_rate
  end

  def test_can_retrieve_result_entry_data_from_statewide_average
    assert_equal 0.3, @rs.statewide_average.free_and_reduced_price_lunch_rate
    assert_equal 0.2, @rs.statewide_average.children_in_poverty_rate
    assert_equal 0.6, @rs.statewide_average.high_school_graduation_rate
  end
end
