# coding: utf-8
class State
  def self.all
    ["Artigas", "Canelones", "Cerro Largo", "Colonia", "Durazno", "Flores", "Florida", "Lavalleja", "Maldonado", "Montevideo", "Paysandú", "Rivera", "Rocha", "Río Negro", "Salto", "San José", "Soriano", "Tacuarembó", "Treinta Y Tres"]
  end

  def self.proper_name(state)
    state.split("_").map(&:capitalize).join(" ")
  end
end
