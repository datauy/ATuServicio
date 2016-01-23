class AddFonasaDiscriminationToAffiliatesInProvider < ActiveRecord::Migration
  def change
    add_column :providers, :fonasa_affiliates, :integer
  end
end
