class AddHiddenTitlesToJobProfiles < ActiveRecord::Migration[6.0]
  def change
    add_column :job_profiles, :hidden_titles, :string
  end
end
