class CreateAdminRoles < ActiveRecord::Migration[6.0]
  def change
    create_table :admin_roles do |t|
      t.string :name, null: false
      t.string :display_name, null: false
      t.string :description
      t.string :resource_id, null: false

      t.timestamps
    end

    create_table :admin_users_admin_roles, id: false do |t|
      t.belongs_to :admin_user
      t.belongs_to :admin_role
    end
  end
end
