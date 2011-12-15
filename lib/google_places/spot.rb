module GooglePlaces
  class Spot
    attr_accessor :lat, :lng, :name, :icon, :reference, :vicinity, :types, :id, :formatted_phone_number, :international_phone_number, :formatted_address, :address_components, :street_number, :street, :city, :region, :postal_code, :country, :rating, :url, :cid, :website

    def self.list(lat, lng, api_key, options = {})
      radius = options.delete(:radius) || 200
      sensor = options.delete(:sensor) || false
      types  = options.delete(:types)
      name  = options.delete(:name)
      keyword = options.delete(:keyword)
      language  = options.delete(:language)
      location = Location.new(lat, lng)
      exclude = options.delete(:exclude) || []
      retry_options = options.delete(:retry_options) || {}

      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
        :location => location.format,
        :radius => radius,
        :sensor => sensor,
        :key => api_key,
        :name => name,
        :language => language,
        :keyword => keyword,
        :retry_options => retry_options
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
      retry_options = options.delete(:retry_options) || {}

      response = Request.spot(
        :reference => reference,
        :sensor => sensor,
        :key => api_key,
        :language => language,
        :retry_options => retry_options
      )

      self.new(response['result'])
    end

    def initialize(json_result_object)
      @reference                  = json_result_object['reference']
      @vicinity                   = json_result_object['vicinity']
      @lat                        = json_result_object['geometry']['location']['lat']
      @lng                        = json_result_object['geometry']['location']['lng']
      @name                       = json_result_object['name']
      @icon                       = json_result_object['icon']
      @types                      = json_result_object['types']
      @id                         = json_result_object['id']
      @formatted_phone_number     = json_result_object['formatted_phone_number']
      @international_phone_number = json_result_object['international_phone_number']
      @formatted_address          = json_result_object['formatted_address']
      @address_components         = json_result_object['address_components']
      @street_number              = address_component(:street_number, 'short_name')
      @street                     = address_component(:route, 'long_name')
      @city                       = address_component(:locality, 'long_name')
      @region                     = address_component(:administrative_area_level_1, 'long_name')
      @postal_code                = address_component(:postal_code, 'long_name')
      @country                    = address_component(:country, 'long_name')
      @rating                     = json_result_object['rating']
      @url                        = json_result_object['url']
      @cid                        = json_result_object['url'].to_i
      @website                    = json_result_object['website']
    end

    def address_component(address_component_type, address_component_length)
      if component = address_components_of_type(address_component_type)
        component.first[address_component_length] unless component.first.nil?
      end
    end
    
    def address_components_of_type(type)
      @address_components.select{ |c| c['types'].include?(type.to_s) } unless @address_components.nil?
    end

  end
end
