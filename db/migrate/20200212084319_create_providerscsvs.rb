class CreateProviderscsvs < ActiveRecord::Migration[6.0]
  def change
    create_table :providerscsvs do |t|
      t.text :provider_id
      t.text :provider_name
      t.text :ukprn
      t.text :provider_type_id
      t.text :provider_type_description
      t.text :email
      t.text :website
      t.text :phone
      t.text :fax
      t.text :prov_trading_name
      t.text :prov_legal_name
      t.text :lsc_supplier_no
      t.text :prov_alias
      t.text :date_created
      t.text :date_updated
      t.text :ttg_flag
      t.text :tqs_flag
      t.text :ies_flag
      t.text :status
      t.text :updated_by
      t.text :created_by
      t.text :address_1
      t.text :address_2
      t.text :town
      t.text :county
      t.text :postcode
      t.text :sys_data_source
      t.text :date_updated_copy_over
      t.text :date_created_copy_over
      t.text :dfe_provider_type_id
      t.text :dfe_provider_type_description
      t.text :dfe_local_authority_code
      t.text :dfe_local_authority_description
      t.text :dfe_region_code
      t.text :dfe_region_description
      t.text :dfe_establishment_type_code
      t.text :dfe_establishment_type_description
    end
  end
end
