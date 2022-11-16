class AddIndicatorToProviderRelation < ActiveRecord::Migration
  def change
    add_reference :provider_relations, :indicator, foreign_key: true
  end
end
