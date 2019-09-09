class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'citext'

    create_table :users do |t|
      t.citext :email, null: false
      t.belongs_to :session, index: true

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
