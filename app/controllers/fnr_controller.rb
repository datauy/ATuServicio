# coding: utf-8
class FnrController < ApplicationController
  layout 'atuservicio'

  def index
    @title = 'FNR'
    @description = 'Conocé los tiempos de espera que hay para cualquier operación financiada através del Fondo Nacional de Recursos, así como otros datos útiles.'
    @resource = 'dd3046c9-06eb-490e-be95-ba58feb25b5e'
    @interventions_query = Intervention.select("imae_id, count(*) as qtty, sum(realizado - autorizado) as wait").includes(:imae).group(:imae_id)
    @interventions = @interventions_query.map { |i| { count: i.qtty, groupName: i.imae.nombre, averageTime: i.wait } }
    Rails.logger.info "\n\nFNR\n\n"
    Rails.logger.info @interventions.to_json
    @areas = InterventionArea.all
    # TODO: Filtrar dinámicos los tipos
    @types = InterventionType.all
  end

end
