class AddNotNullConstraintToImaesNombre < ActiveRecord::Migration
  def up
    change_column_null :imaes, :nombre, false
  end
  def down
    change_column_null :imaes, :nombre, true
  end
end
