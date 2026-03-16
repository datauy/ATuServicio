class AddParentZoneToZone < ActiveRecord::Migration[8.0]
  def change

    add_reference :zones, :parent_zone, foreign_key: { to_table: :zones }
  end
end
