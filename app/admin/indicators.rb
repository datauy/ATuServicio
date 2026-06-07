ActiveAdmin.register Indicator do
  # Specify parameters which should be permitted for assignment
  permit_params :key, :description, :section, :abbr, :is_active, :section_id, :title, :weight, :max_value

  # or consider:
  #
  # permit_params do
  #   permitted = [:key, :description, :section, :abbr, :is_active, :section_id, :title, :weight, :max_value]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :key
  filter :description
  filter :created_at
  filter :updated_at
  filter :section
  filter :abbr
  filter :is_active
  filter :section
  filter :title
  filter :weight
  filter :max_value

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :key
    column :description
    column :created_at
    column :updated_at
    column :section
    column :abbr
    column :is_active
    column :section
    column :title
    column :weight
    column :max_value
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :key
      row :description
      row :created_at
      row :updated_at
      row :section
      row :abbr
      row :is_active
      row :section
      row :title
      row :weight
      row :max_value
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :key
      f.input :description
      f.input :section
      f.input :abbr
      f.input :is_active
      f.input :section
      f.input :title
      f.input :weight
      f.input :max_value
    end
    f.actions
  end
end
