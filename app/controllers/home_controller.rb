class HomeController < ApplicationController
  def index
    @providers = Provider.all
  end
end
