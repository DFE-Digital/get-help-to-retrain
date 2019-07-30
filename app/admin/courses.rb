if defined?(ActiveAdmin)
  ActiveAdmin.register Course do
    permit_params :title, :provider, :url, :address_line1, :address_line2, :town, :county, :postcode,
                  :email, :topic, :phone_number, :active, :latitude, :longitude
  end
end
