ActiveAdmin.register ProviderDatum do
  # Specify parameters which should be permitted for assignment
  permit_params :year, :period, :fonasa_users, :no_fonasa_users, :total, :provider_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:year, :period, :fonasa_users, :no_fonasa_users, :total, :provider_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :year
  filter :period
  filter :fonasa_users
  filter :no_fonasa_users
  filter :total
  filter :provider
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :year
    column :period
    column :fonasa_users
    column :no_fonasa_users
    column :total
    column :provider
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :year
      row :period
      row :fonasa_users
      row :no_fonasa_users
      row :total
      row :provider
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :year
      f.input :period
      f.input :fonasa_users
      f.input :no_fonasa_users
      f.input :total
      f.input :provider
    end
    f.actions
  end
end
