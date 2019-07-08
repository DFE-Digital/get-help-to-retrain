class AddNameAlternativeTitlesDescriptionIndexToJobProfiles < ActiveRecord::Migration[5.2]
  def up
    add_index :job_profiles, "to_tsvector('english', name)", using: 'gin', name: 'job_profiles_name_idx'
    add_index :job_profiles, "to_tsvector('english', description)", using: 'gin', name: 'job_profiles_description_idx'
    add_index :job_profiles, "to_tsvector('english', alternative_titles)", using: 'gin', name: 'job_profiles_alternative_titles_idx'
  end

  def down
    remove_index :job_profiles, name: 'job_profiles_name_idx'
    remove_index :job_profiles, name: 'job_profiles_description_idx'
    remove_index :job_profiles, name: 'job_profiles_alternative_titles_idx'
  end
end
