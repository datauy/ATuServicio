class ProvidersController < ApplicationController
  autocomplete :provider, :search_name, full: true, limit: 15

  def show
    @providers = Provider.all.map(&:nombre_abreviado)
    respond_to do |format|
      format.json
    end
  end
end
