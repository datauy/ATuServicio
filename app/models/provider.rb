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

  def self.maximums
    Rails.cache.fetch("maximus_provider", expires_in: 12.hours) do
      all.map do |provider|
        provider.sums_provider
      end.compact.max
    end
  end

  def sums_provider
    ['medicina_general', 'pediatria', 'cirugia_general', 'ginecotocologia', 'medico_referencia'].map do |field|
      send("tiempo_espera_#{field}".to_sym) if send("datos_suficientes_tiempo_espera_#{field}".to_sym)
    end.compact.reduce(:+)
  end

  def self.sum_tickets
    Rails.cache.fetch("sum_provider_tickets", expires_in: 12.hours) do
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

  def self.sums_personnel
    Rails.cache.fetch("sum_provider_personnel", expires_in: 120.hours) do
      max = 0
      Provider.all.each do |p|
        sum = 0
        [:medicos_generales_policlinica,
         :medicos_de_familia_policlinica,
         :medicos_pediatras_policlinica,
         :medicos_ginecologos_policlinica,
         :auxiliares_enfermeria_policlinica,
         :licenciadas_enfermeria_policlinica].each do |a|
          value = p.send(a).to_f
          if value.is_a? Numeric
            sum += p.send(a).to_f
          end
        end
        if sum > max
          max = sum
        end
      end
      max
    end
  end
end
