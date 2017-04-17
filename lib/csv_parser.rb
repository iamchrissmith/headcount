require 'csv'
require 'pry'

module CSVParser

  def parse_file(file_name)
    CSV.open file_name, headers:true, header_converters: :symbol
  end

  def format_percent(number)
    return "N/A" if number == "N/A"
    number.to_f.round(3)
  end
end
