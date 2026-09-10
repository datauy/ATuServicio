ActiveAdmin.register Datum do
  # Specify parameters which should be permitted for assignment
  permit_params :title, :description, :key, :is_active, :dtype, :icon

  # or consider:
  #
  # permit_params do
  #   permitted = [:title, :description, :key, :is_active, :dtype]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # For security, limit the actions that should be available
  actions :all, except: []

  # Add or remove filters to toggle their visibility
  filter :id
  filter :title
  filter :description
  filter :key
  filter :is_active
  filter :created_at
  filter :updated_at
  filter :dtype

  # Add or remove columns to toggle their visibility in the index action
  index do
    selectable_column
    id_column
    column :icon do |l|
      image_tag url_for(l.icon) if l.icon.attached?
    end
    column :title
    column :description
    column :key
    column :is_active
    column :created_at
    column :updated_at
    column :dtype
    actions
  end

  # Add or remove rows to toggle their visibility in the show action
  show do
    attributes_table_for(resource) do
      row :id
      row :title
      row :description
      row :key
      row :is_active
      row :created_at
      row :updated_at
      row :dtype
    end
  end

  # Add or remove fields to toggle their visibility in the form
  form do |f|
    f.semantic_errors(*f.object.errors.attribute_names)
    f.inputs do
      f.input :title
      f.input :description
      f.input :key
      f.input :is_active
      f.input :dtype
      f.input :icon, as: :file
      if f.object.icon.attached?
        li do
          div do
            image_tag(f.object.icon)
          end
          div do
            a "Borrar", href: delete_image_admin_datum_path, method: :delete, "data-confirm": "Confirme que desea eliminarla"
          end
        end
      end
    end
    f.actions
  end
  member_action :delete_image, method: [:delete, :get] do
    if resource.icon.attached?
      resource.icon.delete
    end
    redirect_to edit_resource_path, notice: "Imagen borrada"
  end
end
