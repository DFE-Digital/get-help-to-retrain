namespace :data_import do
  # bin/rails data_import:update_skills_rarity
  desc 'Sets correct rarity ranking for all skills'
  task update_skills_rarity: :environment do
    print 'Updating rarity ranking for all skills'

    JobProfileSkill.update_rarity
  end
end
