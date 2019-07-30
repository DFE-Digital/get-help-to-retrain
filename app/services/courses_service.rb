class CoursesService
  def self.seed
    new.seed
  end

  def seed
    answer = prompt 'This will delete all your currently stored courses! Are you sure you want to continue? [Yn]: '

    if answer.strip == 'Y'
      seed!
    else
      'Operation cancelled'
    end
  end

  def seed!
    Course.delete_all

    create_fake_courses_for(:maths)
    create_fake_courses_for(:english)
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
