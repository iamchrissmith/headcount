require_relative '../economic_profile'
require_relative '../csv_parser'
require 'pry'

class EconomicProfileBuilder
  include CSVParser

  def initialize(repository)
    @repository = repository
  end

  def build_profile(file, category)
    contents = parse_file(file)
    process_data(contents, category)
  end

  def process_data(contents, category)
    contents.map do |row|
      next if row[:poverty_level] && is_not_free_or_reduced_lunch(row)
      next if is_child_poverty_and_is_not_percent(category, row)
      process_row(row, category)
    end
  end

  def process_row(row, category)
    sanitize(row, category)
    if category == :free_or_reduced_price_lunch
      sub_category = sub_categories[row[:dataformat]]
      economic_data = make_economic_data_with_sub(row, category, sub_category)
    else
      economic_data = make_economic_data(row, category)
    end
    populate_data(row, economic_data)
  end

  def create_economic_profile(economic_data)
    @repository.data << EconomicProfile.new(economic_data)
  end

  private

  def sub_categories
    {
      "Percent" => :percentage,
      "Number"  => :total
    }
  end

  def sanitize(row, category)
    row[:location] = row[:location].upcase
    if row[:dataformat] == "Percent"
      row[:data] = format_percent(row[:data])
    end
    if category == :median_household_income
      sanitize_household_income(row)
    else
      row[:timeframe] = row[:timeframe].to_i
    end
  end

  def sanitize_household_income(row)
    row[:timeframe] = row[:timeframe].split("-").map(&:to_i)
  end

  def populate_data(row, data)
    economic_profile = @repository.find_by_name(row[:location])
    if economic_profile
      economic_profile.update_data(data)
    else
      create_economic_profile(data)
    end
    row[:location]
  end

  def make_economic_data(row, category)
    { :name => row[:location],
      category => {
        row[:timeframe] => row[:data]
      }
    }
  end

  def make_economic_data_with_sub(row, category, sub_category)
    { :name => row[:location],
      category => {
        row[:timeframe].to_i => {
          sub_category => row[:data]
        }
      }
    }
  end

  def is_not_free_or_reduced_lunch(row)
    row[:poverty_level] != right_tag = "Eligible for Free or Reduced Lunch"
  end

  def is_child_poverty_and_is_not_percent(category, row)
    category == :children_in_poverty && row[:dataformat] != "Percent"
  end
end
