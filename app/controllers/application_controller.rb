class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  caches_action :load_options

  before_filter :load_options

  def load_options
    @states ||= State.all
    @providers ||= Provider.all
  end

  def order_providers(providers)
    providers = providers.order(:nombre_abreviado)
    # We discriminate private insurances since they're different:
    l = lambda { |a| a.is_private_insurance? }
    private_insurances = providers.select &l
    providers = providers.reject &l
    providers + private_insurances
  end
end
