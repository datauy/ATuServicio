class CreateImaes < ActiveRecord::Migration
  def change
    create_table :imaes do |t|
      t.string :nombre
      t.timestamps null: false
    end
  end
end
