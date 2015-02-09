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

  def is_private_insurance?
    nombre_abreviado.include?('Seguro Privado')
  end

  def is_asse?
    nombre_abreviado.include?("ASSE")
  end

  # What coverage type exists by state
  def coverage_by_state(state, type)
    sites.where(departamento: State.proper_name(state), nivel: type).count if state
  end

  def states
    sites.group(:departamento).count.keys
  end

  def sites_by_state(state)
    sites.where(departamento: State.proper_name(state)).order(localidad: :asc)
  end

  # scope
  # returns the providers list on that state
  def self.by_state(state)
    find(Site.providers_by_state)
  end
end
