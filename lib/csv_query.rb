require 'csv'

module CSVQuery
  def load_file(file_name)
    CSV.open file_name, headers:true, header_converters: :symbol
  end

  def parse_file(file_name)
    contents = load_file(file_name)
    contents.sanitize # create sanitization method as illustrated on whiteboard
  end

  def get_column(file_name, header)
    contents = load_file(file_name)

    contents.map do |row|
      row[header]
    end
  end
end