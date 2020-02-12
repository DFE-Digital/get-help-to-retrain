class CreateOppa10csvs < ActiveRecord::Migration[6.0]
  def change
    create_table :oppa10csvs do |t|
      t.text :opportunity_id
      t.text :a10_code
    end
  end
end
