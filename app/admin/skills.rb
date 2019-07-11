ActiveAdmin.register Skill do
  menu priority: 3

  actions :index

  filter :name

  index do
    column :id
    column :name
    column :created_at
    column :updated_at
  end
end
