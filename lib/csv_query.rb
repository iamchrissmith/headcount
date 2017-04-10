require 'csv'
require 'pry'

module CSVQuery
  def load_file(file_name)
    CSV.open file_name, headers:true, header_converters: :symbol
  end

  def parse_file(file_name, header)
    sanitize(load_file(file_name), header)
  end

  def get_column(file_name, header)
    contents = load_file(file_name)

    contents.map do |row|
      row[header]
    end
  end

  def csv_to_hash(file_name)
    contents = load_file(file_name)

    contents.to_a.map {|row| row.to_hash } #returns array of hashes, each hash storing data relevant to the district
  end

  def sanitize(file_name, header)
    if header == :data && get_column(file_name, header)[0].include?(".")
      data = []
      csv_to_hash(file_name).each do |hash|
        hash[:data] = format_percent(hash[:data])
        data << hash
      end
    end
    data
  end

  def format_percent(number)
    number.to_f.round(3)
  end
end