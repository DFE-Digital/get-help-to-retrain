class AddJobProfilesV2 < ActiveRecord::Migration[6.0]
  def change
    create_table :v2_job_profiles do |t|
      t.string :slug, index: { unique: true }
      t.string :name
      t.string :source_url
      t.string :description
      t.boolean :recommended, default: false
      t.jsonb :content, null: false, default: '{}'
      t.datetime :last_updated
      t.integer :salary_min
      t.integer :salary_max
      t.string :alternative_titles
      t.string :soc
      t.string :onet_occupation_code
      t.timestamps
    end


    create_table :v2_skills do |t|
      t.string :name, index: true
      t.decimal :onet_rank
      t.string :onet_element_id
      t.string :onet_attribute_type
      t.string :level
      t.timestamps
    end

    create_table :v2_job_profile_skills do |t|
      t.belongs_to :v2_job_profile, index: true
      t.belongs_to :v2_skill, index: true
      t.boolean :required, default: true
      t.timestamps
    end
  end
end
