require_relative 'test_helper'

class ResultEntryTest < MiniTest::Test
  def setup
    re_data = {
      name: "DISTRICT 1",
      free_and_reduced_price_lunch_rate: 0.5,
    	children_in_poverty_rate: 0.25,
      high_school_graduation_rate: 0.75
    }
    @re = ResultEntry.new(re_data)
  end

  def test_result_entry_returns_name
    assert_respond_to(@re, :name)
    assert_equal "DISTRICT 1", @re.name
  end

  def test_result_entry_returns_free_and_reduced_price_lunch_rate
    assert_respond_to(@re, :free_and_reduced_price_lunch_rate)
    assert_equal 0.5, @re.free_and_reduced_price_lunch_rate
  end

  def test_result_entry_returns_children_in_poverty_rate
    assert_respond_to(@re, :children_in_poverty_rate)
    assert_equal 0.25, @re.children_in_poverty_rate
  end

  def test_result_entry_returns_high_school_graduation_rate
    assert_respond_to(@re, :high_school_graduation_rate)
    assert_equal 0.75, @re.high_school_graduation_rate
  end

  def test_result_entry_returns_median_household_income
    assert_respond_to(@re, :median_household_income)
    assert_nil @re.median_household_income
  end
end
