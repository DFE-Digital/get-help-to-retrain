if defined?(ActiveAdmin)
  ActiveAdmin.register AdminUser do
    actions :index, :show

    config.sort_order = 'id_asc'
  end
end
