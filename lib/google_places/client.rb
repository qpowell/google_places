module GooglePlaces
  class Client
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def spots(lat, lng, options = {})
      Spot.list(lat, lng, @api_key, options)
    end

    def spot(reference, options = {})
      Spot.find(reference, @api_key, options)
    end
  end
end
