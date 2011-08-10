module GooglePlaces
  class Spot
    attr_accessor :lat, :lng, :name, :icon, :reference, :vicinity, :types, :id, :formatted_phone_number, :formatted_address, :address_components, :rating, :url, :cid

    def self.list(lat, lng, api_key, options = {})
      radius = options.delete(:radius) || 200
      sensor = options.delete(:sensor) || false
      types  = options.delete(:types)
      name  = options.delete(:name)
      language  = options.delete(:language)
      location = Location.new(lat, lng)
      exclude = options.delete(:exclude) || []

      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
        :location => location.format,
        :radius => radius,
        :sensor => sensor,
        :key => api_key,
        :name => name,
        :language => language
      }

      # Accept Types as a string or array
      if types
        types = (types.is_a?(Array) ? types.join('|') : types)
        options.merge!(:types => types)
      end

      response = Request.spots(options)
      response['results'].map do |result|
        self.new(result) if (result['types'] & exclude) == []
      end.compact
    end

    def self.find(reference, api_key, options = {})
      sensor = options.delete(:sensor) || false
      language  = options.delete(:language)

      response = Request.spot(
        :reference => reference,
        :sensor => sensor,
        :key => api_key,
        :language => language
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
      @cid                    = json_result_object['url'].match(/cid=(\d+)/)[1].to_i
    end

  end
end
