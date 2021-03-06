if defined?(ActiveAdmin)
  ActiveAdmin.register Category do
    actions :index

    filter :slug
    filter :name
    filter :source_url

    index do
      column :id
      column :slug
      column :name
    end

    config.sort_order = 'id_asc'
  end
end
