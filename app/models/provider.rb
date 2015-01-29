class Provider < ActiveRecord::Base
  has_many :sites, dependent: :delete_all

  def average(name)
    columns = METADATA[:precios][:averages][name][:columns]
    values = columns.map do |column|
      self.send(column.to_sym)
    end

    # I cannot average unless I have all the data
    valid_values = values && !values.empty? && !values.include?(nil)
    values.reduce(:+).to_f / values.size if valid_values
  end
end
