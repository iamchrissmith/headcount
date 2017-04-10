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
end