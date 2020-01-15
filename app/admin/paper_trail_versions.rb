if defined?(ActiveAdmin)
  # rubocop:disable Metrics/BlockLength
  ActiveAdmin.register PaperTrail::Version, as: 'Audit Logs' do
    menu priority: 11

    actions :all, except: %i[new edit destroy]

    index do
      column :id
      column 'Changed Item ID' do |version|
        next unless version.item_id.present?

        version.item ? link_to(version.item_id, [:admin, version.item]) : version.item_id
      end
      column :item_type
      column :event do |version|
        version.event.html_safe
      end
      column 'Authored by' do |version|
        whodunnit_for(version: version)
      end
      column :created_at
      actions
    end

    show do
      attributes_table do
        row :id
        row 'Changed Item ID' do |version|
          version.item ? link_to(version.item_id, [:admin, version.item]) : version.item_id
        end
        row :item_type
        row :event do |version|
          version.event.html_safe
        end
        row 'Authored by' do |version|
          whodunnit_for(version: version)
        end
        row :changes do |version|
          if version.object_changes.present?
            changes_hash = version.object_changes.except('updated_at')
            if version.event == 'search'
              "<strong>Searched for</strong>:<br>
                #{changes_hash['query']&.map { |k, v| "#{k.humanize}: <strong>#{v}</strong>" }&.join('<br>')}".concat(
                  "<br><br><strong>Results found</strong>: #{changes_hash['results']}"
                ).html_safe
            else
              changes_hash.map { |k, v|
                "<strong>#{k}: #{v.compact.join(' -> ')}</strong>"
              }.compact.join('<br>').html_safe
            end
          end
        end
        row :created_at
      end
    end

    config.sort_order = 'created_at_desc'
  end
  # rubocop:enable Metrics/BlockLength
end
