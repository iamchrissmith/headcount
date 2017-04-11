require_relative 'test_helper'
require_relative '../lib/csv_query'

class DummyClass
  include CSVQuery
end

class CSVQueryTest < Minitest::Test
  def test_load_file_method
    assert_respond_to(DummyClass.new, :load_file)
  end

  def test_load_file_returns_csv_object_of_loaded_file
    assert_instance_of CSV, DummyClass.new.load_file("./data/Special education.csv")
  end

  def test_get_column_returns_indiciated_column
    column = DummyClass.new.get_column("./data/Special education.csv", :location)
    column = column[0].to_s

    assert_includes "Colorado", column
  end

  def test_csv_to_hash_returns_hash_of_data
    assert_equal 1086, DummyClass.new.csv_to_hash("./data/Pupil enrollment.csv").count
  end

  def test_format_percent_creates_float_and_rounds_to_3_decimals
    sample_num = 2.545195857435

    assert_instance_of Float, DummyClass.new.format_percent(sample_num)
    assert_equal 2.545, DummyClass.new.format_percent(sample_num)
  end

  def test_sanitize_data_header
    assert_equal 0.101, DummyClass.new.sanitize("./data/Special education.csv", :data)[4][:data]
  end

  def test_sanitize_location_case
    assert_equal "COLORADO", DummyClass.new.sanitize("./data/Special education.csv", :location)[0][:location]
  end
end