ActiveAdmin.register News do
  # Specify parameters which should be permitted for assignment
  permit_params :head, :title, :description, :link, :is_active

  # or consider:
  #
  # permit_params do
  #   permitted = [:head, :title, :description, :link, :is_active]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :head
  filter :title
  filter :description
  filter :link
  filter :created_at
  filter :updated_at
  filter :is_active

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :head
    column :title
    column :description
    column :link
    column :created_at
    column :updated_at
    column :is_active
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :head
      row :title
      row :description
      row :link
      row :created_at
      row :updated_at
      row :is_active
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :head
      f.input :title
      f.input :description
      f.input :link
      f.input :is_active
    end
    f.actions
  end
end
