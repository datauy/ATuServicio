class CompareController < ApplicationController
  layout 'atuservicio'

  def index
    provider_ids = params[:selected_providers].try(:split, " ") || []
    @selected_providers = Provider.find(provider_ids.take(3))
    @title = "Comparando"

    flash['alert'] = 'Solo se pueden elegir hasta 3 proveedores' if provider_ids.length > 3

    @groups = {
      estructura: 'estructura',
      metas: 'metas',
      precios: 'price',
      tiempos_espera: 'calendar',
      satisfaccion_derechos: 'derechos',
      rrhh: 'rrhh',
      solicitud_consultas: 'consultas'
    }

    respond_to do |format|
      format.html
      format.js
    end
  end
end
