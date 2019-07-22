if defined?(ActiveAdmin)
  ActiveAdmin.register Skill do
    actions :index

    filter :name

    index do
      column :id
      column :name
      column :created_at
      column :updated_at
    end
  end
end
