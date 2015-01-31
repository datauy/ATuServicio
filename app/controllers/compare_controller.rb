class CompareController < ApplicationController
  def index
    provider_ids = params[:id] || []
    @selected_providers = Provider.find(provider_ids)
    flash['alert'] = 'Solo se pueden elegir hasta 3 proveedores' if provider_ids.length > 3
  end
end
