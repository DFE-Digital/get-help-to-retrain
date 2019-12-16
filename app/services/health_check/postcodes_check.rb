module HealthCheck
  class PostcodesCheck < CheckBase
    CACHE_EXPIRY = 44.seconds

    def enabled?
      Rails.configuration.admin_mode == false
    end

    def name
      'api:postcodes.io'
    end

    def value
      @value ||= fetch_value
    end

    def unit
      'Array'
    end

    def status
      value.present? ? :pass : :warn
    end

    private

    def fetch_value
      Geocoder.coordinates('B1 2JP')
    rescue SocketError, Timeout::Error, Geocoder::Error => e
      @output = "Geocoder API error: #{e.message}"
      []
    end
  end
end
