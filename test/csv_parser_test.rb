require_relative 'test_helper'


class DummyClass
  include CSVParser
end

class CSVQueryTest < Minitest::Test
  def setup
    @dummy = DummyClass.new
  end

  def test_respond_to_parse_file
    assert_respond_to(@dummy, :parse_file)
  end

  def test_respond_to_format_percent
    assert_respond_to(@dummy, :format_percent)
  end

  def test_parse_file_returns_csv_object
    assert_instance_of CSV, @dummy.parse_file("./data/Special education.csv")
  end

  def test_format_percent_creates_float_and_rounds_to_3_decimals
    sample_num = 2.545195857435
    assert_instance_of Float, @dummy.format_percent(sample_num)
    assert_equal 2.545, @dummy.format_percent(sample_num)
  end
end
