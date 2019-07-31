if defined?(ActiveAdmin)
  # rubocop:disable Metrics/BlockLength
  ActiveAdmin.register Course do
    permit_params :title, :provider, :url, :address_line_1, :address_line_2, :town, :county, :postcode,
                  :email, :topic, :phone_number, :active, :latitude, :longitude

    filter :title
    filter :topic
    filter :provider
    filter :url
    filter :email
    filter :phone_number
    filter :town
    filter :county
    filter :postcode
    filter :latitude
    filter :longitude
    filter :active

    index do
      column :id
      column :title
      column :topic
      column :provider
      column :email
      column :phone_number
      column :postcode
      column :latitude
      column :longitude
      column :active
      actions
    end

    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :title
        f.input :topic
        f.input :provider
        f.input :address_line_1
        f.input :address_line_2
        f.input :town
        f.input :county
        f.input :postcode
        f.input :latitude, input_html: { disabled: true, readonly: true }
        f.input :longitude, input_html: { disabled: true, readonly: true }
        f.input :email
        f.input :phone_number
        f.input :url
        f.input :active
      end
      f.actions
    end

    config.sort_order = 'id_asc'
  end
  # rubocop:enable Metrics/BlockLength
end
