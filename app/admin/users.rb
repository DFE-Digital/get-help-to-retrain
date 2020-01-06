if defined?(ActiveAdmin)
  ActiveAdmin.register AdminUser do
    actions :all, except: %i[new destroy update]

    config.sort_order = 'id_asc'
  end
end
