class CreateRecognition < ActiveRecord::Migration
  def change
    create_table :recognitions do |t|
      t.string :recognition
      t.references :provider
      t.references :state
      t.string :institution
      t.integer :year
      t.string :practice
      t.integer :icon
      t.string :link
    end
  end
end
