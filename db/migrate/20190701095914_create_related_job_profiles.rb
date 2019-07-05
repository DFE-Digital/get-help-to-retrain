class CreateRelatedJobProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :related_job_profiles, id: false do |t|
      t.integer :job_profile_id, index: true
      t.integer :related_job_profile_id, index: true
      t.timestamps
    end
  end
end
