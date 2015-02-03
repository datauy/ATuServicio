class HomeController < ApplicationController
  def index
    @sel_providers = @providers
    @selected_state = params['departamento']
    @sel_providers = @sel_providers.where(id: @selected_state.providers) if @selected_state

    # order
    name_order = params['nombre'].try(:downcase).try(:to_sym)
    @sel_providers = @sel_providers.order(nombre_completo: name_order) if [:asc, :desc].include?(name_order)
  end
end
