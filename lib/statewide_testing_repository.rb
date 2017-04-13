require_relative 'statewide_test'
require_relative 'csv_parser'

class StatewideTestRepository
  include CSVParser
  attr_reader :data

  def initialize
    @data = []
  end

  def load_data(args)
    added_districts = []
    args[:statewide_testing].each do |category, file|
      contents = parse_file(file)
      added_districts = added_districts + process_data(contents, category)
    end
    added_districts.uniq
  end

  def process_data(contents, category)
    data_category = translate_category(category)
    contents.map do |row|
      process_row(row, data_category)
    end
  end

  def process_row(row, data_category)
    row[:location] = row[:location].upcase
    if row[:dataformat] == "Percent"
      row[:data] = format_percent(row[:data])
    end
    sub_category = translate_sub_category(data_category)
    if row[sub_category] == "Hawaiian/Pacific Islander"
      row[sub_category] = "Pacific Islander"
    end
    row[sub_category] = row[sub_category].downcase.gsub(" ", "_")
    testing_data = make_testing_data(row, data_category, sub_category)
    statewide_test = find_by_name(row[:location])
    if statewide_test
      statewide_test.update_data(testing_data)
    else
      create_statewide_test(testing_data)
    end
    row[:location]
  end

  def find_by_name(name)
    data.find { |statewide_test| statewide_test.name == name }
  end

  def create_statewide_test(statewide_test)
    data << StatewideTest.new(statewide_test)
  end

  private

  def translate_category(category)
    categories = {
    }
    categories[category] || category
  end

  def translate_sub_category(category)
    sub_categories = {
      :third_grade  => :score,
      :eighth_grade => :score,
      :math         => :race_ethnicity,
      :reading      => :race_ethnicity,
      :writing      => :race_ethnicity
    }
    sub_categories[category]
  end

  def make_testing_data(row, data_category, sub_category)
    { :name => row[:location],
      data_category => {
        row[:timeframe].to_i => {
          row[sub_category].to_sym => row[:data]
        }
      }
    }
  end
end
