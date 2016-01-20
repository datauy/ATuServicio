class AddStateIdToSite < ActiveRecord::Migration
  def change
    change_table :sites do |t|
      t.references :states
    end
  end
end
