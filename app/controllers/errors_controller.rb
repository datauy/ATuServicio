# coding: utf-8
class ErrorsController < ApplicationController
  layout 'atuservicio'

  def not_found
    @title = 'Página no encontrada'
    render status: 404
  end

  def internal_server_error
    @title = 'Error de servidor'
    render status: 500
  end
end
