class HomeController < ApplicationController
  def index
    @sel_providers = @providers
    @selected_state = params['departamento']

    if @selected_state && @selected_state != 'todos'
      @sel_providers = @sel_providers.where(id: Site.providers_by_state(@selected_state))
    end


    Rails.cache.fetch("departamentos", expires_in: 12.hours) do
      @states = State.all
    end

    # order
    name_order = params['nombre'].try(:downcase).try(:to_sym)
    @sel_providers = @sel_providers.order(nombre_completo: name_order) if [:asc, :desc].include?(name_order)
  end
end
