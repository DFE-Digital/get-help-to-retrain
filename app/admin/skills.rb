if defined?(ActiveAdmin)
  ActiveAdmin.register Skill do
    actions :all, except: %i[new destroy]

    permit_params :name, :enabled

    filter :name

    index do
      column :id
      column :enabled
      column :name
      column :job_profiles
      column :created_at
      column :updated_at
      actions
    end

    controller do
      def scoped_collection
        super.includes :job_profiles
      end
    end

    csv do
      column :id
      column :enabled
      column :name
      column :job_profiles do |skill|
        skill.job_profiles.map(&:name)
      end
    end

    config.sort_order = 'id_asc'
  end
end
