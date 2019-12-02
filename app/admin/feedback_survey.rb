if defined?(ActiveAdmin)
  ActiveAdmin.register FeedbackSurvey do
    actions :index

    filter :page_useful

    index do
      column :id
      column :page_useful
      column :message
      column :url
      column :created_at
      column :updated_at
    end

    csv do
      column :id
      column :page_useful
      column :message
      column :url
      column :created_at
      column :updated_at
    end

    config.sort_order = 'id_asc'
  end
end
