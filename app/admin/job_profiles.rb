ActiveAdmin.register JobProfile do
  menu priority: 2

  actions :all, except: [:new, :destroy]

  permit_params :recommended

  filter :categories
  filter :skills
  filter :related_job_profiles
  filter :slug
  filter :name
  filter :source_url
  filter :description
  filter :recommended
  filter :content
  filter :salary_min
  filter :salary_max
  filter :alternative_titles

  index do
    column :id
    column :slug
    column :name
    column :recommended
    column :created_at
    column :updated_at
    column :salary_min
    column :salary_max
    column :alternative_titles
    actions
  end

  show do
    attributes_table do
      row :slug
      row :name
      row :source_url
      row :description
      row :recommended
      row :content do |job_profile|
        div class: 'content-preview' do
          simple_format job_profile.content
        end
      end
      row :created_at
      row :updated_at
      row :salary_min
      row :salary_max
      row :alternative_titles
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :slug, input_html: { disabled: true, readonly: true }
      f.input :name, input_html: { disabled: true, readonly: true }
      f.input :source_url, input_html: { disabled: true, readonly: true }
      f.input :description, input_html: { disabled: true, readonly: true }
      f.input :salary_min, input_html: { disabled: true, readonly: true }
      f.input :salary_max, input_html: { disabled: true, readonly: true }
      f.input :alternative_titles, input_html: { disabled: true, readonly: true }
      f.input :recommended
    end
    f.actions
  end
end
