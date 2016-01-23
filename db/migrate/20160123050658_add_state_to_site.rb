class AddStateToSite < ActiveRecord::Migration
  def change
    change_table :sites do |t|
      t.references :state
    end
  end
end
