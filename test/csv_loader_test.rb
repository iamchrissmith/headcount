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
end