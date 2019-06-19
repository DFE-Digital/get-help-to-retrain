class CreateVersions < ActiveRecord::Migration[5.2]
  def change
    create_table :versions do |t|
      t.integer :version, null: false
      t.timestamps
    end

    add_reference :categories, :version, index: true
    add_reference :job_profiles, :version, index: true
    add_reference :skills, :version, index: true
  end
end
