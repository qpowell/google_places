module GooglePlaces
  class Client
    attr_reader :api_key
    attr_reader :options

    def initialize(api_key, options = {})
      @api_key = api_key
      @options = options
    end

    def spots(lat, lng, options = {})
      Spot.list(lat, lng, @api_key, @options.merge(options))
    end

    def spot(reference, options = {})
      Spot.find(reference, @api_key, @options.merge(options))
    end

    def spots_by_query(query, options = {})
      Spot.list_by_query(query, @api_key, @options.merge(options))
    end
  end
end
