module HealthCheck
  class CoursesCheck < CheckBase
    def name
      'database:courses'
    end

    def value
      @value ||= Course.count
    end

    def unit
      'Integer'
    end

    def status
      value.zero? ? :fail : :pass
    end
  end
end
