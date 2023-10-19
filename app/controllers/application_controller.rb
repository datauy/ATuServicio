class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  caches_action :load_options

  before_filter :load_options

  def load_options
    @year = 2023
    @stage = 2
    @providers ||= Provider.includes(:states).all
    @states ||= State.all
  end
end
