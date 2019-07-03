class AddAlternativeTitlesToJobProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :job_profiles, :alternative_titles, :string, array: true, null: false, default: []
  end
end
