class ProvidersController < ApplicationController
  def show
    @providers = Provider.all.map(&:nombre_abreviado)
    respond_to do |format|
      format.json
    end
  end
end
