if defined?(ActiveAdmin)
  # rubocop:disable Metrics/BlockLength
  ActiveAdmin.register JobProfile do
    menu priority: 2

    actions :all, except: %i[new destroy]

    permit_params :recommended, :soc, :extended_soc, :growth, :hidden_titles, :specialism

    filter :categories
    filter :skills
    filter :related_job_profiles
    filter :extended_soc
    filter :slug
    filter :name
    filter :source_url
    filter :description
    filter :recommended
    filter :content
    filter :salary_min
    filter :salary_max
    filter :alternative_titles
    filter :hidden_titles
    filter :specialism

    index do
      column :id
      column :extended_soc
      column :slug
      column :name
      column :recommended
      column :salary_min
      column :salary_max
      column :growth
      column :alternative_titles
      column :hidden_titles
      column :specialism
      actions
    end

    show do
      attributes_table do
        row :soc
        row :extended_soc
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
        row :growth
        row :alternative_titles
        row :hidden_titles
        row :specialism
      end
    end

    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :soc
        f.input :extended_soc
        f.input :slug, input_html: { disabled: true, readonly: true }
        f.input :name, input_html: { disabled: true, readonly: true }
        f.input :source_url, input_html: { disabled: true, readonly: true }
        f.input :description, input_html: { disabled: true, readonly: true }
        f.input :salary_min, input_html: { disabled: true, readonly: true }
        f.input :salary_max, input_html: { disabled: true, readonly: true }
        f.input :growth
        f.input :alternative_titles, input_html: { disabled: true, readonly: true }
        f.input :hidden_titles
        f.input :specialism
        f.input :recommended
      end
      f.actions
    end

    controller do
      def scoped_collection
        super.includes :skills
      end
    end

    csv do
      column :id
      column :soc
      column :extended_soc
      column :slug
      column :name
      column :recommended
      column :salary_min
      column :salary_max
      column :growth
      column :alternative_titles
      column :hidden_titles
      column :specialism
      column :skills do |job_profile|
        job_profile.skills.map(&:name)
      end
    end

    config.sort_order = 'id_asc'
  end
  # rubocop:enable Metrics/BlockLength
end
