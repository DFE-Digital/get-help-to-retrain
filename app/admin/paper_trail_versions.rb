if defined?(ActiveAdmin)
  # rubocop:disable Metrics/BlockLength
  ActiveAdmin.register PaperTrail::Version, as: 'Audit Logs' do
    menu priority: 11

    actions :all, except: %i[new edit destroy]

    index do
      column :id
      column 'Changed Item ID' do |version|
        link_to version.item_id, admin_job_profile_path(version.item_id) if version.item_id.present?
      end
      column :item_type
      column :event
      column 'Authored by User ID' do |event_entry|
        link_to event_entry.whodunnit, admin_admin_user_path(event_entry.whodunnit)
      end
      column :created_at
      actions
    end

    show do
      attributes_table do
        row :id
        row 'Changed Item ID' do |version|
          link_to version.item_id, admin_job_profile_path(version.item_id) if version.item_id.present?
        end
        row :item_type
        row :event
        row 'Authored by User ID' do |version|
          link_to version.whodunnit, admin_admin_user_path(version.whodunnit)
        end
        row :changes do |version|
          if version.object_changes.present? && version.event != 'record deleted'
            changes_hash = version.object_changes.except('updated_at')

            changes_hash.map { |k, v|
              next unless v[0].present?

              "<strong>#{k}</strong> value changed from: <strong>#{v[0]}</strong> -> <strong>#{v[1]}</strong>"
            }.compact.join('<br>').html_safe
          end
        end
        row :created_at
      end
    end

    config.sort_order = 'created_at_desc'
  end
  # rubocop:enable Metrics/BlockLength
end
