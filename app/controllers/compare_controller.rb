class CompareController < ApplicationController
  def index
    provider_ids = *params[:id].split("/")
    @providers = Provider.find(provider_ids)
  end

  # def compare_params
  #   params.require(:compare).permit(:id)
  # end
end
