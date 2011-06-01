module GooglePlaces
  class Spot
    attr_accessor :lat, :lng, :name, :icon, :reference, :vicinity, :types, :id, :formatted_phone_number, :formatted_address, :address_components, :rating, :url

    def self.list(lat, lng, api_key, options = {})
      radius = options.delete(:radius) || 200
      sensor = options.delete(:sensor) || false
      location = Location.new(lat, lng)

      response = Request.spots(
        :location => location.format,
        :radius => radius,
        :sensor => sensor,
        :key => api_key
      )

      response['results'].map do |result|
        self.new(result)
      end
    end

    def self.find(reference, api_key, options = {})
      sensor = options.delete(:sensor) || false

      response = Request.spot(
        :reference => reference,
        :sensor => sensor,
        :key => api_key
      )

      self.new(response['result'])
    end

    def initialize(json_result_object)
      @reference              = json_result_object['reference']
      @vicinity               = json_result_object['vicinity']
      @lat                    = json_result_object['geometry']['location']['lat']
      @lng                    = json_result_object['geometry']['location']['lng']
      @name                   = json_result_object['name']
      @icon                   = json_result_object['icon']
      @types                  = json_result_object['types']
      @id                     = json_result_object['id']
      @formatted_phone_number = json_result_object['formatted_phone_number']
      @formatted_address      = json_result_object['formatted_address']
      @address_components     = json_result_object['address_components']
      @rating                 = json_result_object['rating']
      @url                    = json_result_object['url']
    end

  end
end
