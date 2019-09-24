module HealthCheck
  class JobProfilesCheck < CheckBase
    def name
      'database:jobProfiles'
    end

    def value
      @value ||= JobProfile.count
    end

    def unit
      'Integer'
    end

    def status
      value.zero? ? :fail : :pass
    end
  end
end
