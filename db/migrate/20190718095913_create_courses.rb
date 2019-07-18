class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :title, null: false
      t.string :provider, null: false
      t.string :url, null: false
      t.string :address_line_1
      t.string :address_line_2
      t.string :town
      t.string :county
      t.string :postcode
      t.string :email
      t.string :topic, index: true, null: false
      t.string :phone_number
      t.boolean :active, default: false
    end
  end
end
