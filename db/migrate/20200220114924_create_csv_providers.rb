class CreateCsvProviders < ActiveRecord::Migration[6.0]
  def change
    create_table :csv_providers do |t|
      t.bigint :external_provider_id
      t.bigint :ukprn
      t.string :name
      t.string :address_line_1
      t.string :address_line_2
      t.string :town
      t.string :county
      t.string :postcode
      t.string :phone
      t.string :email
      t.string :url
      t.timestamps
    end
  end
end
