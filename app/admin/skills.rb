if defined?(ActiveAdmin)
  ActiveAdmin.register Skill do
    actions :index

    filter :name

    index do
      column :id
      column :enabled
      column :name
      column :job_profiles
      column :created_at
      column :updated_at
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
  end
end
