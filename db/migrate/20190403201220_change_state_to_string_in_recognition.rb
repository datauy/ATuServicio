class ChangeStateToStringInRecognition < ActiveRecord::Migration
  def change
    remove_column :recognitions, :state_id
    add_column :recognitions, :state, :string
  end
end
