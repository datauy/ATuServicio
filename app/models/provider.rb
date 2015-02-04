class Provider < ActiveRecord::Base
  has_many :sites, dependent: :delete_all
  has_many :provider_state_infos
  has_many :states, through: :provider_state_infos

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

  # def states
  #   sites.group(:departamento).count.keys
  # end

  def sites_by_state(state)
    sites.where(departamento: state).order(localidad: :asc)
  end

  # scope
  # returns the providers list on that state
  # def self.by_state(state)
  #   
  # end

  def self.maximums
    all.map do |provider|
      provider.sums_provider
    end.compact.max
  end

  def sums_provider
    ['medicina_general', 'pediatria', 'cirugia_general', 'ginecotocologia', 'medico_referencia'].map do |field|
      send("tiempo_espera_#{field}".to_sym) if send("datos_suficientes_tiempo_espera_#{field}".to_sym)
    end.compact.reduce(:+)
  end

  def self.sum_tickets
    max = 0
    Provider.all.each do |p|
      sum = 0
      [:medicamentos, :tickets, :tickets_urgentes, :estudios].each do |a|
        if p.average(a)
          sum += p.average(a)
        end
      end
      if sum > max
        max = sum
      end
    end
    max
  end
end
