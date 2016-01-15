class ProvidersController < ApplicationController
  autocomplete :provider, :nombre_completo, full: true

  def show
    @providers = Provider.all.map(&:nombre_abreviado)
    respond_to do |format|
      format.json
    end
  end
end
