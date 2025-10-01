ActiveAdmin.register Provider do
  # Specify parameters which should be permitted for assignment
  permit_params :external_id_id, :short_name, :name, :web, :description, :active

  # or consider:
  #
  # permit_params do
  #   permitted = [:external_id_id, :short_name, :name, :web, :description, :active]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :external_id
  filter :short_name
  filter :name
  filter :web
  filter :description
  filter :created_at
  filter :updated_at
  filter :active

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :external_id
    column :short_name
    column :name
    column :web
    column :description
    column :created_at
    column :updated_at
    column :active
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :external_id
      row :short_name
      row :name
      row :web
      row :description
      row :created_at
      row :updated_at
      row :active
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :external_id
      f.input :short_name
      f.input :name
      f.input :web
      f.input :description
      f.input :active
    end
    f.actions
  end
end
