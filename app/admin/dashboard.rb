if defined?(ActiveAdmin)
  # rubocop:disable Metrics/BlockLength
  ActiveAdmin.register_page 'Dashboard' do
    menu priority: 1, label: proc { I18n.t('active_admin.dashboard') }

    content title: proc { I18n.t('active_admin.dashboard') } do
      columns do
        column do
          panel 'Job Profiles' do
            h1 do
              link_to JobProfile.count, admin_job_profiles_path
            end
          end
          panel 'Categories' do
            h1 do
              link_to Category.count, admin_categories_path
            end
          end
        end
        column do
          panel 'Skills' do
            h1 do
              link_to Skill.count, admin_skills_path
            end
          end
          panel 'Admin Users' do
            h1 do
              link_to AdminUser.count, admin_admin_users_path
            end
          end
        end
        column do
          panel 'Feedback Survey' do
            h1 do
              link_to FeedbackSurvey.count, admin_feedback_surveys_path
            end
          end
          panel 'User Personal Data' do
            h1 do
              link_to UserPersonalData.count, admin_user_personal_data_path
            end
          end
        end
      end
    end
  end
  # rubocop:enable Metrics/BlockLength
end
