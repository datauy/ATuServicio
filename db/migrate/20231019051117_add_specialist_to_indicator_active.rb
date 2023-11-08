class AddSpecialistToIndicatorActive < ActiveRecord::Migration
    def change
        add_reference :indicator_actives, :specialist, index: false, foreign_key: true
    end
end
  