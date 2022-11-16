class Provider < ActiveRecord::Base
  has_many :sites, dependent: :delete_all
  has_many :states, through: :sites
  has_many :recognitions
  has_many :provider_relations
  has_many :indicators, through: :provider_relations
  has_many :specialists, through: :provider_relations


  def average(name)
    columns = METADATA[:precios][:averages][name][:columns]
    values = columns.map do |column|
      send(column.to_sym)
    end

    # I cannot average unless I have all the data
    valid_values = values && !values.empty? && !values.include?(nil)
    if valid_values
      (values.reduce(:+).to_f / values.size).round(2)
    else
      nil
    end
  end

  def asse?
    nombre_abreviado.include?('ASSE')
  end

  # What coverage type exists by state
  def coverage_by_state(state, type)
    sites.where(state: state, nivel: type).count
  end

  def sites_by_state(state)
    sites.where(departamento: state.proper_name).order(localidad: :asc)
  end

  def states_names
    states.uniq.map(&:name).map do |names| # Get state names
      names.split(StringConstants::SPACE).map do |n| # Separate array to capitalize
        n.capitalize
      end.join(StringConstants::SPACE) # Join two word States
    end.join(StringConstants::COMMA + StringConstants::SPACE) # Comma separate States
  end
end
