ActiveAdmin.register SiteDatum do
  # Specify parameters which should be permitted for assignment
  permit_params :datum_id, :site_id, :year, :period, :level, :value, :text

  # or consider:
  #
  # permit_params do
  #   permitted = [:datum_id, :site_id, :year, :period, :level, :value, :text]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :datum
  filter :site
  filter :year
  filter :period
  filter :created_at
  filter :updated_at
  filter :level
  filter :value
  filter :text

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :datum
    column :site
    column :year
    column :period
    column :created_at
    column :updated_at
    column :level
    column :value
    column :text
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :datum
      row :site
      row :year
      row :period
      row :created_at
      row :updated_at
      row :level
      row :value
      row :text
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :datum
      f.input :site
      f.input :year
      f.input :period
      f.input :level
      f.input :value
      f.input :text
    end
    f.actions
  end
end
