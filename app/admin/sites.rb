ActiveAdmin.register Site do
  # Specify parameters which should be permitted for assignment
  permit_params :zone_id, :name, :description, :address, :provider_id, :stype, :address_comp, :highway, :highway_km, :phone, :web, :email, :state_id, :is_active

  # or consider:
  #
  # permit_params do
  #   permitted = [:zone_id, :name, :description, :address, :provider_id, :stype, :address_comp, :highway, :highway_km, :phone, :web, :email, :state_id, :is_active]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :zone
  filter :name
  filter :description
  filter :address
  filter :provider
  filter :created_at
  filter :updated_at
  filter :stype
  filter :address_comp
  filter :highway
  filter :highway_km
  filter :phone
  filter :web
  filter :email
  filter :state
  filter :is_active

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :zone
    column :name
    column :description
    column :address
    column :provider
    column :created_at
    column :updated_at
    column :stype
    column :address_comp
    column :highway
    column :highway_km
    column :phone
    column :web
    column :email
    column :state
    column :is_active
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :zone
      row :name
      row :description
      row :address
      row :provider
      row :created_at
      row :updated_at
      row :stype
      row :address_comp
      row :highway
      row :highway_km
      row :phone
      row :web
      row :email
      row :state
      row :is_active
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :zone
      f.input :name
      f.input :description
      f.input :address
      f.input :provider
      f.input :stype
      f.input :address_comp
      f.input :highway
      f.input :highway_km
      f.input :phone
      f.input :web
      f.input :email
      f.input :state
      f.input :is_active
    end
    f.actions
  end
end
