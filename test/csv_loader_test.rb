require_relative 'test_helper'
require_relative '../lib/csv_loader'

class DummyClass
  include CSVLoader
end

class CSVLoaderTest < Minitest::Test
  def test_load_file_method
  assert_respond_to(DummyClass.new, :load_file)
  end

  def test_load_file_can_load_file
    assert_instance_of CSV, DummyClass.new.load_file("./data/Special education.csv")
  end
end