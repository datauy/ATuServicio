class PagesController < ApplicationController
  def index
    @providers = Provider.where(active: true)
  end
end
