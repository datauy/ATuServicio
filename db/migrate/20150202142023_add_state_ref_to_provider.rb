class AddStateRefToProvider < ActiveRecord::Migration
  def change
    add_reference :providers, :state, index: true
    add_foreign_key :providers, :states
  end
end
