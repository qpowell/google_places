module GooglePlaces
  class Request
    attr_accessor :response

    include ::HTTParty
    format :json

    SPOTS_LIST_URL = 'https://maps.googleapis.com/maps/api/place/search/json'
    SPOT_URL = 'https://maps.googleapis.com/maps/api/place/details/json'

    def self.spots(options = {})
      # pp options
      request = new(SPOTS_LIST_URL, options)
      request.parsed_response
    end

    def self.spot(options = {})
      # pp options
      request = new(SPOT_URL, options)
      request.parsed_response
    end

    def initialize(url, options)
      @response = self.class.get(url, :query => options)
    end

    def parsed_response
      @response.parsed_response
    end

  end
end
