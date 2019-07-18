ActiveAdmin.register Category do
  actions :index

  filter :slug
  filter :name
  filter :source_url

  index do
    column :id
    column :slug
    column :name
    column :created_at
    column :updated_at
  end
end
