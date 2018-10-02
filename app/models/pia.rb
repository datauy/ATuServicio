# frozen_string_literal: true

class Pia < ActiveRecord::Base
  has_ancestry

  def as_json(*)
    {
      id: id,
      titulo: titulo,
      informacion: informacion,
      normativa: normativa,
      normativa_url: normativa_url
    }
  end
end
