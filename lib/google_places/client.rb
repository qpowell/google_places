module GooglePlaces
  class Client
    attr_reader :api_key
    attr_reader :options
    attr_reader :sensor

    def initialize(api_key, sensor = false, options = {})
      @api_key = api_key
      @sensor = sensor
      @options = options
    end

    def spots(lat, lng, options = {})
      Spot.list(lat, lng, @api_key, @sensor, @options.merge(options))
    end

    def spot(reference, options = {})
      Spot.find(reference, @api_key, @sensor, @options.merge(options))
    end

    def spots_by_query(query, options = {})
      Spot.list_by_query(query, @api_key, @sensor, @options.merge(options))
    end
  end
end
