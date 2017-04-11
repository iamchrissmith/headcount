require_relative 'test_helper'


class EnrollmentTest < MiniTest::Test
  attr_reader :e

  def setup
    @e = Enrollment.new({
                          name: 'Test',
                          :kindergarten_participation => {2010 => 0.3915},
                          :high_school_participation => {2010 => 0.895}
                        })
  end

  def test_district_exists
    assert @e
  end

  def test_district_has_a_name
    assert_equal "Test", @e.name
  end

  def test_can_get_participation_by_year
    args = {:name => "ACADEMY 20", :kindergarten_participation => {2011 => 0.35356}}
    @e.update_data(args)
    k_data_by_year = @e.kindergarten_participation_by_year
    assert_equal 2, k_data_by_year.length
    assert_equal 0.35356, k_data_by_year[2011]
  end

  def test_can_get_participation_in_year
    args = {:name => "ACADEMY 20", :kindergarten_participation => {2011 => 0.35356}}
    @e.update_data(args)
    k_data_in_2010 = @e.kindergarten_participation_in_year(2010)
    assert_equal 0.3915, k_data_in_2010
  end

  def test_can_get_graduation_by_year
    args = {:name => "ACADEMY 20", :high_school_participation => {2011 => 0.35356}}
    @e.update_data(args)
    hs_data_by_year = @e.graduation_rate_by_year
    assert_equal 2, hs_data_by_year.length
    assert_equal 0.35356, hs_data_by_year[2011]
  end

  def test_can_get_participation_in_year
    args = {:name => "ACADEMY 20", :high_school_participation => {2011 => 0.35356}}
    @e.update_data(args)
    hs_data_in_2010 = @e.graduation_rate_in_year(2010)
    assert_equal 0.895, hs_data_in_2010
  end
end
