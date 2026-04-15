ActiveAdmin.register Section do
  # Specify parameters which should be permitted for assignment
  permit_params :title, :name, :description, :year, :period, :is_home_card, :weight, :is_active, :info

  # or consider:
  #
  # permit_params do
  #   permitted = [:title, :name, :description, :year, :period, :is_home_card, :weight, :is_active, :info]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :name
  filter :description
  filter :year
  filter :period
  filter :is_home_card
  filter :created_at
  filter :updated_at
  filter :weight
  filter :is_active
  filter :info

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :title
    column :name
    column :description
    column :year
    column :period
    column :is_home_card
    column :created_at
    column :updated_at
    column :weight
    column :is_active
    column :info
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :title
      row :name
      row :description
      row :year
      row :period
      row :is_home_card
      row :created_at
      row :updated_at
      row :weight
      row :is_active
      row :info
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :title
      f.input :name
      f.input :description
      f.input :year
      f.input :period
      f.input :is_home_card
      f.input :weight
      f.input :is_active
      f.input :info
    end
    f.actions
  end
end
