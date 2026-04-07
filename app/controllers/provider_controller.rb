class ProviderController < ApplicationController

  def details
    @headers = 1
    p = Provider.find(params[:id])
    if p.present?
      @s = []
      Section.where(is_active: true).order(:weight).each do |s|
        data = []
        case s.name
        when 'general'
          data = p.provider_data.find_by(year: s.year, period: s.period)
        end
        section = s.serializable_hash
        section['data'] = data
        @s.push(section) 
      end
      @providers = [p]
    else
      render :file => "#{Rails.root}/public/404.html",  :status => 404
    end
  end

  def compare
    @headers = 1
    @providers = Provider.where(id: [params[:id1], params[:id2]])
    if @providers.length > 1
      @s = []
      Section.where(is_active: true).order(:weight).each do |s|
        data = []
        @providers.each do |p|
          case s.name
          when 'general'
            datum = p.provider_data.find_by(year: s.year, period: s.period)
          when 'prices'
            datum = {fonasa:{}, no_fonasa: {}}
            p.provider_prices.where(year: s.year, period: s.period).each do |pp|
              if pp.fonasa
                datum[:fonasa][pp.price_id] = pp.value
              else
                datum[:no_fonasa][pp.price_id] = pp.value
              end
            end
          when 'goals', 'rrhh', 'rrhh_cad'
            datum = p.provider_indicators.
            includes(:indicator).
            where('indicator.section_id': s.id, year: s.year, period: s.period).
            pluck(:indicator_id, :value).to_h
          when 'specialists'
            datum = p.provider_specialists.
            where( year: s.year, period: s.period).
            pluck(:speciality_id, :value).to_h
          end
          data.push(datum)
        end
        section = s.serializable_hash
        section['data'] = data
        @s.push(section)
      end
    else
      render :file => "#{Rails.root}/public/404.html",  :status => 404
    end
  end

  def search
    @errors = []
    @list = Provider.where( "name like ?" , params[:name] ).pluck(:id, :short_name).to_h
    respond_to do |format|
      format.turbo_stream
    end
  end

  def get_summary
    @errors = []
    @provider = Provider.find(params[:id])
    respond_to do |format|
      format.turbo_stream
    end
  end
end
