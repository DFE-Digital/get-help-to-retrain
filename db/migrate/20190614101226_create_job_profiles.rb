class CreateJobProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :slug, index: { unique: true }
      t.string :name
      t.string :source_url
      t.timestamps
    end

    create_table :job_profiles do |t|
      t.string :slug, index: { unique: true }
      t.string :name
      t.string :source_url
      t.string :description
      t.string :salary_range
      t.boolean :recommended, default: false
      t.text :content
      t.timestamps
    end

    create_table :skills do |t|
      t.string :name, index: true
      t.timestamps
    end

    create_table :job_profile_categories do |t|
      t.belongs_to :job_profile, index: true
      t.belongs_to :category, index: true
      t.timestamps
    end

    create_table :job_profile_skills do |t|
      t.belongs_to :job_profile, index: true
      t.belongs_to :skill, index: true
      t.boolean :required, default: true
      t.timestamps
    end
  end
end
