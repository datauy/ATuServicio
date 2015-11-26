class HomeController < ApplicationController
  def index
    # Get the ProviderMaximum object which contains all the maximum
    # values to compare in the graphs in the home view.
    @provider_maximums = Rails.cache.fetch('provider_maximums', expires_in: 120.hours) do
      ProviderMaximum.first
    end

    # Get the selected state if we want to have the providers for a
    # given state
    @selected_state = params['departamento']

    @sel_providers = if @selected_state && @selected_state != 'todos'
                       @providers.where(
                         id: Site.providers_by_state(@selected_state)
                       ).order(:private_insurance).order(:nombre_abreviado)
                     else
                       @providers.order(:private_insurance).order(:nombre_abreviado)
                     end
  end
end
