ActiveAdmin.register GeoEntity do
  # Specify parameters which should be permitted for assignment
  permit_params :gtype, :name, :description, :zone_id, :is_active, :site_id

  # or consider:
  #
  # permit_params do
  #   permitted = [:gtype, :name, :description, :zone_id, :is_active, :site_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :gtype
  filter :name
  filter :description
  filter :zone
  filter :created_at
  filter :updated_at
  filter :is_active
  filter :site

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :gtype
    column :name
    column :description
    column :zone
    column :created_at
    column :updated_at
    column :is_active
    column :site
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :gtype
      row :name
      row :description
      row :zone
      row :created_at
      row :updated_at
      row :is_active
      row :site
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :gtype
      f.input :name
      f.input :description
      f.input :zone
      f.input :is_active
      f.input :site
    end
    f.actions
  end
end
