require 'google_places/review'

module GooglePlaces
  class Spot
    attr_accessor :lat, :lng, :name, :icon, :reference, :vicinity, :types, :id, :formatted_phone_number, :international_phone_number, :formatted_address, :address_components, :street_number, :street, :city, :region, :postal_code, :country, :rating, :url, :cid, :website, :reviews

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

      results = []
      self.multi_pages_request(:spots, options) do |result|
        results << self.new(result) if (result['types'] & exclude) == []
      end
      results
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

    def self.list_by_query(query, api_key, options)
      if options.has_key?(:lat) && options.has_key?(:lng)
        with_location = true
      else
        with_location = false
      end

      if options.has_key?(:radius)
        with_radius = true
      else
        with_radius = false
      end

      query = query
      sensor = options.delete(:sensor) || false
      location = Location.new(options.delete(:lat), options.delete(:lng)) if with_location
      radius = options.delete(:radius) if with_radius
      language = options.delete(:language)
      types = options.delete(:types)
      exclude = options.delete(:exclude) || []
      retry_options = options.delete(:retry_options) || {}

      exclude = [exclude] unless exclude.is_a?(Array)

      options = {
        :query => query,
        :sensor => sensor,
        :key => api_key,
        :language => language,
        :retry_options => retry_options
      }

      options[:location] = location.format if with_location
      options[:radius] = radius if with_radius

      # Accept Types as a string or array
      if types
        types = (types.is_a?(Array) ? types.join('|') : types)
        options.merge!(:types => types)
      end

      results = []
      self.multi_pages_request(:spots_by_query, options) do |result|
        results << self.new(result) if (result['types'] & exclude) == []
      end
      results
    end

    def self.multi_pages_request(method, options)
      begin

        response = Request.send(method, options)
        response['results'].each do |result|
          yield(result)
        end

        # request the next page if presence of a "next_page" token
        next_page = false
        unless response["next_page_token"].nil?
          options = {
            pagetoken: response["next_page_token"],
            key: options[:key],
            sensor: options[:sensor]
          }
          sleep(2) # the time the token is issued, else InvalidRequestError
          next_page = true
        end

      end while (next_page)
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
      @reviews                    = reviews_component(json_result_object['reviews'])
    end

    def address_component(address_component_type, address_component_length)
      if component = address_components_of_type(address_component_type)
        component.first[address_component_length] unless component.first.nil?
      end
    end

    def address_components_of_type(type)
      @address_components.select{ |c| c['types'].include?(type.to_s) } unless @address_components.nil?
    end

    def reviews_component(json_reviews)
      if json_reviews
        json_reviews.map { |r|
          Review.new(
              r['aspects'].empty? ? nil : r['aspects'][0]['rating'],
              r['aspects'].empty? ? nil : r['aspects'][0]['type'],
              r['author_name'],
              r['author_url'],
              r['text'],
              r['time'].to_i
          )
        }
      else []
      end
    end

  end
end
