if defined?(ActiveAdmin)
  ActiveAdmin.register AdminRole do # rubocop:disable Metrics/BlockLength
    actions :all

    filter :name
    filter :display_name
    filter :resource_id

    permit_params :name, :display_name, :description, :resource_id

    index do
      column :id
      column :name
      column :display_name
      column :description
      column :resource_id
      column :created_at
      column :updated_at
    end

    csv do
      column :id
      column :name
      column :display_name
      column :description
      column :resource_id
      column :created_at
      column :updated_at
    end

    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :name
        f.input :display_name
        f.input :description
        f.input :resource_id
      end
      f.actions
    end

    config.sort_order = 'id_asc'
  end
end
