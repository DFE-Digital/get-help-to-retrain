module HealthCheck
  class PostcodesCheck < CheckBase
    CACHE_EXPIRY = 44.seconds

    def name
      'api:postcodes.io'
    end

    def value
      @value ||= Geocoder.coordinates('B1 2JP')
    rescue SocketError, Timeout::Error, Geocoder::Error => e
      @output = "Geocoder API error: #{e.message}"
      []
    end

    def unit
      'Array'
    end

    def status
      value.present? ? :pass : :warn
    end
  end
end
