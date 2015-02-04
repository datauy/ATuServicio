module CompareHelper
  def title(group)
    METADATA[group][:title]
  end

  def site_column_exceptions
    [:id, :provider_id, :created_at, :updated_at, :direccion,
     :departamento, :localidad, :nivel, :servicio_de_urgencia]
  end

  def ticket_prices
    METADATA[:precios][:columns]
  end
end
