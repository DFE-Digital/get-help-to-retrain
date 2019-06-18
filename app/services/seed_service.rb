class SeedService
  def self.seed
    new.seed
  end

  def seed
    only_development!
    delete_all
    seed_categories
    seed_skills
    seed_job_profiles
  end

  private

  def only_development!
    raise "Not to be run outside development" unless Rails.env.development?
  end

  def delete_all
    JobProfileCategory.delete_all
    JobProfileSkill.delete_all
    JobProfile.delete_all
    Skill.delete_all
    Category.delete_all
  end

  def seed_categories
    10.times { FactoryBot.create :category }
  end

  def seed_skills
    10.times { FactoryBot.create :skill }
  end

  def seed_job_profiles
    categories = Category.all.to_a
    skills = Skill.all.to_a

    50.times do
      FactoryBot.create :job_profile, skills: skills.sample(4), categories: categories.sample(2)
    end
  end
end
