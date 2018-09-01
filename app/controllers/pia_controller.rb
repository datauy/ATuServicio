class PiaController < ApplicationController
  layout 'atuservicio'
  autocomplete :pia, :titulo, full: true, limit: 15

  def index
    @title = 'Catálogo Prestaciones'

    if params[:category]
      $category = params[:category]
      @pia = Pia.where('pid LIKE ? OR pid = ? OR ancestry LIKE ? OR ancestry = ?', "#{$category}.%", $category, "#{$category}%", $category).arrange
    else
      @pia = Pia.all.arrange
    end

    @categories = Pia.all.where(ancestry: nil).order(:pid)
  end

  def autocomplete_pia_titulo
    term = params[:term]
    @pias = []
    puts $cat
    if $category 
      @pias = Pia.where('(pid LIKE ? OR pid = ? OR ancestry LIKE ? OR ancestry = ?) AND lower(titulo) LIKE  lower(?)', "#{$category}.%", $category, "#{$category}%", $category, "%#{term}%").order(:titulo).all
    else
      @pias = Pia.where('lower(titulo) LIKE lower(?)', "%#{term}%").order(:titulo).all
    end
    render :json => @pias.map { |product| {:id => product.pid, :label => product.titulo, :value => product.titulo} }
  end

end