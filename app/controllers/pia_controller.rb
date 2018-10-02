class PiaController < ApplicationController
  layout 'atuservicio'
  autocomplete :pia, :titulo, full: true, limit: 15

  def index
    respond_to do |format|
      format.html {
        @title = 'Catálogo Prestaciones'

        if params[:category]
          $category = params[:category]
          @pia = Pia.where('pid LIKE ? OR pid = ? OR ancestry LIKE ? OR ancestry = ?', "#{$category}.%", $category, "#{$category}%", $category).arrange(:order => :orden)
        else
          @pia = Pia.all.arrange(order: :orden)
        end

        @categories = Pia.all.where(ancestry: nil).order(:pid)
      }
      format.json { render json: Pia.all.order(:orden).map(&:as_json) }
    end
  end

  def autocomplete_pia_titulo
    term = params[:term]
    @pias = []
    puts $cat
    if $category
      @pias = Pia.where('(pid LIKE ? OR pid = ? OR ancestry LIKE ? OR ancestry = ?) AND lower(titulo) LIKE  lower(?)', "#{$category}.%", $category, "#{$category}%", $category, "%#{term}%").order(:orden).all
    else
      @pias = Pia.where('lower(titulo) LIKE lower(?)', "%#{term}%").order(:orden).all
    end
    render json: @pias.map { |product| {id: product.pid, label: product.titulo, value: product.titulo} }
  end
end
