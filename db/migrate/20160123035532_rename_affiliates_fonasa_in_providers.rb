class RenameAffiliatesFonasaInProviders < ActiveRecord::Migration
  def change
    rename_column :providers, :fonasa_affiliates, :afiliados_fonasa
  end
end
