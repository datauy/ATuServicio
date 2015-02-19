class HomeController < ApplicationController
  def index
    @provider_maximums = Rails.cache.fetch("provider_maximums", expires_in: 120.hours) do
      ProviderMaximum.first
    end
    @selected_state = params['departamento']
    @sel_providers = if @selected_state && @selected_state != 'todos'
                       order_providers(
                         @providers.where( id: Site.providers_by_state(@selected_state) )
                       )
                     else
                       order_providers(@providers)
                     end

    @states = Rails.cache.fetch("departamentos", expires_in: 120.hours) do
      State.all
    end

    # order
    name_order = params['nombre'].try(:downcase).try(:to_sym)
    @sel_providers = @sel_providers.order(nombre_abreviado: name_order) if [:asc, :desc].include?(name_order)
  end
end
