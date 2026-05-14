class AddStateToSite < ActiveRecord::Migration[8.0]
  def change
    add_reference :sites, :state, foreign_key: { to_table: :zones }
  end
end
