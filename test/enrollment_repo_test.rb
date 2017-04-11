require_relative 'test_helper'


class EnrollmentRepositoryTest < MiniTest::Test
  attr_reader :er

  def setup
    @er = EnrollmentRepository.new
    @enrollment_args = {
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv"
      }
    }
    @enrollment_data = {:name => "DISTRICT 1", :kindergarten_participation => {2011 => 0.35356}}
  end

  def test_enrollment_repo_exists
    assert @er
  end

  def test_initializes_with_no_data
    assert_empty @er.data
  end

  def test_responds_to_load_file
    assert_respond_to(@er, :load_data)
  end

  def test_responds_to_find_by_name
    assert_respond_to(@er, :find_by_name)
  end

  def test_responds_to_create_district
    assert_respond_to(@er, :create_enrollment)
  end

  def test_responds_to_process_data
    assert_respond_to(@er, :process_data)
  end

  def test_create_enrollment_adds_enrollment_object_to_data
    enrollment = @er.create_enrollment(@enrollment_data)
    assert_equal 1, @er.data.length
    assert_instance_of Enrollment, @er.data[0]
  end

  def test_find_by_name_returns_enrollment
    assert_equal 0, @er.data.length
    enrollment = @er.create_enrollment(@enrollment_data)
    assert_equal 1, @er.data.length
    enrollment = @er.find_by_name("DISTRICT 1")
    assert_equal enrollment, @er.data[0]
  end

  def test_load_data_returns_array
    result = @er.load_data(@enrollment_args)
    assert_instance_of Array, result
    assert_equal 181, result.length
  end
end
