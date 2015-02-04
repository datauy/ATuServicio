# coding: utf-8
class State
  def self.all
    ["Artigas", "Canelones", "Cerro Largo", "Colonia", "Durazno", "Flores", "Florida", "Lavalleja", "Maldonado", "Montevideo", "Paysandú", "Rivera", "Rocha", "Río Negro", "Salto", "San José", "Soriano", "Tacuarembó", "Treinta Y Tres"]
  end

  def self.proper_name(state)
    unless state[0] == state[0].upcase
      state = state.split("_").map(&:capitalize).join(" ")
    end
    state
  end
end
