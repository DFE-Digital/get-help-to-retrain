class CreateUserPersonalData < ActiveRecord::Migration[6.0]
  def change
    create_table :user_personal_data do |t|
      t.string :first_name
      t.string :last_name
      t.string :postcode
      t.date :dob
      t.string :gender

      t.timestamps
    end
  end
end
