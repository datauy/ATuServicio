ActiveAdmin.register WaitTime do
  # Specify parameters which should be permitted for assignment
  permit_params :provider_id, :speciality_id, :wtype, :value, :year, :period

  # or consider:
  #
  # permit_params do
  #   permitted = [:provider_id, :speciality_id, :wtype, :value, :year, :period]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :provider
  filter :speciality
  filter :wtype
  filter :value
  filter :created_at
  filter :updated_at
  filter :year
  filter :period

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :provider
    column :speciality
    column :wtype
    column :value
    column :created_at
    column :updated_at
    column :year
    column :period
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :provider
      row :speciality
      row :wtype
      row :value
      row :created_at
      row :updated_at
      row :year
      row :period
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :provider
      f.input :speciality
      f.input :wtype
      f.input :value
      f.input :year
      f.input :period
    end
    f.actions
  end
end
