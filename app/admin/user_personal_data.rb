if defined?(ActiveAdmin)
  # rubocop:disable Metrics/BlockLength
  ActiveAdmin.register UserPersonalData do
    GENDER_OPTIONS = {
      'Male' => :male,
      'Female' => :female,
      'Prefer not to say' => :not_mentioned
    }.freeze

    actions :all, except: :new

    permit_params :first_name, :last_name, :postcode, :dob, :gender

    filter :first_name
    filter :last_name
    filter :postcode
    filter :dob
    filter :gender, as: :select, collection: GENDER_OPTIONS

    controller do
      def destroy
        track_custom_event(item_type: 'User Personal Data Page', event: 'record deleted') if resource.destroy
      end
    end

    index do
      track_custom_event(
        item_type: 'User Personal Data Page',
        event: 'visited page'
      )

      column :id
      column :first_name
      column :last_name
      column :postcode
      column :dob
      column :gender
      column :created_at
      column :updated_at

      actions
    end

    csv do
      track_custom_event(
        item_type: 'User Personal Data Page',
        event: 'downloaded CSV'
      )
    end

    form do |f|
      f.semantic_errors
      f.inputs do
        f.input :first_name
        f.input :last_name
        f.input :postcode
        f.input :dob
        f.input :gender, as: :select, collection: GENDER_OPTIONS
      end
      f.actions
    end

    config.sort_order = 'id_asc'
  end
  # rubocop:enable Metrics/BlockLength
end
