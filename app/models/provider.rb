class Provider < ActiveRecord::Base
  has_many :sites, dependent: :delete_all

  def average(name)
    columns = METADATA[:precios][:averages][name][:columns]
    values = columns.map do |column|
      self.send(column.to_sym)
    end

    # I cannot average unless I have all the data
    valid_values = values && !values.empty? && !values.include?(nil)
    if valid_values
      average = values.reduce(:+).to_f / values.size
      average.round(2)
    end
  end

  # What coverage type exists by state
  def coverage_by_state(state, type)
    sites.where(departamento: state, nivel: type).count if state
  end

  def states
    sites.group(:departamento).count.keys
  end

  # scope
  # returns the providers list on that state
  def self.by_state(state)
    find(Site.by_state)
  end
end
