class AddPrivateInsuranceToProvider < ActiveRecord::Migration[8.0]
  def change
    add_column :providers, :private_insurance, :boolean
  end
end
