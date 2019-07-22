if defined?(ActiveAdmin)
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
        end
      end
    end
  end
end
