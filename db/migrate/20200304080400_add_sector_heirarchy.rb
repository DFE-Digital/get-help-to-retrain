class AddSectorHeirarchy < ActiveRecord::Migration[6.0]
  def change
    add_column :job_profiles, :heirarchy, :string
    add_column :job_profiles, :sector, :string
  end
end
