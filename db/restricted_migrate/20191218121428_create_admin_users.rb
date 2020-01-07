class CreateAdminUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_users do |t|
      t.string :resource_id, null: false
      t.string :name, null: false
      t.citext :email, null: false
      t.timestamps
    end
  end
end
