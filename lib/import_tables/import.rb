require 'csv'

class ImportTable
  def self.read_headers(csv_name)
    csv = CSV.read(File.join(Rails.root, "data", "#{csv_name}.csv"), options)
    csv.headers.map(&:to_sym)
  end

  def self.read_file(dir_path, csv_name)
    options = { headers: true,
                converters: [:all, :empty_data, :true_indicator, :false_indicator]
              }
    csv = CSV.read(File.join(dir_path, "#{csv_name}.csv"), options)
    csv_data = csv.to_a[1..-1].map do |row|
      Hash[csv.headers.zip(row)]
    end
  end
end

# CSV converters, used to transform cells when parsing the CSV
# 0 values are not valid in this case
# Data has not been provided if 0
CSV::Converters[:empty_data] = lambda do |data|
  (data == "0") ? nil : data
end

CSV::Converters[:true_indicator] = lambda do |data|
  (data.downcase == "si") ? true : data
end

CSV::Converters[:false_indicator] = lambda do |data|
  (data.downcase == "no") ? false : data
end

