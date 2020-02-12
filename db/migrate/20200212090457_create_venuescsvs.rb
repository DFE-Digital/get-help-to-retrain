class CreateVenuescsvs < ActiveRecord::Migration[6.0]
  def change
    create_table :venuescsvs do |t|
      t.text :provider_id
      t.text :venue_id
      t.text :venue_name
      t.text :prov_venue_id
      t.text :phone
      t.text :address_1
      t.text :address_2
      t.text :town
      t.text :county
      t.text :postcode
      t.text :email
      t.text :website
      t.text :fax
      t.text :facilities
    end
  end
end
