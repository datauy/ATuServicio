class CreatePia < ActiveRecord::Migration
  def change
    create_table :pia, id:false, primary_key: :pid do |t|
      t.string :pid
      t.string :titulo
      t.string :cie_9
      t.string :informacion
      t.string :normativa
      t.string :normativa_url
      t.string :snomed
      t.string :ancestry
    end    
    execute "ALTER TABLE pia ADD PRIMARY KEY (pid);"
    add_index :pia, :ancestry
  end
end
