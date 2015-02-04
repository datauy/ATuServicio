class CreateProviderStateInfos < ActiveRecord::Migration
  def change
    create_table :provider_state_infos do |t|
      t.references :provider, index: true
      t.references :state, index: true
      t.integer :primaria
      t.integer :secundaria
      t.integer :ambulatorio
      t.boolean :urgencia
    end
  end
end
