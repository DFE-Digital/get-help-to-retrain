class CreateJobProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :slug, index: true
      t.string :name
      t.string :source_url
      t.timestamps
    end

    create_table :job_profiles do |t|
      t.string :slug, index: true
      t.string :name
      t.string :source_url
      t.string :description
      t.boolean :recommended, default: true
      t.text :content
      t.timestamps
    end

    add_index :job_profiles, [:recommended, :name]

    create_table :categories_job_profiles do |t|
      t.references :job_profile, foreign_key: true
      t.references :category, foreign_key: true
    end

    create_table :skills do |t|
      t.string :name, index: true
      t.timestamps
    end

    create_table :job_profiles_skills do |t|
      t.references :job_profile, foreign_key: true
      t.references :skill, foreign_key: true
      t.timestamps
    end
  end
end
