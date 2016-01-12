class CompareController < ApplicationController
  layout 'atuservicio'
  def index
    provider_ids = params[:selected_providers].try(:split, " ") || []
    @selected_providers = Provider.find(provider_ids.take(3))
    flash['alert'] = 'Solo se pueden elegir hasta 3 proveedores' if provider_ids.length > 3
    respond_to do |format|
      format.html
      format.js
    end
  end
end
