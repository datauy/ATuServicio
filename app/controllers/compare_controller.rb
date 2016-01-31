# coding: utf-8
class CompareController < ApplicationController
  layout 'atuservicio'

  def index
    unless params[:selected_providers]
      flash['alert'] = "Debe elegir al menos un proveedor para ver los datos de comparación"
      redirect_to '/'
      return
    end
    provider_ids = params[:selected_providers].try(:split, ' ').try(:uniq) || []
    @selected_providers = Provider.includes([:sites, :states]).where(id: provider_ids.take(3))
    @title = 'Comparando'
    @description = 'Compará éstos prestadores de Salud para elegir informado o personalizalo para conocer a fondo los indicadores del tuyo.'

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
  rescue ActiveRecord::RecordNotFound
    redirect_to '/404'
  end

  def add
    selected_providers = "#{params[:selected_providers]} #{params[:provider_id]}".split(' ').uniq.join(' ')
    redirect_to action: 'index', selected_providers: selected_providers
  end
end
