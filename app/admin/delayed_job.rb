if defined?(ActiveAdmin)
  ActiveAdmin.register Delayed::Job do
    actions :index

    filter :slug
    filter :name
    filter :source_url

    index do
      column :id
      column :priority
      column :attempts
      column :handler
      column :last_error
      column :run_at
      column :locked_at
      column :failed_at
      column :locked_by
      column :queue
      column :created_at
      column :updated_at
    end

    config.sort_order = 'id_asc'
  end
end
