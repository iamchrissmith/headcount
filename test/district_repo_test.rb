require_relative 'test_helper'

class DistrictRepositoryTest < MiniTest::Test
  attr_reader :dr

  def setup
    @dr = DistrictRepository.new
    @dr_args = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv"
      },
      :statewide_testing => {
        :third_grade  => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
      },
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv"
      }
    }
  end

  def test_district_repo_exists
    assert @dr
  end

  def test_responds_to_load_file
    assert_respond_to(@dr, :load_data)
  end

  def test_responds_to_find_by_name
    assert_respond_to(@dr, :find_by_name)
  end

  def test_responds_to_find_all_matching
    assert_respond_to(@dr, :find_all_matching)
  end

  def test_responds_to_create_district
    assert_respond_to(@dr, :create_district)
  end

  def test_find_by_name_returns_district
    assert_equal 0, @dr.data.length
    @dr.create_district("DISTRICT 1")
    district = @dr.find_by_name("DISTRICT 1")
    assert_equal 1, @dr.data.length
    assert_equal district, @dr.data[0]
  end

  def test_find_all_matching_returns_empty_array
    assert_equal [], @dr.find_all_matching('Test')
  end

  def test_find_all_matching_returns_array_of_found
    district = @dr.create_district("District 1")
    district_1 = @dr.create_district("Test 1")
    district_2 = @dr.create_district("Test 2")
    districts = @dr.find_all_matching("test")
    assert_equal 2, districts.length
    districts.each do |district|
      assert district.name == "Test 1" || district.name == "Test 2"
      assert_instance_of District, district
    end
  end

  def test_populate_data_adds_districts_to_data
    dummy = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14"]
    assert_equal 0, @dr.data.length
    @dr.populate_data(dummy)
    assert_equal 3, @dr.data.length
    @dr.data.each do |district|
      assert_instance_of District, district
    end
    assert_equal "COLORADO", @dr.data[0].name
    assert_equal "ACADEMY 20", @dr.data[1].name
    assert_equal "ADAMS COUNTY 14", @dr.data[2].name
  end

  def test_populate_data_does_not_create_duplicates
    dummy = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14", "ACADEMY 20"]
    assert_equal 0, @dr.data.length
    @dr.populate_data(dummy)
    assert_equal 3, @dr.data.length
    @dr.data.each do |district|
      assert_instance_of District, district
    end
    assert_equal "COLORADO", @dr.data[0].name
    assert_equal "ACADEMY 20", @dr.data[1].name
    assert_equal "ADAMS COUNTY 14", @dr.data[2].name
  end

  def test_create_district_assigns_data_obj_to_district
    dummy = ["COLORADO", "ACADEMY 20", "ADAMS COUNTY 14"]
    @dr.populate_data(dummy)
    district = @dr.find_by_name("COLORADO")
    assert_equal 3, @dr.data.length
    assert_equal district, @dr.data[0]
    assert_instance_of District, @dr.data[0]
  end

  def test_load_data_populates_districts
    @dr.load_data(@dr_args)
    assert_equal 181, @dr.data.length
    refute_nil @dr.find_by_name("COLORADO")
    refute_nil @dr.find_by_name("ACADEMY 20")
  end

  def test_districts_can_access_enrollment
    @dr.load_data(@dr_args)
    district = @dr.find_by_name("COLORADO")
    k_data_by_year = district.enrollment.kindergarten_participation_by_year
    k_data_in_2010 = district.enrollment.kindergarten_participation_in_year(2010)
    assert_equal 11, k_data_by_year.length
    assert_equal 0.672, k_data_by_year[2011]
    assert_equal 0.64, k_data_in_2010
  end

  def test_districts_can_access_statewide_test
    @dr.load_data(@dr_args)
    district = @dr.find_by_name("COLORADO")
    assert_respond_to(district, :statewide_test)
    statewide_test = district.statewide_test
    assert_instance_of StatewideTest, statewide_test
  end

  def test_districts_can_access_economic_profile
    @dr.load_data(@dr_args)
    district = @dr.find_by_name("COLORADO")
    assert_respond_to(district, :economic_profile)
    economic_profile = district.economic_profile
    assert_instance_of EconomicProfile, economic_profile
  end
end
