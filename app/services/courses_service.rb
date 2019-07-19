class CoursesService
  # Still need to figure out how that would fit 
  # in a prd enviroment safely while we wait for the real data
  def self.seed
    new.seed
  end

  def seed
    answer = prompt 'This will delete all your currently stored courses! Are you sure you want to continue? [Yn]: '

    if answer.strip == 'Y'
      Course.delete_all

      create_fake_courses_for(:maths)
      create_fake_courses_for(:english)
    else
      'Operation cancelled'
    end
  end

  private

  def create_fake_courses_for(topic)
    10.times { FactoryBot.create :course, topic }
  end

  def prompt(*args)
    print(*args)
    gets
  end
end
