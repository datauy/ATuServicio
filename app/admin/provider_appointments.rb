ActiveAdmin.register ProviderAppointment do
  # Specify parameters which should be permitted for assignment
  permit_params :provider_id, :year, :period, :means, :reminder, :withdraw, :communication

  # or consider:
  #
  # permit_params do
  #   permitted = [:provider_id, :year, :period, :means, :reminder, :withdraw, :communication]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :provider
  filter :year
  filter :period
  filter :means
  filter :reminder
  filter :withdraw
  filter :communication
  filter :created_at
  filter :updated_at

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :provider
    column :year
    column :period
    column :means
    column :reminder
    column :withdraw
    column :communication
    column :created_at
    column :updated_at
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :provider
      row :year
      row :period
      row :means
      row :reminder
      row :withdraw
      row :communication
      row :created_at
      row :updated_at
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :provider
      f.input :year
      f.input :period
      f.input :means
      f.input :reminder
      f.input :withdraw
      f.input :communication
    end
    f.actions
  end
end
