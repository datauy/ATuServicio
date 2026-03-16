class PagesController < ApplicationController
  def index
    @providers = []

    sections = Section.where(is_home_card: true, is_active: true).order(:weight)
    Provider.where(active: true).each do |p|
      @cards = []
      sections.each do |s|
        card = {
          title: s.title,
          name: s.name,
          year: s.year,
          period: s.period
        }
        case s.name
        when 'general'
          # general data card
          data = p.provider_datum.where(year: s.year, period: s.period).last
          card['total'] = data.present? && data.total.present? ? data.total : "No hay datos"
          card['fonasa_users'] = data.present? && data.fonasa_users.present? ? data.fonasa_users : "No hay datos"
          card['no_fonasa_users'] = data.present? && data.no_fonasa_users.present? ? data.no_fonasa_users : "No hay datos"

        when 'wait'
          # wait card FIXED times

        when 'prices'
          # prices card
        end
        @cards.push(card)
      end
      provider = p.serializable_hash
      provider[:cards] = @cards
      @providers.push(provider)
    end
  end
end
